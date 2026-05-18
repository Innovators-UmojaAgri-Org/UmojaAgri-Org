const cartService = require("./cartService");

async function getCart(req, res) {
  try {
    const items = await cartService.getCart(req.user.userId);
    const total = items.reduce(
      (sum, item) => sum + item.quantity * (item.produce?.pricePerUnit || 0),
      0
    );
    res.json({ success: true, count: items.length, total, data: items });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function addToCart(req, res) {
  try {
    const item = await cartService.addToCart({
      userId: req.user.userId,
      produceId: req.body.produceId,
      quantity: req.body.quantity,
    });
    res.status(201).json({ success: true, data: item });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

async function updateCartItem(req, res) {
  try {
    const item = await cartService.updateCartItem(
      req.user.userId,
      req.params.produceId,
      req.body.quantity
    );
    res.json({ success: true, data: item });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

async function removeFromCart(req, res) {
  try {
    await cartService.removeFromCart(req.user.userId, req.params.produceId);
    res.json({ success: true, message: "Item removed from cart" });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

async function clearCart(req, res) {
  try {
    await cartService.clearCart(req.user.userId);
    res.json({ success: true, message: "Cart cleared" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

module.exports = { getCart, addToCart, updateCartItem, removeFromCart, clearCart };
