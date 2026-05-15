const express = require("express");
const router = express.Router();
const auth = require("../../shared/middleware/auth");
const role = require("../../shared/middleware/role");
const {
  getRecommendations,
  getRisks,
  getShipmentInsights,
  getSupplyInsights,
  createAIResult,
} = require("./aiController");

/**
 * @swagger
 * /api/ai/recommendations:
 *   get:
 *     tags: [AI]
 *     summary: Get AI recommendations (Transporter)
 *     responses:
 *       200:
 *         description: AI-powered recommendations
 */
router.get("/recommendations", auth, role(["TRANSPORTER"]), getRecommendations);

/**
 * @swagger
 * /api/ai/risks:
 *   get:
 *     tags: [AI]
 *     summary: Get cargo risk analysis (Transporter)
 *     responses:
 *       200:
 *         description: Risk analysis data
 */
router.get("/risks", auth, role(["TRANSPORTER"]), getRisks);

/**
 * @swagger
 * /api/ai/shipment-insights:
 *   get:
 *     tags: [AI]
 *     summary: Get shipment insights (Farmer)
 *     responses:
 *       200:
 *         description: AI shipment insights
 */
router.get("/shipment-insights", auth, role(["FARMER"]), getShipmentInsights);

/**
 * @swagger
 * /api/ai/supply-insights:
 *   get:
 *     tags: [AI]
 *     summary: Get supply insights (Seller)
 *     responses:
 *       200:
 *         description: AI supply insights
 */
router.get("/supply-insights", auth, role(["SELLER"]), getSupplyInsights);

/**
 * @swagger
 * /api/ai:
 *   post:
 *     tags: [AI]
 *     summary: Create AI result (Admin)
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [type, result]
 *             properties:
 *               type:
 *                 type: string
 *                 enum: [FRESHNESS, ROUTE, DISPATCH, VEHICLE, CARGO_RISK, SUPPLY_INSIGHT, SHIPMENT_INSIGHT]
 *               result:
 *                 type: object
 *               produceId:
 *                 type: string
 *               deliveryId:
 *                 type: string
 *     responses:
 *       201:
 *         description: AI result created
 */
router.post("/", auth, role(["ADMIN"]), createAIResult);

module.exports = router;
