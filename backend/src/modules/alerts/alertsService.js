const prisma = require("../../config/prisma");

async function getAlertsByUser(userId) {
  return prisma.alert.findMany({
    where: {
      OR: [{ userId }, { userId: null }],
    },
    orderBy: { createdAt: "desc" },
  });
}

async function createAlert({ type, message, recommendation, severity, userId }) {
  return prisma.alert.create({
    data: { type, message, recommendation, severity, userId },
  });
}

module.exports = { getAlertsByUser, createAlert };
