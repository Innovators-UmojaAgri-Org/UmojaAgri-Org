const express = require("express");
const cors = require("cors");
const userRoutes = require("./modules/users/usersRoutes");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/users", userRoutes);

app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});

module.exports = app;
