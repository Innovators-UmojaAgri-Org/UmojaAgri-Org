const express = require("express");
const cors = require("cors");
const userRoutes = require("./modules/users/usersRoutes");
const produceRoutes = require("./modules/produce/produceRoutes");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/users", userRoutes);
app.use("/api/produces", produceRoutes);

app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});

module.exports = app;
