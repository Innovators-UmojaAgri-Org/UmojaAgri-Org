const alertsService = require("./alertsService");

async function listAlerts(req, res) {
  try {
    const alerts = await alertsService.getAlertsByUser(req.user.userId);
    res.json({ success: true, count: alerts.length, data: alerts });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function createAlert(req, res) {
  try {
    const alert = await alertsService.createAlert(req.body);
    res.status(201).json(alert);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

module.exports = { listAlerts, createAlert };
