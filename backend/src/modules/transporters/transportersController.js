const transportersService = require("./transportersService");

async function listTransporters(req, res) {
  try {
    const transporters = await transportersService.listTransporters();
    res.json({ success: true, count: transporters.length, data: transporters });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getTransporter(req, res) {
  try {
    const transporter = await transportersService.getTransporterById(req.params.id);
    res.json({ success: true, data: transporter });
  } catch (err) {
    res.status(404).json({ error: err.message });
  }
}

async function createProfile(req, res) {
  try {
    const data = { ...req.body, userId: req.user.userId };
    const profile = await transportersService.createTransporterProfile(data);
    res.status(201).json({ success: true, data: profile });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

module.exports = { listTransporters, getTransporter, createProfile };
