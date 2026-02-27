const express = require("express");
const cors = require("cors");
const userRoutes = require("./modules/users/usersRoutes");
const produceRoutes = require("./modules/produce/produceRoutes");
const deliveriesRoutes = require("./modules/deliveries/deliveriesRoutes");
const transportRoutes = require("./modules/transport/transportRoutes");
const ordersRoutes = require("./modules/orders/ordersRoutes");



const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/users", userRoutes);
app.use("/api/produces", produceRoutes);
app.use("/api/deliveries", deliveriesRoutes);
app.use("/api/transport", transportRoutes);
app.use("/api/orders", ordersRoutes);


app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});

module.exports = app;
