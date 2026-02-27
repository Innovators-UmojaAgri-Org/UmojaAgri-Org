const express = require("express");
const router = express.Router();
const controller = require("./deliveriesController");

router.post("/", controller.createDelivery);
router.get("/", controller.getDeliveries);
router.get("/:id", controller.getDeliveryById);
router.patch("/:id/status", controller.updateDeliveryStatus);

module.exports = router;
