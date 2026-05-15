const driverService = require("./driverService");

async function getProfile(req, res) {
  try {
    const profile = await driverService.getDriverProfile(req.user.userId);
    res.json({ success: true, data: profile });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getShipments(req, res) {
  try {
    const shipments = await driverService.getDriverShipments(req.user.userId);
    res.json({ success: true, count: shipments.length, data: shipments });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getCurrentLoad(req, res) {
  try {
    const load = await driverService.getCurrentLoad(req.user.userId);
    res.json({ success: true, data: load });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getPerformance(req, res) {
  try {
    const performance = await driverService.getDriverPerformance(req.user.userId);
    res.json({ success: true, data: performance });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function updateSettings(req, res) {
  try {
    const profile = await driverService.updateDriverSettings(
      req.user.userId,
      req.body
    );
    res.json({ success: true, data: profile });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

module.exports = {
  getProfile,
  getShipments,
  getCurrentLoad,
  getPerformance,
  updateSettings,
};
