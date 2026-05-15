const routesService = require("./routesService");

async function getCurrentRoute(req, res) {
  try {
    const route = await routesService.getCurrentRoute(req.params.shipmentId);
    if (!route) return res.status(404).json({ error: "No route assigned" });
    res.json({ success: true, data: route });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getRouteCost(req, res) {
  try {
    const cost = await routesService.getRouteCost(req.params.routeId);
    res.json({ success: true, data: cost });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

async function getAlternativeRoutes(req, res) {
  try {
    const { origin, destination } = req.query;
    if (!origin || !destination) {
      return res.status(400).json({ error: "origin and destination are required" });
    }
    const routes = await routesService.getAlternativeRoutes(origin, destination);
    res.json({ success: true, count: routes.length, data: routes });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getRouteWaypoints(req, res) {
  try {
    const waypoints = await routesService.getRouteWaypoints(req.params.routeId);
    res.json({ success: true, data: waypoints });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function acceptRoute(req, res) {
  try {
    const { shipmentId, routeId } = req.body;
    const shipment = await routesService.acceptRoute(shipmentId, routeId);
    res.json({ success: true, data: shipment });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

async function createRoute(req, res) {
  try {
    const route = await routesService.createRoute(req.body);
    res.status(201).json({ success: true, data: route });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

module.exports = {
  getCurrentRoute,
  getRouteCost,
  getAlternativeRoutes,
  getRouteWaypoints,
  acceptRoute,
  createRoute,
};
