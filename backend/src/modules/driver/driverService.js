const prisma = require("../../config/prisma");

async function getDriverProfile(userId) {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    select: {
      id: true,
      name: true,
      location: true,
      driverProfile: true,
    },
  });

  if (!user) throw new Error("User not found");

  return {
    id: user.id,
    name: user.name,
    location: user.location,
    status: user.driverProfile?.status || "active",
    licenseNumber: user.driverProfile?.licenseNumber,
    experienceYears: user.driverProfile?.experienceYears,
    rating: user.driverProfile?.rating,
    dynamicRouting: user.driverProfile?.dynamicRouting || false,
  };
}

async function getDriverShipments(userId) {
  return prisma.shipment.findMany({
    where: { transporterId: userId },
    include: {
      farmer: { select: { id: true, name: true } },
      route: {
        include: { stops: { orderBy: { stopOrder: "asc" } } },
      },
    },
    orderBy: { createdAt: "desc" },
  });
}

async function getCurrentLoad(userId) {
  const activeShipments = await prisma.shipment.findMany({
    where: {
      transporterId: userId,
      status: { in: ["TRANSPORTER_ASSIGNED", "PICKED_UP", "IN_TRANSIT"] },
    },
    include: {
      route: {
        include: { stops: { orderBy: { stopOrder: "asc" } } },
      },
    },
  });

  const totalWeight = activeShipments.reduce((sum, s) => sum + s.weight, 0);

  // Count remaining stops across all active shipments
  const totalStops = activeShipments.reduce((sum, s) => {
    return sum + (s.route?.stops?.length || 0);
  }, 0);

  const deliveredCount = activeShipments.filter(
    (s) => s.status === "DELIVERED"
  ).length;

  const progressPercent =
    activeShipments.length > 0
      ? Math.round((deliveredCount / activeShipments.length) * 100)
      : 0;

  return {
    total_weight: totalWeight,
    weight_unit: "kg",
    active_shipments: activeShipments.length,
    remaining_stops: totalStops,
    progress_percent: progressPercent,
  };
}

async function getDriverPerformance(userId) {
  const shipments = await prisma.shipment.findMany({
    where: {
      transporterId: userId,
      status: "DELIVERED",
    },
    select: {
      estimatedArrival: true,
      updatedAt: true,
    },
  });

  const total = shipments.length;
  if (total === 0) {
    return { total_deliveries: 0, on_time_percent: 0, late_percent: 0 };
  }

  const onTime = shipments.filter((s) => {
    if (!s.estimatedArrival) return true;
    return s.updatedAt <= s.estimatedArrival;
  }).length;

  const onTimePercent = Math.round((onTime / total) * 100);

  return {
    total_deliveries: total,
    on_time_percent: onTimePercent,
    late_percent: 100 - onTimePercent,
  };
}

// For now we only have one setting (dynamic routing) but in future we can expand this to include more driver preferences and settings (e.g. preferred routes, max load, etc.)
async function updateDriverSettings(userId, settings) {
  return prisma.driverProfile.update({
    where: { userId },
    data: {
      dynamicRouting: settings.dynamicRouting,
    },
  });
}

module.exports = {
  getDriverProfile,
  getDriverShipments,
  getCurrentLoad,
  getDriverPerformance,
  updateDriverSettings,
};
