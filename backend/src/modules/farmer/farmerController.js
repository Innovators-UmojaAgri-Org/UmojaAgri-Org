const farmerService = require("./farmerService");

async function getProfile(req, res) {
  try {
    const profile = await farmerService.getFarmerProfile(req.user.userId);
    res.json({ success: true, data: profile });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getRevenue(req, res) {
  try {
    const revenue = await farmerService.getFarmerRevenue(req.user.userId);
    res.json({ success: true, data: revenue });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getYields(req, res) {
  try {
    const yields = await farmerService.getYieldTrends(req.user.userId);
    res.json({ success: true, data: yields });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

module.exports = { getProfile, getRevenue, getYields };
