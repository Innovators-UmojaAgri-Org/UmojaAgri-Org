const express = require("express");
const router = express.Router();
const controller = require("./deliveriesController");
const auth = require("../../shared/middleware/auth");
const role = require("../../shared/middleware/role");

/**
 * @swagger
 * /api/deliveries:
 *   post:
 *     tags: [Deliveries]
 *     summary: Create a delivery
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [produceId, storageId, status]
 *             properties:
 *               produceId:
 *                 type: string
 *               storageId:
 *                 type: string
 *               status:
 *                 type: string
 *                 enum: [PENDING, ASSIGNED, IN_TRANSIT, DELIVERED, CANCELLED]
 *               origin:
 *                 type: string
 *               destination:
 *                 type: string
 *     responses:
 *       201:
 *         description: Delivery created
 */
router.post("/", controller.createDelivery);

/**
 * @swagger
 * /api/deliveries:
 *   get:
 *     tags: [Deliveries]
 *     summary: List all deliveries
 *     responses:
 *       200:
 *         description: List of deliveries
 */
router.get("/", controller.getDeliveries);

/**
 * @swagger
 * /api/deliveries/incoming:
 *   get:
 *     tags: [Deliveries]
 *     summary: List incoming deliveries (Seller)
 *     responses:
 *       200:
 *         description: Incoming deliveries for seller
 */
router.get("/incoming", auth, role(["SELLER"]), controller.listIncomingDeliveries);

/**
 * @swagger
 * /api/deliveries/{id}:
 *   get:
 *     tags: [Deliveries]
 *     summary: Get delivery by ID
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Delivery details
 */
router.get("/:id", controller.getDeliveryById);

/**
 * @swagger
 * /api/deliveries/{id}/status:
 *   patch:
 *     tags: [Deliveries]
 *     summary: Update delivery status
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
 *                 enum: [PENDING, ASSIGNED, IN_TRANSIT, DELIVERED, CANCELLED]
 *               location:
 *                 type: string
 *     responses:
 *       200:
 *         description: Status updated
 */
router.patch("/:id/status", controller.updateDeliveryStatus);

module.exports = router;
