const express = require("express");
const router = express.Router();
const auth = require("../../shared/middleware/auth");
const role = require("../../shared/middleware/role");
const {
  getCart,
  addToCart,
  updateCartItem,
  removeFromCart,
  clearCart,
} = require("./cartController");

/**
 * @swagger
 * /api/cart:
 *   get:
 *     tags: [Cart]
 *     summary: Get current cart (Seller)
 *     responses:
 *       200:
 *         description: Cart items
 */
router.get("/", auth, role(["SELLER"]), getCart);

/**
 * @swagger
 * /api/cart:
 *   post:
 *     tags: [Cart]
 *     summary: Add item to cart (Seller)
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [produceId, quantity]
 *             properties:
 *               produceId:
 *                 type: string
 *               quantity:
 *                 type: number
 *     responses:
 *       201:
 *         description: Item added to cart
 */
router.post("/", auth, role(["SELLER"]), addToCart);

/**
 * @swagger
 * /api/cart/clear:
 *   delete:
 *     tags: [Cart]
 *     summary: Clear entire cart (Seller)
 *     responses:
 *       200:
 *         description: Cart cleared
 */
router.delete("/clear", auth, role(["SELLER"]), clearCart);

/**
 * @swagger
 * /api/cart/{produceId}:
 *   patch:
 *     tags: [Cart]
 *     summary: Update cart item quantity (Seller)
 *     parameters:
 *       - in: path
 *         name: produceId
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [quantity]
 *             properties:
 *               quantity:
 *                 type: number
 *     responses:
 *       200:
 *         description: Cart item updated
 */
router.patch("/:produceId", auth, role(["SELLER"]), updateCartItem);

/**
 * @swagger
 * /api/cart/{produceId}:
 *   delete:
 *     tags: [Cart]
 *     summary: Remove item from cart (Seller)
 *     parameters:
 *       - in: path
 *         name: produceId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Item removed from cart
 */
router.delete("/:produceId", auth, role(["SELLER"]), removeFromCart);

module.exports = router;
