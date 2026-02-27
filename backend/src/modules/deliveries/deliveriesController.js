const deliveryService = require("./deliveriesService");

async function createDelivery(req, res) {
  try {
    const delivery = await deliveryService.createDelivery(req.body);
    res.status(201).json(delivery);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

async function getDeliveries(req, res) {
  const deliveries = await deliveryService.getDeliveries();
  res.json(deliveries);
}

async function getDeliveryById(req, res) {
  const delivery = await deliveryService.getDeliveryById(req.params.id);
  res.json(delivery);
}

async function updateDeliveryStatus(req, res) {
  try {
    const io = req.app.get("io"); // get socket instance
    const delivery = await deliveryService.updateDeliveryStatus(
      req.params.id,
      req.body.status,
      req.body.location,
      io
    );
    res.json(delivery);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

module.exports = {
  createDelivery,
  getDeliveries,
  getDeliveryById,
  updateDeliveryStatus,
};
