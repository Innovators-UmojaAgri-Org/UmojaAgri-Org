const express = require("express");
const router = express.Router();
const auth = require("../../shared/middleware/auth");
const role = require("../../shared/middleware/role");
const {
  createShipment,
  listShipments,
  getShipmentSummary,
  getShipment,
  selectTransporter,
  getRecommendedTransporter,
  listAvailableShipments,
  acceptShipment,
  listTransporterShipments,
  declineShipment,
  updateShipmentStatus,
} = require("./shipmentsController");

router.post("/", auth, role(["FARMER"]), createShipment);
router.get("/", auth, role(["FARMER"]), listShipments);
router.get("/summary", auth, role(["FARMER"]), getShipmentSummary);
router.post("/select-transporter", auth, role(["FARMER"]), selectTransporter);

router.get("/available", auth, role(["TRANSPORTER"]), listAvailableShipments);
router.get("/my", auth, role(["TRANSPORTER"]), listTransporterShipments);
router.patch("/:id/accept", auth, role(["TRANSPORTER"]), acceptShipment);
router.patch("/:id/decline", auth, role(["TRANSPORTER"]), declineShipment);
router.patch("/:id/status", auth, role(["TRANSPORTER"]), updateShipmentStatus);

router.get("/:shipmentId/recommendations", auth, role(["FARMER"]), getRecommendedTransporter);
router.get("/:id", auth, role(["FARMER", "TRANSPORTER"]), getShipment);

module.exports = router;
