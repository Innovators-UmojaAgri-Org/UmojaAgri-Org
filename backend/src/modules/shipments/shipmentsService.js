const prisma = require("../../config/prisma");

// Generate shipment code like SH-2403
async function generateShipmentCode() {
  const now = new Date();
  const yy = String(now.getFullYear()).slice(-2);
  const mm = String(now.getMonth() + 1).padStart(2, "0");
  const count = await prisma.shipment.count({
    where: {
      createdAt: {
        gte: new Date(now.getFullYear(), now.getMonth(), 1),
      },
    },
  });
  return `SH-${yy}${mm}-${String(count + 1).padStart(3, "0")}`;
}

async function createShipment({ farmerId, cargo, weight, weightUnit, destination, price }) {
  const shipmentCode = await generateShipmentCode();

  return prisma.shipment.create({
    data: {
      shipmentCode,
      farmerId,
      cargo,
      weight,
      weightUnit: weightUnit || "kg",
      destination,
      price: price || 0,
    },
  });
}

async function getShipmentsByFarmer(farmerId) {
  return prisma.shipment.findMany({
    where: { farmerId },
    include: {
      transporter: {
        select: {
          id: true,
          name: true,
          transporterProfile: {
            select: { companyName: true, rating: true },
          },
        },
      },
      route: {
        select: {
          origin: true,
          destination: true,
          distanceKm: true,
          estimatedTimeMinutes: true,
        },
      },
    },
    orderBy: { createdAt: "desc" },
  });
}

async function getShipmentSummary(farmerId) {
  const shipments = await prisma.shipment.findMany({
    where: { farmerId },
  });

  const activeStatuses = ["PENDING", "TRANSPORTER_ASSIGNED", "PICKED_UP", "IN_TRANSIT"];
  const activeShipments = shipments.filter((s) => activeStatuses.includes(s.status));

  // Count unique routes
  const routeIds = new Set(shipments.filter((s) => s.routeId).map((s) => s.routeId));

  return {
    active_shipments: activeShipments.length,
    total_shipments: shipments.length,
    routes: routeIds.size,
  };
}

async function getShipmentById(id) {
  return prisma.shipment.findUnique({
    where: { id },
    include: {
      farmer: { select: { id: true, name: true, location: true } },
      transporter: {
        select: {
          id: true,
          name: true,
          transporterProfile: true,
        },
      },
      route: {
        include: { stops: { orderBy: { stopOrder: "asc" } } },
      },
    },
  });
}

async function selectTransporter(shipmentId, transporterId) {
  return prisma.shipment.update({
    where: { id: shipmentId },
    data: {
      transporterId,
      status: "TRANSPORTER_ASSIGNED",
    },
    include: {
      transporter: {
        select: {
          id: true,
          name: true,
          transporterProfile: {
            select: { companyName: true, estimatedDeliveryHours: true },
          },
        },
      },
    },
  });
}

async function getRecommendedTransporter(shipmentId) {
  // Find transporter with highest rating and recommend based on that just for now 
  const transporter = await prisma.transporterProfile.findFirst({
    orderBy: { rating: "desc" },
    include: {
      user: { select: { id: true, name: true } },
    },
  });

  if (!transporter) return null;

  return {
    id: transporter.userId,
    company_name: transporter.companyName,
    rating: transporter.rating,
    reason: "Highest rated and most reliable transporter available",
  };
}

async function getShipmentsByTransporter(transporterId) {
  return prisma.shipment.findMany({
    where: { transporterId },
    include: {
      farmer: { select: { id: true, name: true, location: true } },
      route: {
        select: { origin: true, destination: true, distanceKm: true, estimatedTimeMinutes: true },
      },
    },
    orderBy: { createdAt: 'desc' },
  });
}

async function acceptShipment(shipmentId, transporterId) {
  const shipment = await prisma.shipment.findUnique({ where: { id: shipmentId } });
  if (!shipment) throw new Error('Shipment not found');
  if (shipment.transporterId !== transporterId) throw new Error('Not authorized');
  if (shipment.status !== 'TRANSPORTER_ASSIGNED') throw new Error('Shipment is not awaiting acceptance');
  return prisma.shipment.update({
    where: { id: shipmentId },
    data: { status: 'PICKED_UP' },
  });
}

async function declineShipment(shipmentId, transporterId) {
  const shipment = await prisma.shipment.findUnique({ where: { id: shipmentId } });
  if (!shipment) throw new Error('Shipment not found');
  if (shipment.transporterId !== transporterId) throw new Error('Not authorized');
  if (shipment.status !== 'TRANSPORTER_ASSIGNED') throw new Error('Shipment cannot be declined at this stage');
  return prisma.shipment.update({
    where: { id: shipmentId },
    data: { status: 'PENDING', transporterId: null },
  });
}

async function updateShipmentStatusByTransporter(shipmentId, transporterId, status) {
  const allowed = ['IN_TRANSIT', 'DELIVERED'];
  if (!allowed.includes(status)) throw new Error('Invalid status');
  const shipment = await prisma.shipment.findUnique({ where: { id: shipmentId } });
  if (!shipment) throw new Error('Shipment not found');
  if (shipment.transporterId !== transporterId) throw new Error('Not authorized');
  return prisma.shipment.update({
    where: { id: shipmentId },
    data: { status },
  });
}

module.exports = {
  createShipment,
  getShipmentsByFarmer,
  getShipmentSummary,
  getShipmentById,
  selectTransporter,
  getRecommendedTransporter,
  getShipmentsByTransporter,
  acceptShipment,
  declineShipment,
  updateShipmentStatusByTransporter,
};
