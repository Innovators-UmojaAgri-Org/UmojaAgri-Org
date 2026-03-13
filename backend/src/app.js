const express = require("express");
const cors = require("cors");
const swaggerUi = require("swagger-ui-express");
const swaggerSpec = require("./config/swagger");



const userRoutes = require("./modules/users/usersRoutes");
const produceRoutes = require("./modules/produce/produceRoutes");
const deliveriesRoutes = require("./modules/deliveries/deliveriesRoutes");
const transportRoutes = require("./modules/transport/transportRoutes");
const ordersRoutes = require("./modules/orders/ordersRoutes");

const alertsRoutes = require("./modules/alerts/alertsRoutes");
const notificationsRoutes = require("./modules/notifications/notificationsRoutes");
const cartRoutes = require("./modules/cart/cartRoutes");
const financeRoutes = require("./modules/finance/financeRoutes");
const driverRoutes = require("./modules/driver/driverRoutes");
const routesRoutes = require("./modules/routes/routesRoutes");
const farmerRoutes = require("./modules/farmer/farmerRoutes");
const shipmentsRoutes = require("./modules/shipments/shipmentsRoutes");
const transportersRoutes = require("./modules/transporters/transportersRoutes");
const aiRoutes = require("./modules/ai/aiRoutes");
const dashboardRoutes = require("./modules/dashboard/dashboardRoutes");

const app = express();

app.use(cors());
app.use(express.json());

// Existing routes
app.use("/api/users", userRoutes);
app.use("/api/produces", produceRoutes);
app.use("/api/deliveries", deliveriesRoutes);
app.use("/api/transport", transportRoutes);
app.use("/api/orders", ordersRoutes);

// New routes
app.use("/api/alerts", alertsRoutes);
app.use("/api/notifications", notificationsRoutes);
app.use("/api/cart", cartRoutes);
app.use("/api/finance", financeRoutes);
app.use("/api/driver", driverRoutes);
app.use("/api/routes", routesRoutes);
app.use("/api/farmer", farmerRoutes);
app.use("/api/shipments", shipmentsRoutes);
app.use("/api/transporters", transportersRoutes);
app.use("/api/ai", aiRoutes);
app.use("/api/dashboard", dashboardRoutes);

app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));

app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});

module.exports = app;
