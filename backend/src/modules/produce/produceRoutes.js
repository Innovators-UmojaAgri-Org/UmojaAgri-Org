const express = require("express");
const auth = require("../../shared/middleware/auth");
const role = require("../../shared/middleware/role");

const {
  addProduce,
  listMyProduces,
  editProduce,
  removeProduce,
  listAllProduces,
  listMarketplaceProduces,
  listFarmerWithProduce,
} = require("./produceController");

const router = express.Router();

/**
 * @swagger
 * /api/produces:
 *   post:
 *     tags: [Produce]
 *     summary: Add new produce (Farmer)
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [name, quantity]
 *             properties:
 *               name:
 *                 type: string
 *               description:
 *                 type: string
 *               quantity:
 *                 type: number
 *               unit:
 *                 type: string
 *               pricePerUnit:
 *                 type: number
 *               location:
 *                 type: string
 *               harvestDate:
 *                 type: string
 *                 format: date-time
 *               expiryDate:
 *                 type: string
 *                 format: date-time
 *     responses:
 *       201:
 *         description: Produce created
 */
router.post("/", auth, role(["FARMER"]), addProduce);

/**
 * @swagger
 * /api/produces/me:
 *   get:
 *     tags: [Produce]
 *     summary: List my produces (Farmer)
 *     responses:
 *       200:
 *         description: List of farmer's produces
 */
router.get("/me", auth, role(["FARMER"]), listMyProduces);

/**
 * @swagger
 * /api/produces/{id}:
 *   put:
 *     tags: [Produce]
 *     summary: Edit produce (Farmer)
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               description:
 *                 type: string
 *               quantity:
 *                 type: number
 *               unit:
 *                 type: string
 *               pricePerUnit:
 *                 type: number
 *     responses:
 *       200:
 *         description: Produce updated
 */
router.put("/:id", auth, role(["FARMER"]), editProduce);

/**
 * @swagger
 * /api/produces/{id}:
 *   delete:
 *     tags: [Produce]
 *     summary: Remove produce (Farmer)
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Produce removed
 */
router.delete("/:id", auth, role(["FARMER"]), removeProduce);

/**
 * @swagger
 * /api/produces/marketplace:
 *   get:
 *     tags: [Produce]
 *     summary: List marketplace produces (Seller/Admin/Transporter)
 *     responses:
 *       200:
 *         description: Available marketplace produces
 */
router.get(
  "/marketplace",
  auth,
  role(["ADMIN", "SELLER", "TRANSPORTER"]),
  listMarketplaceProduces,
);

/**
 * @swagger
 * /api/produces:
 *   get:
 *     tags: [Produce]
 *     summary: List all produces (Admin/Farmer/Transporter)
 *     responses:
 *       200:
 *         description: All produces
 */
router.get(
  "/",
  auth,
  role(["ADMIN", "FARMER", "TRANSPORTER"]),
  listAllProduces,
);

/**
 * @swagger
 * /api/produces/farmer/{farmerId}:
 *   get:
 *     tags: [Produce]
 *     summary: Get a farmer's profile and all their produce (Seller - for Place Order page)
 *     parameters:
 *       - in: path
 *         name: farmerId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Farmer profile with produce list
 */
router.get("/farmer/:farmerId", auth, role(["SELLER"]), listFarmerWithProduce);

module.exports = router;
