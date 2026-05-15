const prisma = require("../../config/prisma");

async function getCart(userId) {
  return prisma.cartItem.findMany({
    where: { userId },
    include: {
      produce: {
        select: {
          id: true,
          name: true,
          pricePerUnit: true,
          unit: true,
          imageUrl: true,
          freshnessScore: true,
          owner: { select: { id: true, name: true } },
        },
      },
    },
    orderBy: { createdAt: "desc" },
  });
}

async function getCartCount(userId) {
  return prisma.cartItem.count({ where: { userId } });
}

async function addToCart({ userId, produceId, quantity }) {
  return prisma.cartItem.upsert({
    where: { userId_produceId: { userId, produceId } },
    update: { quantity },
    create: { userId, produceId, quantity },
  });
}

async function updateCartItem(userId, produceId, quantity) {
  return prisma.cartItem.update({
    where: { userId_produceId: { userId, produceId } },
    data: { quantity },
  });
}

async function removeFromCart(userId, produceId) {
  return prisma.cartItem.delete({
    where: { userId_produceId: { userId, produceId } },
  });
}

async function clearCart(userId) {
  return prisma.cartItem.deleteMany({ where: { userId } });
}

module.exports = {
  getCart,
  getCartCount,
  addToCart,
  updateCartItem,
  removeFromCart,
  clearCart,
};
