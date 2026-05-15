const dashboardService = require("./dashboardService");

async function getDashboard(req, res) {
  try {
    const role = req.user.role;
    let data;

    switch (role) {
      case "SELLER":
        data = await dashboardService.getSellerDashboard(req.user.userId);
        break;
      case "FARMER":
        data = await dashboardService.getFarmerDashboard(req.user.userId);
        break;
      case "TRANSPORTER":
        data = await dashboardService.getDriverDashboard(req.user.userId);
        break;
      default:
        return res.status(400).json({ error: "Unknown role" });
    }

    res.json({ success: true, data });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

module.exports = { getDashboard };
