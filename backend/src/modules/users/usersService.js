const prisma = require("../../config/prisma");
const bcrypt = require("bcryptjs");

async function registerUser(data) {
  const hashedPassword = await bcrypt.hash(data.password, 10);

  return prisma.user.create({
    data: {
      email: data.email,
      password: hashedPassword,
      name: data.name,
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

module.exports = {
  registerUser,
  findUserByEmail,
};
