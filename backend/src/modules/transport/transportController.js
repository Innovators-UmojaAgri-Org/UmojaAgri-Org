const transportService = require("./transportService");

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
  assignTransport,
  getAssignment,
};
