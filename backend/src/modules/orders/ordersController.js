const orderService = require("./ordersService");

// Seller places order
async function placeOrder(req, res) {
  try {
    const data = { ...req.body, sellerId: req.user.userId };
    const order = await orderService.createOrder(data);
    res.status(201).json(order);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

// Farmer views orders
async function listOrdersForFarmer(req, res) {
  try {
    const orders = await orderService.getOrdersForFarmer(req.user.userId);
    res.json(orders);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

// Farmer approves/rejects
async function approveOrRejectOrder(req, res) {
  try {
    const order = await orderService.updateOrderStatus(
      req.params.id,
      req.body.status
    );
    res.json(order);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

// Get order by ID
async function getOrder(req, res) {
  try {
    const order = await orderService.getOrderById(req.params.id);
    res.json(order);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

module.exports = {
  placeOrder,
  listOrdersForFarmer,
  approveOrRejectOrder,
  getOrder,
};