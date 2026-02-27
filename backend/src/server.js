require("dotenv").config();
const app = require("./app");
const http = require("http");

const server = http.createServer(app);

const { Server } = require("socket.io");
const io = new Server(server, {
  cors: { origin: "*" }, // restrict in production
});

// Make io accessible in routes/services
app.set("io", io);

io.on("connection", (socket) => {
  console.log("Client connected:", socket.id);

  socket.on("joinDeliveryRoom", (deliveryId) => {
    socket.join(deliveryId);
    console.log(`Socket ${socket.id} joined delivery ${deliveryId}`);
  });

  socket.on("disconnect", () => {
    console.log("Client disconnected:", socket.id);
  });
});

const PORT = process.env.PORT || 5000;
server.listen(PORT, () => console.log(`Server running on port ${PORT}`));
