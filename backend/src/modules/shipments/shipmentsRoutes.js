const express = require("express");
const router = express.Router();
const auth = require("../../shared/middleware/auth");
const role = require("../../shared/middleware/role");
const {
  createShipment,
  listShipments,
  getShipmentSummary,
  getShipment,
  selectTransporter,
  getRecommendedTransporter,
  listMyJobs,
  acceptJob,
  declineJob,
  updateJobStatus,
} = require("./shipmentsController");

/**
 * @swagger
 * /api/shipments:
 *   post:
 *     tags: [Shipments]
 *     summary: Create a shipment (Farmer)
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [cargo, weight, destination]
 *             properties:
 *               cargo:
 *                 type: string
 *               weight:
 *                 type: number
 *               weightUnit:
 *                 type: string
 *                 default: kg
 *               destination:
 *                 type: string
 *               price:
 *                 type: number
 *     responses:
 *       201:
 *         description: Shipment created
 */
router.post("/", auth, role(["FARMER"]), createShipment);

/**
 * @swagger
 * /api/shipments:
 *   get:
 *     tags: [Shipments]
 *     summary: List shipments (Farmer)
 *     responses:
 *       200:
 *         description: List of shipments
 */
router.get("/", auth, role(["FARMER"]), listShipments);

/**
 * @swagger
 * /api/shipments/summary:
 *   get:
 *     tags: [Shipments]
 *     summary: Get shipment summary stats (Farmer)
 *     responses:
 *       200:
 *         description: Summary statistics
 */
router.get("/summary", auth, role(["FARMER"]), getShipmentSummary);

/**
 * @swagger
 * /api/shipments/{id}:
 *   get:
 *     tags: [Shipments]
 *     summary: Get shipment by ID (Farmer/Transporter)
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Shipment details
 */
router.get("/:id", auth, role(["FARMER", "TRANSPORTER"]), getShipment);

/**
 * @swagger
 * /api/shipments/{shipmentId}/recommendations:
 *   get:
 *     tags: [Shipments]
 *     summary: Get recommended transporters for a shipment (Farmer)
 *     parameters:
 *       - in: path
 *         name: shipmentId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Recommended transporters
 */
router.get("/:shipmentId/recommendations", auth, role(["FARMER"]), getRecommendedTransporter);

/**
 * @swagger
 * /api/shipments/select-transporter:
 *   post:
 *     tags: [Shipments]
 *     summary: Select a transporter for shipment (Farmer)
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [shipmentId, transporterId]
 *             properties:
 *               shipmentId:
 *                 type: string
 *               transporterId:
 *                 type: string
 *     responses:
 *       200:
 *         description: Transporter assigned
 */
router.post("/select-transporter", auth, role(["FARMER"]), selectTransporter);

router.get("/my-jobs", auth, role(["TRANSPORTER"]), listMyJobs);
router.patch("/:id/accept", auth, role(["TRANSPORTER"]), acceptJob);
router.patch("/:id/decline", auth, role(["TRANSPORTER"]), declineJob);
router.patch("/:id/status", auth, role(["TRANSPORTER"]), updateJobStatus);

module.exports = router;
