const express = require("express");
const router = express.Router();
const auth = require("../../shared/middleware/auth");
const role = require("../../shared/middleware/role");
const { getProfile, getRevenue, getYields } = require("./farmerController");

/**
 * @swagger
 * /api/farmer/profile:
 *   get:
 *     tags: [Farmer]
 *     summary: Get farmer profile
 *     responses:
 *       200:
 *         description: Farmer profile data
 */
router.get("/profile", auth, role(["FARMER"]), getProfile);

/**
 * @swagger
 * /api/farmer/revenue:
 *   get:
 *     tags: [Farmer]
 *     summary: Get farmer revenue stats
 *     responses:
 *       200:
 *         description: Revenue data
 */
router.get("/revenue", auth, role(["FARMER"]), getRevenue);

/**
 * @swagger
 * /api/farmer/yields:
 *   get:
 *     tags: [Farmer]
 *     summary: Get farmer yield stats
 *     responses:
 *       200:
 *         description: Yield data
 */
router.get("/yields", auth, role(["FARMER"]), getYields);

module.exports = router;
