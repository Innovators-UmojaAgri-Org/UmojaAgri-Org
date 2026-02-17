const express = require("express");
const auth = require("../../shared/middleware/auth");
const role = require("../../shared/middleware/role");

const {
  addProduce,
  listMyProduces,
  editProduce,
  removeProduce,
  listAllProduces,
} = require("./produceController");

const router = express.Router();

// Farmer only routes
router.post("/", auth, role(["FARMER"]), addProduce);
router.get("/me", auth, role(["FARMER"]), listMyProduces);
router.put("/:id", auth, role(["FARMER"]), editProduce);
router.delete("/:id", auth, role(["FARMER"]), removeProduce);

// Public or admin route
router.get(
  "/",
  auth,
  role(["ADMIN", "FARMER", "TRANSPORTER"]),
  listAllProduces,
);

module.exports = router;
