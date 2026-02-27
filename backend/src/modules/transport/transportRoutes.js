const express = require("express");
const router = express.Router();
const controller = require("./transportController");

router.post("/assign", controller.assignTransport);
router.get("/:deliveryId", controller.getAssignment);

module.exports = router;
