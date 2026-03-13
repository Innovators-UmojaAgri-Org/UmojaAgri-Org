const express = require("express");
const cors = require("cors");
const swaggerUi = require("swagger-ui-express");
const swaggerSpec = require("./config/swagger");
const { marked } = require("marked");
const fs = require("fs");
const path = require("path");



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

app.get("/api-endpoints", (req, res) => {
  const mdPath = path.join(__dirname, "../../api-endpoints.md");
  const markdown = fs.readFileSync(mdPath, "utf-8");
  const htmlContent = marked(markdown);
  res.send(`<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>UmojaAgri API Endpoints</title>
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; max-width: 900px; margin: 0 auto; padding: 2rem; line-height: 1.6; color: #1a1a1a; background: #fafafa; }
    h1 { color: #2e7d32; border-bottom: 3px solid #2e7d32; padding-bottom: 0.5rem; }
    h2 { color: #388e3c; margin-top: 2rem; border-bottom: 1px solid #c8e6c9; padding-bottom: 0.3rem; }
    h3 { color: #43a047; }
    code { background: #e8f5e9; padding: 2px 6px; border-radius: 4px; font-size: 0.9em; }
    pre { background: #263238; color: #e0e0e0; padding: 1rem; border-radius: 8px; overflow-x: auto; }
    pre code { background: none; color: inherit; padding: 0; }
    hr { border: none; border-top: 1px solid #e0e0e0; margin: 2rem 0; }
    strong { color: #1b5e20; }
    ul, ol { padding-left: 1.5rem; }
    li { margin: 0.3rem 0; }
  </style>
</head>
<body>${htmlContent}</body>
</html>`);
});

app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});

module.exports = app;
