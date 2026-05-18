const express = require("express");
const router = express.Router();
const auth = require("../../shared/middleware/auth");
const {
  getWallet,
  getTransactions,
  fundWallet,
  makePayment,
  getTransporterSummary,
} = require("./financeController");
const role = require("../../shared/middleware/role");

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

/**
 * @swagger
 * /api/finance/transporter-summary:
 *   get:
 *     tags: [Finance]
 *     summary: Get transporter earnings and trips summary for this month
 *     responses:
 *       200:
 *         description: Earnings and trips summary
 */
router.get("/transporter-summary", auth, role(["TRANSPORTER"]), getTransporterSummary);

module.exports = router;
