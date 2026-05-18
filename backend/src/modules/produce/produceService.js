const prisma = require("../../config/prisma");

async function createProduce(data) {
  return prisma.produce.create({
    data: {
      name: data.name,
      description: data.description,
      quantity: data.quantity,
      unit: data.unit,
      category: data.category || null,
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

async function getMarketplaceProduces({ category } = {}) {
  return prisma.produce.findMany({
    where: category ? { category } : undefined,
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

// Returns a farmer's profile + their produce list — used by seller on Place Order page
async function getFarmerWithProduce(farmerId) {
  const farmer = await prisma.user.findUnique({
    where: { id: farmerId },
    select: {
      id: true,
      name: true,
      location: true,
      phone: true,
      isOnline: true,
      transporterProfile: false,
      driverProfile: false,
      produce: {
        select: {
          id: true,
          name: true,
          description: true,
          quantity: true,
          unit: true,
          category: true,
          pricePerUnit: true,
          freshnessScore: true,
          imageUrl: true,
          location: true,
          harvestDate: true,
          expiryDate: true,
        },
        orderBy: { createdAt: "desc" },
      },
      _count: { select: { farmerOrders: true } },
    },
  });

  if (!farmer) throw new Error("Farmer not found");
  return farmer;
}

module.exports = {
  createProduce,
  getProducesByFarmer,
  updateProduce,
  deleteProduce,
  getAllProduces,
  getMarketplaceProduces,
  getFarmerWithProduce,
};
