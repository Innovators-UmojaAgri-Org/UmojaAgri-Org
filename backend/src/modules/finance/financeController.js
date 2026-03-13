const financeService = require("./financeService");

async function getWallet(req, res) {
  try {
    const wallet = await financeService.getWallet(req.user.userId);
    res.json({ success: true, data: wallet });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getTransactions(req, res) {
  try {
    const transactions = await financeService.getTransactions(req.user.userId);
    res.json({ success: true, count: transactions.length, data: transactions });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function fundWallet(req, res) {
  try {
    const txn = await financeService.createTransaction({
      userId: req.user.userId,
      type: "CREDIT",
      amount: req.body.amount,
      description: req.body.description || "Wallet top-up",
    });
    res.status(201).json({ success: true, data: txn });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

async function makePayment(req, res) {
  try {
    const result = await financeService.makePayment({
      payerId: req.user.userId,
      recipientId: req.body.recipientId,
      amount: req.body.amount,
      description: req.body.description,
    });
    res.json({ success: true, data: result });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

module.exports = { getWallet, getTransactions, fundWallet, makePayment };
