const aiService = require("./aiService");

async function getRecommendations(req, res) {
  try {
    const results = await aiService.getRecommendations(req.user.userId);

    const recommendations = results.map((r) => ({
      id: r.id,
      type: r.type.toLowerCase(),
      ...r.result,
      created_at: r.createdAt,
    }));

    res.json({ success: true, count: recommendations.length, data: recommendations });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getRisks(req, res) {
  try {
    const results = await aiService.getRisks(req.user.userId);

    const risks = results.map((r) => ({
      id: r.id,
      type: "cargo_risk",
      ...r.result,
      created_at: r.createdAt,
    }));

    res.json({ success: true, count: risks.length, data: risks });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getShipmentInsights(req, res) {
  try {
    const results = await aiService.getShipmentInsights(req.user.userId);

    const insights = results.map((r) => ({
      id: r.id,
      type: "shipment_insight",
      ...r.result,
      created_at: r.createdAt,
    }));

    res.json({ success: true, count: insights.length, data: insights });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getSupplyInsights(req, res) {
  try {
    const alerts = await aiService.getSupplyInsights(req.user.userId);
    res.json({ success: true, count: alerts.length, data: alerts });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function createAIResult(req, res) {
  try {
    const result = await aiService.createAIResult(req.body);
    res.status(201).json({ success: true, data: result });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

module.exports = {
  getRecommendations,
  getRisks,
  getShipmentInsights,
  getSupplyInsights,
  createAIResult,
};
