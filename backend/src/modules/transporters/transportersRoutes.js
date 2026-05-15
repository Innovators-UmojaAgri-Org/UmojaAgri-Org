const express = require("express");
const router = express.Router();
const auth = require("../../shared/middleware/auth");
const role = require("../../shared/middleware/role");
const {
  listTransporters,
  getTransporter,
  createProfile,
} = require("./transportersController");

/**
 * @swagger
 * /api/transporters:
 *   get:
 *     tags: [Transporters]
 *     summary: List all transporters
 *     responses:
 *       200:
 *         description: List of transporters
 */
router.get("/", auth, listTransporters);

/**
 * @swagger
 * /api/transporters/{id}:
 *   get:
 *     tags: [Transporters]
 *     summary: Get transporter by ID
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Transporter details
 */
router.get("/:id", auth, getTransporter);

/**
 * @swagger
 * /api/transporters/profile:
 *   post:
 *     tags: [Transporters]
 *     summary: Create transporter profile (Transporter)
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [companyName]
 *             properties:
 *               companyName:
 *                 type: string
 *               pricePerKm:
 *                 type: number
 *               vehicleType:
 *                 type: string
 *               estimatedDeliveryHours:
 *                 type: integer
 *     responses:
 *       201:
 *         description: Profile created
 */
router.post("/profile", auth, role(["TRANSPORTER"]), createProfile);

module.exports = router;
