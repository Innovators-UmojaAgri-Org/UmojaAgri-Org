const express = require("express");
const router = express.Router();
const auth = require("../../shared/middleware/auth");
const role = require("../../shared/middleware/role");
const {
  getCurrentRoute,
  getRouteCost,
  getAlternativeRoutes,
  getRouteWaypoints,
  acceptRoute,
  createRoute,
} = require("./routesController");

/**
 * @swagger
 * /api/routes/alternatives:
 *   get:
 *     tags: [Routes]
 *     summary: Get alternative routes (Transporter)
 *     responses:
 *       200:
 *         description: List of alternative routes
 */
router.get("/alternatives", auth, role(["TRANSPORTER"]), getAlternativeRoutes);

/**
 * @swagger
 * /api/routes/{shipmentId}/current:
 *   get:
 *     tags: [Routes]
 *     summary: Get current route for a shipment (Transporter)
 *     parameters:
 *       - in: path
 *         name: shipmentId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Current route details
 */
router.get("/:shipmentId/current", auth, role(["TRANSPORTER"]), getCurrentRoute);

/**
 * @swagger
 * /api/routes/{routeId}/cost:
 *   get:
 *     tags: [Routes]
 *     summary: Get route cost breakdown (Transporter)
 *     parameters:
 *       - in: path
 *         name: routeId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Route cost details
 */
router.get("/:routeId/cost", auth, role(["TRANSPORTER"]), getRouteCost);

/**
 * @swagger
 * /api/routes/{routeId}/waypoints:
 *   get:
 *     tags: [Routes]
 *     summary: Get route waypoints (Transporter)
 *     parameters:
 *       - in: path
 *         name: routeId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Route waypoints/stops
 */
router.get("/:routeId/waypoints", auth, role(["TRANSPORTER"]), getRouteWaypoints);

/**
 * @swagger
 * /api/routes/accept:
 *   post:
 *     tags: [Routes]
 *     summary: Accept a route (Transporter)
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [shipmentId, routeId]
 *             properties:
 *               shipmentId:
 *                 type: string
 *               routeId:
 *                 type: string
 *     responses:
 *       200:
 *         description: Route accepted
 */
router.post("/accept", auth, role(["TRANSPORTER"]), acceptRoute);

/**
 * @swagger
 * /api/routes:
 *   post:
 *     tags: [Routes]
 *     summary: Create a new route (Admin/Transporter)
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [origin, destination, distanceKm, estimatedTimeMinutes]
 *             properties:
 *               origin:
 *                 type: string
 *               destination:
 *                 type: string
 *               distanceKm:
 *                 type: number
 *               estimatedTimeMinutes:
 *                 type: integer
 *               riskLevel:
 *                 type: string
 *               fuelCost:
 *                 type: number
 *               tollCost:
 *                 type: number
 *     responses:
 *       201:
 *         description: Route created
 */
router.post("/", auth, role(["ADMIN", "TRANSPORTER"]), createRoute);

module.exports = router;
