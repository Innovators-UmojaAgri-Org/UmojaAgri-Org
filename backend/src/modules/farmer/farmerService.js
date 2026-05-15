const prisma = require("../../config/prisma");

async function getFarmerProfile(userId) {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    select: {
      id: true,
      name: true,
      location: true,
      phone: true,
      email: true,
    },
  });

  if (!user) throw new Error("User not found");

  const notificationsCount = await prisma.notification.count({
    where: { userId, read: false },
  });

  return {
    ...user,
    notifications_count: notificationsCount,
  };
}

async function getFarmerRevenue(userId) {
  const now = new Date();
  const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

  const orders = await prisma.order.findMany({
    where: {
      farmerId: userId,
      status: "DELIVERED",
      createdAt: { gte: startOfMonth },
    },
  });

  const amount = orders.reduce((sum, o) => sum + o.amount, 0);

  const monthName = now.toLocaleString("en-US", { month: "long" });

  return {
    month: monthName,
    amount,
    currency: "NGN",
  };
}

async function getYieldTrends(userId) {
  const produces = await prisma.produce.findMany({
    where: { farmerId: userId },
    select: { name: true, quantity: true },
  });

  // Aggregate yields per crop name
  const yields = {};
  for (const p of produces) {
    if (!yields[p.name]) {
      yields[p.name] = 0;
    }
    yields[p.name] += p.quantity;
  }

  return Object.entries(yields).map(([crop, yieldValue]) => ({
    crop,
    yield: yieldValue,
  }));
}

module.exports = {
  getFarmerProfile,
  getFarmerRevenue,
  getYieldTrends,
};
