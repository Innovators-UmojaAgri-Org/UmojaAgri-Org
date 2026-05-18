const express = require("express");
const router = express.Router();
const controller = require("./transportController");

/**
 * @swagger
 * /api/transport/vehicle-types:
 *   get:
 *     tags: [Transport]
 *     summary: List all available vehicle types
 *     responses:
 *       200:
 *         description: List of vehicle types with labels
 */
router.get("/vehicle-types", controller.listVehicleTypes);

/**
 * @swagger
 * /api/transport/assign:
 *   post:
 *     tags: [Transport]
 *     summary: Assign transport to a delivery
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [deliveryId, transporterId, vehicleId]
 *             properties:
 *               deliveryId:
 *                 type: string
 *               transporterId:
 *                 type: string
 *               vehicleId:
 *                 type: string
 *     responses:
 *       201:
 *         description: Transport assigned
 */
router.post("/assign", controller.assignTransport);

/**
 * @swagger
 * /api/transport/{deliveryId}:
 *   get:
 *     tags: [Transport]
 *     summary: Get transport assignment for a delivery
 *     parameters:
 *       - in: path
 *         name: deliveryId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Transport assignment details
 */
router.get("/:deliveryId", controller.getAssignment);

module.exports = router;
