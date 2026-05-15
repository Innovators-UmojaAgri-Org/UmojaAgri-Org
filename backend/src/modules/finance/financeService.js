const prisma = require("../../config/prisma");

// Get or create wallet for user
async function getWallet(userId) {
  let wallet = await prisma.wallet.findUnique({
    where: { userId },
  });

  if (!wallet) {
    wallet = await prisma.wallet.create({
      data: { userId },
    });
  }

  return wallet;
}

async function getTransactions(userId) {
  const wallet = await getWallet(userId);
  return prisma.transaction.findMany({
    where: { walletId: wallet.id },
    orderBy: { createdAt: "desc" },
  });
}

// Later Payment gateway integration can be added here (e.g. Stripe, PayPal) to handle real money transactions and payouts to farmers/sellers.
// For now we just simulate transactions within the system.
async function createTransaction({ userId, type, amount, description }) {
  const wallet = await getWallet(userId);

  const reference = `TXN-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;

  const transaction = await prisma.$transaction(async (tx) => {
    const txn = await tx.transaction.create({
      data: {
        walletId: wallet.id,
        type,
        amount,
        description,
        reference,
      },
    });

    const balanceChange =
      type === "CREDIT" || type === "REFUND" ? amount : -amount;

    await tx.wallet.update({
      where: { id: wallet.id },
      data: { balance: { increment: balanceChange } },
    });

    return txn;
  });

  return transaction;
}

// Make a payment (debit from buyer, credit to seller)
async function makePayment({ payerId, recipientId, amount, description }) {
  const payerWallet = await getWallet(payerId);

  if (payerWallet.balance < amount) {
    throw new Error("Insufficient wallet balance");
  }

  const refBase = `PAY-${Date.now()}`;

  await prisma.$transaction(async (tx) => {
    // Debit payer
    await tx.transaction.create({
      data: {
        walletId: payerWallet.id,
        type: "PAYMENT",
        amount,
        description: description || "Payment sent",
        reference: `${refBase}-debit`,
      },
    });
    await tx.wallet.update({
      where: { id: payerWallet.id },
      data: { balance: { decrement: amount } },
    });

    // Credit recipient
    const recipientWallet = await getWallet(recipientId);
    await tx.transaction.create({
      data: {
        walletId: recipientWallet.id,
        type: "CREDIT",
        amount,
        description: description || "Payment received",
        reference: `${refBase}-credit`,
      },
    });
    await tx.wallet.update({
      where: { id: recipientWallet.id },
      data: { balance: { increment: amount } },
    });
  });

  return { success: true, amount };
}

module.exports = {
  getWallet,
  getTransactions,
  createTransaction,
  makePayment,
};
