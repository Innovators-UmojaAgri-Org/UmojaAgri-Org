const prisma = require("../../config/prisma");

async function listTransporters() {
  const profiles = await prisma.transporterProfile.findMany({
    include: {
      user: {
        select: { id: true, name: true, location: true },
      },
    },
    orderBy: { rating: "desc" },
  });

  return profiles.map((p) => ({
    id: p.userId,
    name: p.companyName,
    rating: p.rating,
    price_per_km: p.pricePerKm,
    vehicle_type: p.vehicleType,
    estimated_delivery_hours: p.estimatedDeliveryHours,
    location: p.user.location,
  }));
}

async function getTransporterById(userId) {
  const profile = await prisma.transporterProfile.findUnique({
    where: { userId },
    include: {
      user: {
        select: { id: true, name: true, location: true, email: true },
      },
    },
  });

  if (!profile) throw new Error("Transporter not found");

  return {
    id: profile.userId,
    name: profile.companyName,
    rating: profile.rating,
    price_per_km: profile.pricePerKm,
    vehicle_type: profile.vehicleType,
    estimated_delivery_hours: profile.estimatedDeliveryHours,
    location: profile.user.location,
    email: profile.user.email,
  };
}

async function createTransporterProfile({ userId, companyName, pricePerKm, vehicleType, estimatedDeliveryHours }) {
  return prisma.transporterProfile.create({
    data: {
      userId,
      companyName,
      pricePerKm: pricePerKm || 0,
      vehicleType,
      estimatedDeliveryHours,
    },
  });
}

module.exports = {
  listTransporters,
  getTransporterById,
  createTransporterProfile,
};
