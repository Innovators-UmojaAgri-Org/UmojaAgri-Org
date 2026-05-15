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
  return prisma.user.findUnique({
    where: { id: userId },
    select: {
      id: true,
      email: true,
      name: true,
      location: true,
      phone: true,
      role: { select: { name: true } },
      createdAt: true,
    },
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
};
