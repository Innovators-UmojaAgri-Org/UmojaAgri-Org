const prisma = require("../../config/prisma");

async function createProduce(data) {
  return prisma.produce.create({
    data: {
      name: data.name,
      quantity: data.quantity,
      unit: data.unit,
      harvestDate: new Date(data.harvestDate),
      expiryDate: new Date(data.expiryDate),
      farmerId: data.farmerId,
    },
  });
}

async function getProducesByFarmer(farmerId) {
  return prisma.produce.findMany({
    where: { farmerId },
    orderBy: { createdAt: "desc" },
  });
}

async function updateProduce(id, data, farmerId) {
  return prisma.produce.updateMany({
    where: { id, farmerId },
    data,
  });
}

async function deleteProduce(id, farmerId) {
  return prisma.produce.deleteMany({
    where: { id, farmerId },
  });
}

async function getAllProduces() {
  return prisma.produce.findMany({
    orderBy: { createdAt: "desc" },
    include: { owner: { select: { name: true, email: true } } },
  });
}

module.exports = {
  createProduce,
  getProducesByFarmer,
  updateProduce,
  deleteProduce,
  getAllProduces,
};
