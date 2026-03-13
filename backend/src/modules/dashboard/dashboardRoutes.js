const express = require("express");
const router = express.Router();
const auth = require("../../shared/middleware/auth");
const { getDashboard } = require("./dashboardController");

/**
 * @swagger
 * /api/dashboard:
 *   get:
 *     tags: [Dashboard]
 *     summary: Get dashboard data for current user
 *     responses:
 *       200:
 *         description: Dashboard overview data
 */
router.get("/", auth, getDashboard);

module.exports = router;
