const express = require("express");
const router = express.Router();
const auth = require("../../shared/middleware/auth");
const role = require("../../shared/middleware/role");

const {
  placeOrder,
  listOrdersForFarmer,
  approveOrRejectOrder,
  getOrder,
} = require("./ordersController");

// Seller routes
router.post("/", auth, role(["SELLER"]), placeOrder);

// Farmer routes
router.get("/farmer", auth, role(["FARMER"]), listOrdersForFarmer);
router.patch("/:id/status", auth, role(["FARMER"]), approveOrRejectOrder);

// Admin or seller can view any order by ID
router.get("/:id", auth, role(["ADMIN", "SELLER", "FARMER"]), getOrder);

module.exports = router;