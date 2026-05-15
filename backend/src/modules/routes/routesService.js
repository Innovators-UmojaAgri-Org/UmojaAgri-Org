const prisma = require("../../config/prisma");

async function getCurrentRoute(shipmentId) {
  const shipment = await prisma.shipment.findUnique({
    where: { id: shipmentId },
    include: {
      route: {
        include: { stops: { orderBy: { stopOrder: "asc" } } },
      },
    },
  });

  if (!shipment || !shipment.route) return null;

  const route = shipment.route;
  return {
    id: route.id,
    origin: route.origin,
    destination: route.destination,
    distance_km: route.distanceKm,
    estimated_time_hours: Math.round((route.estimatedTimeMinutes / 60) * 10) / 10,
    risk_level: route.riskLevel,
    fuel_cost: route.fuelCost,
    toll_cost: route.tollCost,
    total_cost: (route.fuelCost || 0) + (route.tollCost || 0),
    waypoints: route.stops.map((s) => s.location),
  };
}

async function getRouteCost(routeId) {
  const route = await prisma.route.findUnique({ where: { id: routeId } });
  if (!route) throw new Error("Route not found");

  return {
    fuel_cost: route.fuelCost || 0,
    toll_cost: route.tollCost || 0,
    total_cost: (route.fuelCost || 0) + (route.tollCost || 0),
  };
}

async function getAlternativeRoutes(origin, destination) {
  return prisma.route.findMany({
    where: { origin, destination },
    include: { stops: { orderBy: { stopOrder: "asc" } } },
    orderBy: { distanceKm: "asc" },
  });
}

async function getRouteWaypoints(routeId) {
  const stops = await prisma.routeStop.findMany({
    where: { routeId },
    orderBy: { stopOrder: "asc" },
  });

  return stops.map((s) => s.location);
}

async function acceptRoute(shipmentId, routeId) {
  return prisma.shipment.update({
    where: { id: shipmentId },
    data: {
      routeId,
      routeAccepted: true,
    },
  });
}

// for MVP we mannually create routes, in future we can integrate with external routing APIs (Google Maps) to generate routes based on origin/destination and other parameters
async function createRoute({ origin, destination, distanceKm, estimatedTimeMinutes, riskLevel, fuelCost, tollCost, stops }) {
  return prisma.route.create({
    data: {
      origin,
      destination,
      distanceKm,
      estimatedTimeMinutes,
      riskLevel,
      fuelCost,
      tollCost,
      stops: stops
        ? {
            create: stops.map((location, index) => ({
              location,
              stopOrder: index + 1,
            })),
          }
        : undefined,
    },
    include: { stops: { orderBy: { stopOrder: "asc" } } },
  });
}

module.exports = {
  getCurrentRoute,
  getRouteCost,
  getAlternativeRoutes,
  getRouteWaypoints,
  acceptRoute,
  createRoute,
};
