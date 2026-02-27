const prisma = require("../../config/prisma");

async function createDelivery({ produceId, sellerId, quantity, storageId }) {
  // 1. Fetch produce
  const produce = await prisma.produce.findUnique({ where: { id: produceId } });
  if (!produce) throw new Error("Produce not found");

  // 2. Validate quantity
  if (produce.quantity < quantity) throw new Error("Insufficient quantity");

  // 3. Transaction: reduce produce quantity + create delivery
  const result = await prisma.$transaction(async (tx) => {
    const updatedProduce = await tx.produce.update({
      where: { id: produceId },
      data: { quantity: produce.quantity - quantity },
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

async function updateDeliveryStatus(id, status) {
  // 1. Update delivery
  const delivery = await prisma.delivery.update({
    where: { id },
    data: { status },
  });

  // 2. Log event
  await prisma.deliveryEvent.create({
    data: {
      deliveryId: id,
      status,
      location: "SYSTEM", // later update dynamically
    },
  });

  return delivery;
}

module.exports = {
  createDelivery,
  getDeliveries,
  getDeliveryById,
  updateDeliveryStatus,
};
