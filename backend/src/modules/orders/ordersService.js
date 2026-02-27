const prisma = require("../../config/prisma");
const deliveriesService = require("../deliveries/deliveriesService");

// Seller places order
async function createOrder({ produceId, sellerId, quantity, unit }) {
  const produce = await prisma.produce.findUnique({ where: { id: produceId } });
  if (!produce) throw new Error("Produce not found");

  return prisma.order.create({
    data: {
      produceId,
      sellerId,
      farmerId: produce.farmerId,
      quantity,
      unit,
      status: "PENDING",
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
  if (!["APPROVED", "REJECTED"].includes(status))
    throw new Error("Invalid status");

  const order = await prisma.order.update({
    where: { id: orderId },
    data: { status },
    include: { produce: true },
  });

  // If approved, create delivery
  if (status === "APPROVED") {
    const delivery = await deliveriesService.createDelivery({
      produceId: order.produceId,
      sellerId: order.sellerId,
      quantity: order.quantity,
      storageId: order.storageId || "DEFAULT_STORAGE_ID", 
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
    include: { produce: true, seller: true, farmer: true, delivery: true },
  });
}

module.exports = {
  createOrder,
  getOrdersForFarmer,
  updateOrderStatus,
  getOrderById,
};