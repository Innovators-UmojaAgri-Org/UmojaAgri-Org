const prisma = require("../../config/prisma");

async function createProduce(data) {
  return prisma.produce.create({
    data: {
      name: data.name,
      description: data.description,
      quantity: data.quantity,
      unit: data.unit,
      pricePerUnit: data.pricePerUnit || 0,
      freshnessScore: data.freshnessScore,
      imageUrl: data.imageUrl,
      location: data.location,
      harvestDate: data.harvestDate ? new Date(data.harvestDate) : undefined,
      expiryDate: data.expiryDate ? new Date(data.expiryDate) : undefined,
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

async function getMarketplaceProduces() {
  return prisma.produce.findMany({
    include: {
      owner: {
        select: {
          id: true,
          name: true,
          email: true,
        },
      },
    },
    orderBy: {
      createdAt: "desc",
    },
  });
}

module.exports = {
  createProduce,
  getProducesByFarmer,
  updateProduce,
  deleteProduce,
  getAllProduces,
  getMarketplaceProduces,
};
