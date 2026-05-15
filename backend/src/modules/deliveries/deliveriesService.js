const prisma = require("../../config/prisma");

async function createDelivery({ produceId, sellerId, quantity, storageId }) {
  const produce = await prisma.produce.findUnique({ where: { id: produceId } });
  if (!produce) throw new Error("Produce not found");

  // Validate quantity
  if (produce.quantity < quantity) throw new Error("Insufficient quantity");

  // Transaction: reduce produce quantity + create delivery
  const result = await prisma.$transaction(async (tx) => {

    // const updatedProduce = await tx.produce.update({
    //   where: { id: produceId },
    //   data: { quantity: produce.quantity - quantity },
    // });

    // To handle concurrent orders, used decrement operator
    await tx.produce.update({ 
      where: { id: produceId },
      data: {
        quantity: {
          decrement: quantity,
        },
      },
    });

    const delivery = await tx.delivery.create({
      data: {
        produceId,
        storageId,
        status: "PENDING",
      },
    });

    return delivery;
  });

  return result;
}

async function getDeliveries() {
  return prisma.delivery.findMany({
    include: { produce: true, transport: true, events: true },
  });
}

async function getDeliveryById(id) {
  return prisma.delivery.findUnique({
    where: { id },
    include: { produce: true, transport: true, events: true },
  });
}

async function updateDeliveryStatus(id, status, location = "SYSTEM", io = null) {
  // Update delivery
  const delivery = await prisma.delivery.update({
    where: { id },
    data: { status },
    include: { order: true }, // include linked order
  });

  // 2. Log delivery event
  const event = await prisma.deliveryEvent.create({
    data: {
      deliveryId: id,
      status,
      location,
    },
  });

  // Sync order status
  if (delivery.order) {
    let orderStatus;
    switch (status) {
      case "ASSIGNED":
        orderStatus = "ASSIGNED_TO_TRANSPORT";
        break;
      case "IN_TRANSIT":
        orderStatus = "IN_TRANSIT";
        break;
      case "DELIVERED":
        orderStatus = "DELIVERED";
        break;
      case "CANCELLED":
        orderStatus = "CANCELLED";
        break;
      default:
        orderStatus = delivery.order.status; 
    }

    if (orderStatus !== delivery.order.status) {
      await prisma.order.update({
        where: { id: delivery.order.id },
        data: { status: orderStatus },
      });

      // notify seller via socket.io
      if (io) {
        io.to(delivery.order.sellerId).emit("orderStatusUpdated", {
          orderId: delivery.order.id,
          status: orderStatus,
          timestamp: new Date(),
        });
      }
    }
  }

  // Emit delivery update via socket.io
  if (io) {
    io.to(id).emit("deliveryStatusUpdated", {
      deliveryId: id,
      status,
      location,
      timestamp: event.timestamp,
    });
  }

  return delivery;
}

async function getIncomingDeliveries(sellerId) {
  return prisma.delivery.findMany({
    where: {
      order: {
        sellerId: sellerId,
      },
    },

    include: {
      produce: {
        select: {
          name: true,
        },
      },

      order: {
        select: {
          id: true,
          quantity: true,
          unit: true,
          farmer: {
            select: {
              id: true,
              name: true,
              location: true,
            },
          },
        },
      },

      transport: {
        include: {
          transporter: {
            select: {
              id: true,
              name: true,
            },
          },
        },
      },
    },

    orderBy: {
      createdAt: "desc",
    },
  });
}

module.exports = {
  createDelivery,
  getDeliveries,
  getDeliveryById,
  updateDeliveryStatus,
  getIncomingDeliveries,
};
