const prisma = require("../../config/prisma");
const bcrypt = require("bcryptjs");

async function registerUser(data) {
  const hashedPassword = await bcrypt.hash(data.password, 10);

  return prisma.user.create({
    data: {
      email: data.email,
      password: hashedPassword,
      name: data.name,
      location: data.location,
      phone: data.phone,
      roleId: data.roleId,
    },
  });
}

async function findUserByEmail(email) {
  return prisma.user.findUnique({
    where: { email },
    include: { role: true },
  });
}

async function getUserProfile(userId) {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    select: {
      id: true,
      email: true,
      name: true,
      location: true,
      phone: true,
      isOnline: true,
      role: { select: { name: true } },
      createdAt: true,
      produce: { select: { id: true } },
      sellerOrders: { select: { id: true } },
      transporterProfile: { select: { rating: true, companyName: true, vehicleType: true } },
      driverProfile: { select: { rating: true, licenseNumber: true } },
    },
  });

  if (!user) return null;

  const role = user.role?.name;
  let rating = null;
  let listingsCount = 0;

  if (role === "FARMER") {
    listingsCount = user.produce.length;
  } else if (role === "SELLER") {
    listingsCount = user.sellerOrders.length;
    rating = null;
  } else if (role === "TRANSPORTER") {
    rating = user.transporterProfile?.rating ?? user.driverProfile?.rating ?? null;
  }

  return {
    id: user.id,
    email: user.email,
    name: user.name,
    location: user.location,
    phone: user.phone,
    isOnline: user.isOnline,
    role: role,
    rating,
    listingsCount,
    transporterProfile: user.transporterProfile || null,
    driverProfile: user.driverProfile || null,
    createdAt: user.createdAt,
  };
}

async function setOnlineStatus(userId, isOnline) {
  return prisma.user.update({
    where: { id: userId },
    data: { isOnline },
    select: { id: true, isOnline: true },
  });
}

async function updateUserProfile(userId, data) {
  return prisma.user.update({
    where: { id: userId },
    data: {
      name: data.name,
      location: data.location,
      phone: data.phone,
    },
    select: {
      id: true,
      email: true,
      name: true,
      location: true,
      phone: true,
      role: { select: { name: true } },
    },
  });
}

module.exports = {
  registerUser,
  findUserByEmail,
  getUserProfile,
  updateUserProfile,
  setOnlineStatus,
};
