const express = require("express");
const router = express.Router();
const auth = require("../../shared/middleware/auth");
const role = require("../../shared/middleware/role");
const {
  getProfile,
  getShipments,
  getCurrentLoad,
  getPerformance,
  updateSettings,
} = require("./driverController");

/**
 * @swagger
 * /api/driver/profile:
 *   get:
 *     tags: [Driver]
 *     summary: Get driver profile (Transporter)
 *     responses:
 *       200:
 *         description: Driver profile data
 */
router.get("/profile", auth, role(["TRANSPORTER"]), getProfile);

/**
 * @swagger
 * /api/driver/shipments:
 *   get:
 *     tags: [Driver]
 *     summary: Get driver's assigned shipments (Transporter)
 *     responses:
 *       200:
 *         description: List of assigned shipments
 */
router.get("/shipments", auth, role(["TRANSPORTER"]), getShipments);

/**
 * @swagger
 * /api/driver/load:
 *   get:
 *     tags: [Driver]
 *     summary: Get current load info (Transporter)
 *     responses:
 *       200:
 *         description: Current load details
 */
router.get("/load", auth, role(["TRANSPORTER"]), getCurrentLoad);

/**
 * @swagger
 * /api/driver/performance:
 *   get:
 *     tags: [Driver]
 *     summary: Get driver performance stats (Transporter)
 *     responses:
 *       200:
 *         description: Performance metrics
 */
router.get("/performance", auth, role(["TRANSPORTER"]), getPerformance);

/**
 * @swagger
 * /api/driver/settings:
 *   patch:
 *     tags: [Driver]
 *     summary: Update driver settings (Transporter)
 *     requestBody:
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               dynamicRouting:
 *                 type: boolean
 *               status:
 *                 type: string
 *               location:
 *                 type: string
 *     responses:
 *       200:
 *         description: Settings updated
 */
router.patch("/settings", auth, role(["TRANSPORTER"]), updateSettings);

module.exports = router;
