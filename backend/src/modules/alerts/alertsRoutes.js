const express = require("express");
const router = express.Router();
const auth = require("../../shared/middleware/auth");
const { listAlerts, createAlert } = require("./alertsController");

/**
 * @swagger
 * /api/alerts:
 *   get:
 *     tags: [Alerts]
 *     summary: List all alerts
 *     responses:
 *       200:
 *         description: List of alerts
 */
router.get("/", auth, listAlerts);

/**
 * @swagger
 * /api/alerts:
 *   post:
 *     tags: [Alerts]
 *     summary: Create a new alert
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [type, message, severity]
 *             properties:
 *               type:
 *                 type: string
 *               message:
 *                 type: string
 *               recommendation:
 *                 type: string
 *               severity:
 *                 type: string
 *     responses:
 *       201:
 *         description: Alert created
 */
router.post("/", auth, createAlert);

module.exports = router;
