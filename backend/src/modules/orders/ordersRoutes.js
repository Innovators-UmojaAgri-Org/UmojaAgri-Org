const express = require("express");
const router = express.Router();
const auth = require("../../shared/middleware/auth");
const role = require("../../shared/middleware/role");

const {
  placeOrder,
  listOrdersForFarmer,
  approveOrRejectOrder,
  getOrder,
  listSellerOrders,
  getSellerOrderSummary,
} = require("./ordersController");

/**
 * @swagger
 * /api/orders:
 *   post:
 *     tags: [Orders]
 *     summary: Place a new order (Seller)
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [produceId, quantity, unit]
 *             properties:
 *               produceId:
 *                 type: string
 *               quantity:
 *                 type: number
 *               unit:
 *                 type: string
 *     responses:
 *       201:
 *         description: Order placed
 */
router.post("/", auth, role(["SELLER"]), placeOrder);

/**
 * @swagger
 * /api/orders/seller:
 *   get:
 *     tags: [Orders]
 *     summary: List orders for current seller
 *     responses:
 *       200:
 *         description: Seller's orders
 */
router.get("/seller", auth, role(["SELLER"]), listSellerOrders);

/**
 * @swagger
 * /api/orders/seller/summary:
 *   get:
 *     tags: [Orders]
 *     summary: Get seller order summary
 *     responses:
 *       200:
 *         description: Order summary stats
 */
router.get("/seller/summary", auth, role(["SELLER"]), getSellerOrderSummary);

/**
 * @swagger
 * /api/orders/farmer:
 *   get:
 *     tags: [Orders]
 *     summary: List orders for current farmer
 *     responses:
 *       200:
 *         description: Farmer's orders
 */
router.get("/farmer", auth, role(["FARMER"]), listOrdersForFarmer);

/**
 * @swagger
 * /api/orders/{id}/status:
 *   patch:
 *     tags: [Orders]
 *     summary: Approve or reject an order (Farmer)
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [status]
 *             properties:
 *               status:
 *                 type: string
 *                 enum: [CONFIRMED, REJECTED]
 *     responses:
 *       200:
 *         description: Order status updated
 */
router.patch("/:id/status", auth, role(["FARMER"]), approveOrRejectOrder);

/**
 * @swagger
 * /api/orders/{id}:
 *   get:
 *     tags: [Orders]
 *     summary: Get order by ID
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Order details
 */
router.get("/:id", auth, role(["ADMIN", "SELLER", "FARMER"]), getOrder);

module.exports = router;
