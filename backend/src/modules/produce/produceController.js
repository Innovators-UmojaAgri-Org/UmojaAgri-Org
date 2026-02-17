const {
  createProduce,
  getProducesByFarmer,
  updateProduce,
  deleteProduce,
  getAllProduces,
} = require("./produceService");

async function addProduce(req, res) {
  try {
    const data = { ...req.body, farmerId: req.user.userId };
    const produce = await createProduce(data);
    res.status(201).json(produce);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function listMyProduces(req, res) {
  try {
    const produces = await getProducesByFarmer(req.user.userId);
    res.json(produces);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function editProduce(req, res) {
  try {
    const updated = await updateProduce(
      req.params.id,
      req.body,
      req.user.userId,
    );
    if (updated.count === 0)
      return res.status(404).json({ error: "Produce not found" });
    res.json({ message: "Produce updated" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function removeProduce(req, res) {
  try {
    const deleted = await deleteProduce(req.params.id, req.user.userId);
    if (deleted.count === 0)
      return res.status(404).json({ error: "Produce not found" });
    res.json({ message: "Produce deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function listAllProduces(req, res) {
  try {
    const produces = await getAllProduces();
    res.json(produces);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

module.exports = {
  addProduce,
  listMyProduces,
  editProduce,
  removeProduce,
  listAllProduces,
};
