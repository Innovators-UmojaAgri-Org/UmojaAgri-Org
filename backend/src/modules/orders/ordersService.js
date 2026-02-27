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
  if (!["CONFIRMED", "REJECTED"].includes(status)) {
    throw new Error("Invalid status");
  }

  const order = await prisma.order.update({
    where: { id: orderId },
    data: { status },
    include: { produce: true },
  });

  if (status === "CONFIRMED") {
    // Get real storage from DB
    const storage = await prisma.storageLocation.findFirst();

    if (!storage) {
      throw new Error("No storage location available");
    }

    // Create delivery directly (skip fake storageId)
    const delivery = await prisma.delivery.create({
      data: {
        produceId: order.produceId,
        storageId: storage.id,
        status: "PENDING",
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
    include: { produce: true, seller: true, farmer: true, delivery: true },
  });
}

module.exports = {
  createOrder,
  getOrdersForFarmer,
  updateOrderStatus,
  getOrderById,
};