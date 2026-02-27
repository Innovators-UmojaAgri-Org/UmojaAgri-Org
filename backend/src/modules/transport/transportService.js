const prisma = require("../../config/prisma");

async function assignTransport({ deliveryId, transporterId, vehicleId }) {
  return prisma.$transaction(async (tx) => {
    // 1. Fetch delivery
    const delivery = await tx.delivery.findUnique({
      where: { id: deliveryId },
      include: { produce: true },
    });

    if (!delivery) throw new Error("Delivery not found");

    if (delivery.status !== "PENDING") {
      throw new Error("Delivery already assigned or processed");
    }

    // 2. Fetch vehicle
    const vehicle = await tx.vehicle.findUnique({
      where: { id: vehicleId },
    });

    if (!vehicle) throw new Error("Vehicle not found");

    // 3. Capacity check
    if (vehicle.capacity < delivery.produce.quantity) {
      throw new Error("Vehicle capacity insufficient");
    }

    // 4. Create assignment
    const assignment = await tx.transportAssignment.create({
      data: {
        deliveryId,
        transporterId,
        vehicleId,
      },
    });

    // 5. Update delivery status
    await tx.delivery.update({
      where: { id: deliveryId },
      data: { status: "ASSIGNED" },
    });

    // 6. Log event
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
