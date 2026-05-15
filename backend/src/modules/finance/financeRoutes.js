const express = require("express");
const router = express.Router();
const auth = require("../../shared/middleware/auth");
const {
  getWallet,
  getTransactions,
  fundWallet,
  makePayment,
} = require("./financeController");

/**
 * @swagger
 * /api/finance/wallet:
 *   get:
 *     tags: [Finance]
 *     summary: Get current user's wallet
 *     responses:
 *       200:
 *         description: Wallet details with balance
 */
router.get("/wallet", auth, getWallet);

/**
 * @swagger
 * /api/finance/transactions:
 *   get:
 *     tags: [Finance]
 *     summary: Get transaction history
 *     responses:
 *       200:
 *         description: List of transactions
 */
router.get("/transactions", auth, getTransactions);

/**
 * @swagger
 * /api/finance/fund:
 *   post:
 *     tags: [Finance]
 *     summary: Fund wallet
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [amount]
 *             properties:
 *               amount:
 *                 type: number
 *     responses:
 *       200:
 *         description: Wallet funded
 */
router.post("/fund", auth, fundWallet);

/**
 * @swagger
 * /api/finance/pay:
 *   post:
 *     tags: [Finance]
 *     summary: Make a payment
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [amount]
 *             properties:
 *               amount:
 *                 type: number
 *               description:
 *                 type: string
 *     responses:
 *       200:
 *         description: Payment processed
 */
router.post("/pay", auth, makePayment);

module.exports = router;
