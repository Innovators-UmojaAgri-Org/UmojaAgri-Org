const prisma = require("../../config/prisma");

async function getRecommendations(userId) {
  return prisma.aIResult.findMany({
    where: {
      type: { in: ["ROUTE", "DISPATCH", "VEHICLE"] },
      delivery: {
        transport: { transporterId: userId },
      },
    },
    orderBy: { createdAt: "desc" },
    take: 10,
  });
}

async function getRisks(userId) {
  return prisma.aIResult.findMany({
    where: {
      type: "CARGO_RISK",
      delivery: {
        transport: { transporterId: userId },
      },
    },
    orderBy: { createdAt: "desc" },
    take: 10,
  });
}

async function getShipmentInsights(farmerId) {
  return prisma.aIResult.findMany({
    where: {
      type: "SHIPMENT_INSIGHT",
      produce: { farmerId },
    },
    orderBy: { createdAt: "desc" },
    take: 10,
  });
}

async function getSupplyInsights(userId) {
  return prisma.alert.findMany({
    where: {
      type: "supply_insight",
      OR: [{ userId }, { userId: null }],
    },
    orderBy: { createdAt: "desc" },
    take: 5,
  });
}

// For now we manually create AI results, in future we can integrate with external AI services (e.g. OpenAI) 
// to generate insights and recommendations based on real data and parameters from the system
async function createAIResult({ type, result, produceId, deliveryId }) {
  return prisma.aIResult.create({
    data: { type, result, produceId, deliveryId },
  });
}

module.exports = {
  getRecommendations,
  getRisks,
  getShipmentInsights,
  getSupplyInsights,
  createAIResult,
};
