const prisma = require("../../config/prisma");

async function getSellerDashboard(userId) {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    select: { id: true, name: true, location: true },
  });

  const [notificationsCount, cartCount, alerts, deliveries, products, orders] =
    await Promise.all([
      prisma.notification.count({ where: { userId, read: false } }),
      prisma.cartItem.count({ where: { userId } }),
      prisma.alert.findMany({
        where: { OR: [{ userId }, { userId: null }] },
        orderBy: { createdAt: "desc" },
        take: 5,
      }),
      prisma.delivery.findMany({
        where: { order: { sellerId: userId } },
        include: {
          produce: { select: { name: true } },
          order: { select: { quantity: true, unit: true } },
          transport: {
            include: { transporter: { select: { name: true } } },
          },
        },
        orderBy: { createdAt: "desc" },
        take: 5,
      }),
      prisma.produce.findMany({
        include: {
          owner: { select: { id: true, name: true } },
        },
        orderBy: { createdAt: "desc" },
        take: 10,
      }),
      prisma.order.findMany({
        where: { sellerId: userId },
      }),
    ]);

  const activeStatuses = ["PENDING", "CONFIRMED", "ASSIGNED_TO_TRANSPORT", "IN_TRANSIT"];
  const activeOrders = orders.filter((o) => activeStatuses.includes(o.status));
  const totalValue = orders.reduce((sum, o) => sum + o.amount, 0);

  return {
    user,
    notifications_count: notificationsCount,
    cart_items: cartCount,
    alerts,
    deliveries,
    products,
    summary: {
      active_orders: activeOrders.length,
      total_value: totalValue,
    },
  };
}

async function getFarmerDashboard(userId) {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    select: { id: true, name: true, location: true, phone: true },
  });

  const now = new Date();
  const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

  const [notificationsCount, monthlyOrders, produces, shipments] =
    await Promise.all([
      prisma.notification.count({ where: { userId, read: false } }),
      prisma.order.findMany({
        where: { farmerId: userId, status: "DELIVERED", createdAt: { gte: startOfMonth } },
      }),
      prisma.produce.findMany({
        where: { farmerId: userId },
        select: { name: true, quantity: true },
      }),
      prisma.shipment.findMany({
        where: { farmerId: userId },
        orderBy: { createdAt: "desc" },
        take: 5,
      }),
    ]);

  const monthlyRevenue = monthlyOrders.reduce((sum, o) => sum + o.amount, 0);

  // Yield trends
  const yields = {};
  for (const p of produces) {
    yields[p.name] = (yields[p.name] || 0) + p.quantity;
  }

  return {
    user,
    notifications_count: notificationsCount,
    monthly_revenue: {
      month: now.toLocaleString("en-US", { month: "long" }),
      amount: monthlyRevenue,
      currency: "NGN",
    },
    yield_trends: Object.entries(yields).map(([crop, y]) => ({ crop, yield: y })),
    recent_shipments: shipments,
  };
}

async function getDriverDashboard(userId) {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    select: {
      id: true,
      name: true,
      location: true,
      driverProfile: true,
    },
  });

  const [notificationsCount, shipments] = await Promise.all([
    prisma.notification.count({ where: { userId, read: false } }),
    prisma.shipment.findMany({
      where: {
        transporterId: userId,
        status: { in: ["TRANSPORTER_ASSIGNED", "PICKED_UP", "IN_TRANSIT"] },
      },
      include: {
        route: { include: { stops: { orderBy: { stopOrder: "asc" } } } },
        farmer: { select: { name: true, location: true } },
      },
      orderBy: { createdAt: "desc" },
    }),
  ]);

  const totalWeight = shipments.reduce((sum, s) => sum + s.weight, 0);

  return {
    driver: {
      id: user.id,
      name: user.name,
      status: user.driverProfile?.status || "active",
    },
    notifications_count: notificationsCount,
    load: {
      total_weight: totalWeight,
      active_shipments: shipments.length,
    },
    shipments,
  };
}

module.exports = {
  getSellerDashboard,
  getFarmerDashboard,
  getDriverDashboard,
};
