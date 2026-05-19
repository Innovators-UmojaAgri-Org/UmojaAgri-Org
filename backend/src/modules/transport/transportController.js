const transportService = require("./transportService");

const VEHICLE_TYPE_LABELS = {
  COMPACT_CAR_HATCHBACK: "Compact Car & Hatchback",
  MINI_VAN: "Mini Van",
  OPEN_TRUCK: "Open Truck",
  REFRIGERATED_TRUCK: "Refrigerated Truck",
  DEDICATED_BULK_HAULAGE: "Dedicated Bulk Haulage",
};

async function listVehicleTypes(req, res) {
  const types = Object.entries(VEHICLE_TYPE_LABELS).map(([value, label]) => ({
    value,
    label,
  }));
  res.json({ success: true, data: types });
}

async function assignTransport(req, res) {
  try {
    const assignment = await transportService.assignTransport(req.body);
    res.status(201).json(assignment);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

async function getAssignment(req, res) {
  const assignment = await transportService.getAssignment(
    req.params.deliveryId
  );
  res.json(assignment);
}

module.exports = {
  listVehicleTypes,
  assignTransport,
  getAssignment,
};
