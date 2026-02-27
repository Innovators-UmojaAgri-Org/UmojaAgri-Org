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

// Root route 
app.get("/", (req, res) => {
  res.json({
    message: "UmojaAgri API is running ",
    status: "healthy",
    version: "1.0.0",
    endpoints: {
      users: "/api/users",
      produces: "/api/produces",
      deliveries: "/api/deliveries",
      transport: "/api/transport",
      orders: "/api/orders",
    },
  });
});

app.use("/api/users", userRoutes);
app.use("/api/produces", produceRoutes);
app.use("/api/deliveries", deliveriesRoutes);
app.use("/api/transport", transportRoutes);
app.use("/api/orders", ordersRoutes);

app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});

module.exports = app;
