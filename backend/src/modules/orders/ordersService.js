const prisma = require("../../config/prisma");
const deliveriesService = require("../deliveries/deliveriesService");

// Generate human-readable order code like ORD-2026-001
async function generateOrderCode() {
  const year = new Date().getFullYear();
  const count = await prisma.order.count({
    where: {
      createdAt: {
        gte: new Date(`${year}-01-01`),
      },
    },
  });
  return `ORD-${year}-${String(count + 1).padStart(3, "0")}`;
}

// Seller places order
async function createOrder({ produceId, sellerId, quantity, unit, vehicleTypePreference, deliveryAddress }) {
  const produce = await prisma.produce.findUnique({ where: { id: produceId } });
  if (!produce) throw new Error("Produce not found");

  const amount = quantity * produce.pricePerUnit;
  const orderCode = await generateOrderCode();

  return prisma.order.create({
    data: {
      orderCode,
      produceId,
      sellerId,
      farmerId: produce.farmerId,
      quantity,
      unit: unit || produce.unit || "kg",
      amount,
      status: "PENDING",
      vehicleTypePreference: vehicleTypePreference || null,
      deliveryAddress: deliveryAddress || null,
    },
  });
}

// Farmer gets orders for approval
async function getOrdersForFarmer(farmerId) {
  return prisma.order.findMany({
    where: { farmerId },
    include: { produce: true, seller: true, delivery: true },
    orderBy: { createdAt: "desc" },
  });
}

// Farmer approves or rejects
async function updateOrderStatus(orderId, status) {
  if (!["CONFIRMED", "REJECTED"].includes(status)) {
    throw new Error("Invalid status");
  }

  const order = await prisma.order.update({
    where: { id: orderId },
    data: { status },
    include: { produce: true, delivery: true },
  });

  if (status === "CONFIRMED") {
    // Get real storage from DB
    const storage = await prisma.storageLocation.findFirst();

    if (!storage) {
      throw new Error("No storage location available");
    }

    const delivery = await prisma.delivery.create({
      data: {
        produceId: order.produceId,
        storageId: storage.id,
        status: "PENDING",
        origin: order.produce?.location || null,
        destination: order.deliveryAddress || null,
      },
    });

    // Link delivery to order
    await prisma.order.update({
      where: { id: orderId },
      data: { deliveryId: delivery.id },
    });
  }

  return order;
}

// Get order by ID
async function getOrderById(id) {
  return prisma.order.findUnique({
    where: { id },
    include: {
      produce: true,
      seller: { select: { id: true, name: true, email: true, phone: true } },
      farmer: { select: { id: true, name: true, email: true, phone: true, location: true } },
      delivery: {
        include: {
          transport: {
            include: {
              transporter: { select: { id: true, name: true, phone: true } },
              vehicle: true,
            },
          },
          events: { orderBy: { timestamp: "desc" } },
        },
      },
    },
  });
}

// Seller gets their orders
async function getOrdersBySeller(sellerId) {
  return prisma.order.findMany({
    where: { sellerId },

    include: {
      produce: {
        select: {
          id: true,
          name: true,
          pricePerUnit: true,
          unit: true,
        },
      },

      farmer: {
        select: {
          id: true,
          name: true,
        },
      },

      delivery: {
        select: {
          id: true,
          status: true,
          progressPercent: true,
          etaMinutes: true,
          currentLocation: true,
        },
      },
    },

    orderBy: {
      createdAt: "desc",
    },
  });
}

// Seller order summary: active count + total value
async function getOrderSummary(sellerId) {
  const orders = await prisma.order.findMany({
    where: { sellerId },
  });

  const activeStatuses = ["PENDING", "CONFIRMED", "ASSIGNED_TO_TRANSPORT", "IN_TRANSIT"];
  const activeOrders = orders.filter((o) => activeStatuses.includes(o.status));
  const totalValue = orders.reduce((sum, o) => sum + o.amount, 0);

  return {
    active_orders: activeOrders.length,
    total_value: totalValue,
  };
}

module.exports = {
  createOrder,
  getOrdersForFarmer,
  updateOrderStatus,
  getOrderById,
  getOrdersBySeller,
  getOrderSummary,
};