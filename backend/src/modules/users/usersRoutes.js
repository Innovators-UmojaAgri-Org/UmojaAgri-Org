const express = require("express");
const { register, login } = require("./usersController");
const auth = require("../../shared/middleware/auth");
const role = require("../../shared/middleware/role");

const router = express.Router();

router.post("/register", register);
router.post("/login", login);

router.get("/profile", auth, (req, res) => {
  res.json({
    message: "Access granted",
    user: req.user,
  });
});

router.get("/admin-only", auth, role(["ADMIN"]), (req, res) => {
  res.json({ message: "Welcome admin" });
});

module.exports = router;
