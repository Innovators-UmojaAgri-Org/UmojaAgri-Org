const prisma = require("../../config/prisma");

async function assignTransport({ deliveryId, transporterId, vehicleId }) {
  return prisma.$transaction(async (tx) => {
    // Fetch delivery
    const delivery = await tx.delivery.findUnique({
      where: { id: deliveryId },
      include: { produce: true },
    });

    if (!delivery) throw new Error("Delivery not found");

    if (delivery.status !== "PENDING") {
      throw new Error("Delivery already assigned or processed");
    }

    // Fetch vehicle
    const vehicle = await tx.vehicle.findUnique({
      where: { id: vehicleId },
    });

    if (!vehicle) throw new Error("Vehicle not found");

    // Capacity check
    if (vehicle.capacity < delivery.produce.quantity) {
      throw new Error("Vehicle capacity insufficient");
    }

    // Create assignment
    const assignment = await tx.transportAssignment.create({
      data: {
        deliveryId,
        transporterId,
        vehicleId,
      },
    });

    // Update delivery status
    await tx.delivery.update({
      where: { id: deliveryId },
      data: { status: "ASSIGNED" },
    });

    // Log event
    await tx.deliveryEvent.create({
      data: {
        deliveryId,
        status: "ASSIGNED",
        location: "ASSIGNMENT_CENTER",
      },
    });

    return assignment;
  });
}

async function getAssignment(deliveryId) {
  return prisma.transportAssignment.findUnique({
    where: { deliveryId },
    include: {
      transporter: true,
      vehicle: true,
      delivery: true,
    },
  });
}

module.exports = {
  assignTransport,
  getAssignment,
};
