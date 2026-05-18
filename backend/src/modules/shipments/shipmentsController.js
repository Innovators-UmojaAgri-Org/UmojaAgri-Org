const shipmentsService = require("./shipmentsService");

async function listAvailableShipments(req, res) {
  try {
    const shipments = await shipmentsService.getAvailableShipments();
    res.json({ success: true, count: shipments.length, data: shipments });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function acceptShipment(req, res) {
  try {
    const shipment = await shipmentsService.acceptShipment(req.params.id, req.user.userId);
    res.json({ success: true, data: shipment, message: "Shipment accepted" });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

async function listTransporterShipments(req, res) {
  try {
    const shipments = await shipmentsService.getShipmentsByTransporter(req.user.userId);
    res.json({ success: true, count: shipments.length, data: shipments });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function createShipment(req, res) {
  try {
    const data = { ...req.body, farmerId: req.user.userId };
    const shipment = await shipmentsService.createShipment(data);
    res.status(201).json({ success: true, data: shipment });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

async function listShipments(req, res) {
  try {
    const shipments = await shipmentsService.getShipmentsByFarmer(req.user.userId);
    res.json({ success: true, count: shipments.length, data: shipments });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getShipmentSummary(req, res) {
  try {
    const summary = await shipmentsService.getShipmentSummary(req.user.userId);
    res.json({ success: true, data: summary });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getShipment(req, res) {
  try {
    const shipment = await shipmentsService.getShipmentById(req.params.id);
    if (!shipment) return res.status(404).json({ error: "Shipment not found" });
    res.json({ success: true, data: shipment });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function selectTransporter(req, res) {
  try {
    const { shipmentId, transporterId } = req.body;
    const shipment = await shipmentsService.selectTransporter(shipmentId, transporterId);
    res.json({
      success: true,
      data: shipment,
      message: "Transporter selected",
    });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

async function getRecommendedTransporter(req, res) {
  try {
    const recommendation = await shipmentsService.getRecommendedTransporter(
      req.params.shipmentId
    );
    if (!recommendation) {
      return res.status(404).json({ error: "No transporters available" });
    }
    res.json({ success: true, data: recommendation });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

module.exports = {
  createShipment,
  listShipments,
  getShipmentSummary,
  getShipment,
  selectTransporter,
  getRecommendedTransporter,
  listAvailableShipments,
  acceptShipment,
  listTransporterShipments,
};
