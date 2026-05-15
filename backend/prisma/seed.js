const { PrismaClient } = require("@prisma/client");
const { PrismaPg } = require("@prisma/adapter-pg");
const bcrypt = require("bcryptjs");

require("dotenv").config();

const adapter = new PrismaPg({
  connectionString: process.env.DIRECT_URL,
});

const prisma = new PrismaClient({ adapter });

async function main() {
  console.log("Seeding database...\n");
  

  // ─── CLEAN (order matters due to foreign keys) ───
  await prisma.transaction.deleteMany();
  await prisma.wallet.deleteMany();
  await prisma.cartItem.deleteMany();
  await prisma.aIResult.deleteMany();
  await prisma.alert.deleteMany();
  await prisma.notification.deleteMany();
  await prisma.routeStop.deleteMany();
  await prisma.shipment.deleteMany();
  await prisma.route.deleteMany();
  await prisma.transportAssignment.deleteMany();
  await prisma.deliveryEvent.deleteMany();
  await prisma.delivery.deleteMany();
  await prisma.order.deleteMany();
  await prisma.produce.deleteMany();
  await prisma.storageLocation.deleteMany();
  await prisma.vehicle.deleteMany();
  await prisma.driverProfile.deleteMany();
  await prisma.transporterProfile.deleteMany();
  await prisma.user.deleteMany();
  await prisma.role.deleteMany();

  // ─── ROLES ───
  const roles = await Promise.all([
    prisma.role.create({ data: { name: "ADMIN" } }),
    prisma.role.create({ data: { name: "FARMER" } }),
    prisma.role.create({ data: { name: "SELLER" } }),
    prisma.role.create({ data: { name: "TRANSPORTER" } }),
  ]);
  const [adminRole, farmerRole, sellerRole, transporterRole] = roles;
  console.log("Roles created");

  // ─── USERS ───
  // Password for ALL seed users: password123
  const hash = await bcrypt.hash("password123", 10);

  const admin = await prisma.user.create({
    data: {
      email: "admin@umojaagri.com",
      password: hash,
      name: "Admin User",
      location: "Lagos",
      phone: "+2340000000000",
      roleId: adminRole.id,
    },
  });

  const farmer1 = await prisma.user.create({
    data: {
      email: "shola@umojaagri.com",
      password: hash,
      name: "Shola Adegboye",
      location: "Kaduna",
      phone: "+2348011111111",
      roleId: farmerRole.id,
    },
  });

  const farmer2 = await prisma.user.create({
    data: {
      email: "amina@umojaagri.com",
      password: hash,
      name: "Amina Bello",
      location: "Kano",
      phone: "+2348022222222",
      roleId: farmerRole.id,
    },
  });

  const seller1 = await prisma.user.create({
    data: {
      email: "chioma@umojaagri.com",
      password: hash,
      name: "Chioma Okafor",
      location: "Mile 12 Market",
      phone: "+2348033333333",
      roleId: sellerRole.id,
    },
  });

  const seller2 = await prisma.user.create({
    data: {
      email: "emeka@umojaagri.com",
      password: hash,
      name: "Emeka Nwosu",
      location: "Oshodi Market",
      phone: "+2348044444444",
      roleId: sellerRole.id,
    },
  });

  const transporter1 = await prisma.user.create({
    data: {
      email: "adebayo@umojaagri.com",
      password: hash,
      name: "Adebayo Olufemi",
      location: "Lagos",
      phone: "+2348055555555",
      roleId: transporterRole.id,
    },
  });

  const transporter2 = await prisma.user.create({
    data: {
      email: "fatima@umojaagri.com",
      password: hash,
      name: "Fatima Yusuf",
      location: "Ibadan",
      phone: "+2348066666666",
      roleId: transporterRole.id,
    },
  });

  console.log("Users created (password: password123)");

  // ─── DRIVER PROFILES ───
  await prisma.driverProfile.create({
    data: {
      userId: transporter1.id,
      licenseNumber: "LIC-KD-2020-001",
      experienceYears: 8,
      rating: 4.8,
      status: "active",
      location: "Lagos",
      dynamicRouting: true,
    },
  });

  await prisma.driverProfile.create({
    data: {
      userId: transporter2.id,
      licenseNumber: "LIC-IB-2019-045",
      experienceYears: 5,
      rating: 4.5,
      status: "active",
      location: "Ibadan",
      dynamicRouting: false,
    },
  });

  console.log("Driver profiles created");

  // ─── TRANSPORTER PROFILES ───
  const tp1 = await prisma.transporterProfile.create({
    data: {
      userId: transporter1.id,
      companyName: "Transport Logistics Nigeria",
      rating: 4.8,
      pricePerKm: 85,
      vehicleType: "Refrigerated Truck",
      estimatedDeliveryHours: 24,
    },
  });

  const tp2 = await prisma.transporterProfile.create({
    data: {
      userId: transporter2.id,
      companyName: "Farm Transit",
      rating: 4.5,
      pricePerKm: 65,
      vehicleType: "Open Truck",
      estimatedDeliveryHours: 30,
    },
  });

  console.log("Transporter profiles created");

  // ─── VEHICLES ───
  const vehicle1 = await prisma.vehicle.create({
    data: {
      plateNumber: "LAG-234-KD",
      capacity: 5000, // 5 tons in kg
      type: "Refrigerated Truck",
    },
  });

  const vehicle2 = await prisma.vehicle.create({
    data: {
      plateNumber: "KAN-567-IB",
      capacity: 3000, // 3 tons in kg
      type: "Open Truck",
    },
  });

  const vehicle3 = await prisma.vehicle.create({
    data: {
      plateNumber: "ABJ-890-LG",
      capacity: 8000,
      type: "Flatbed Truck",
    },
  });

  console.log("Vehicles created");

  // ─── STORAGE LOCATIONS ───
  const storage1 = await prisma.storageLocation.create({
    data: {
      name: "Mile 12 Market Warehouse",
      address: "Mile 12, Lagos",
      capacity: 50000,
    },
  });

  const storage2 = await prisma.storageLocation.create({
    data: {
      name: "Kaduna Central Cold Store",
      address: "Central Market, Kaduna",
      capacity: 30000,
    },
  });

  console.log("Storage locations created");

  // ─── PRODUCE ───
  const tomatoes = await prisma.produce.create({
    data: {
      name: "Tomatoes",
      description: "Fresh Roma tomatoes from Kaduna farms",
      quantity: 5000,
      unit: "kg",
      pricePerUnit: 1200,
      freshnessScore: 92,
      imageUrl: "https://images.unsplash.com/photo-1546470427-0d4db154ceb8",
      location: "Kaduna",
      farmerId: farmer1.id,
      harvestDate: new Date("2026-03-10"),
      expiryDate: new Date("2026-03-25"),
    },
  });

  const maize = await prisma.produce.create({
    data: {
      name: "Maize",
      description: "Premium yellow maize, sun-dried",
      quantity: 8000,
      unit: "kg",
      pricePerUnit: 600,
      freshnessScore: 95,
      imageUrl: "https://images.unsplash.com/photo-1551754655-cd27e38d2076",
      location: "Kaduna",
      farmerId: farmer1.id,
      harvestDate: new Date("2026-03-05"),
      expiryDate: new Date("2026-06-05"),
    },
  });

  const rice = await prisma.produce.create({
    data: {
      name: "Rice",
      description: "Local Ofada rice, stone-free",
      quantity: 10000,
      unit: "kg",
      pricePerUnit: 1800,
      freshnessScore: 98,
      imageUrl: "https://images.unsplash.com/photo-1586201375761-83865001e31c",
      location: "Kano",
      farmerId: farmer2.id,
      harvestDate: new Date("2026-02-20"),
      expiryDate: new Date("2026-08-20"),
    },
  });

  const beans = await prisma.produce.create({
    data: {
      name: "Beans",
      description: "Honey beans (Oloyin) from Kano",
      quantity: 6000,
      unit: "kg",
      pricePerUnit: 1500,
      freshnessScore: 96,
      imageUrl: "https://images.unsplash.com/photo-1551462147-ff29053bfc14",
      location: "Kano",
      farmerId: farmer2.id,
      harvestDate: new Date("2026-03-01"),
      expiryDate: new Date("2026-09-01"),
    },
  });

  const peppers = await prisma.produce.create({
    data: {
      name: "Peppers",
      description: "Fresh scotch bonnet peppers",
      quantity: 2000,
      unit: "kg",
      pricePerUnit: 2500,
      freshnessScore: 88,
      imageUrl: "https://images.unsplash.com/photo-1583119022894-919a68a3d0e3",
      location: "Kaduna",
      farmerId: farmer1.id,
      harvestDate: new Date("2026-03-08"),
      expiryDate: new Date("2026-03-20"),
    },
  });

  const onions = await prisma.produce.create({
    data: {
      name: "Onions",
      description: "Large red onions from northern farms",
      quantity: 4000,
      unit: "kg",
      pricePerUnit: 900,
      freshnessScore: 90,
      imageUrl: "https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb",
      location: "Kano",
      farmerId: farmer2.id,
      harvestDate: new Date("2026-03-02"),
      expiryDate: new Date("2026-04-02"),
    },
  });

  console.log("Produce created (6 items)");

  // ─── ORDERS ───
  // Order 1: Delivered (Chioma bought tomatoes from Shola)
  const order1 = await prisma.order.create({
    data: {
      orderCode: "ORD-2026-001",
      produceId: tomatoes.id,
      sellerId: seller1.id,
      farmerId: farmer1.id,
      quantity: 150,
      unit: "kg",
      amount: 150 * 1200,
      status: "DELIVERED",
      createdAt: new Date("2026-02-18"),
    },
  });

  // Order 2: In Transit (Chioma bought rice from Amina)
  const order2 = await prisma.order.create({
    data: {
      orderCode: "ORD-2026-002",
      produceId: rice.id,
      sellerId: seller1.id,
      farmerId: farmer2.id,
      quantity: 200,
      unit: "kg",
      amount: 200 * 1800,
      status: "IN_TRANSIT",
      createdAt: new Date("2026-03-05"),
    },
  });

  // Order 3: Pending (Emeka wants beans from Amina)
  const order3 = await prisma.order.create({
    data: {
      orderCode: "ORD-2026-003",
      produceId: beans.id,
      sellerId: seller2.id,
      farmerId: farmer2.id,
      quantity: 100,
      unit: "kg",
      amount: 100 * 1500,
      status: "PENDING",
      createdAt: new Date("2026-03-12"),
    },
  });

  // Order 4: Confirmed, awaiting transport (Chioma bought peppers from Shola)
  const order4 = await prisma.order.create({
    data: {
      orderCode: "ORD-2026-004",
      produceId: peppers.id,
      sellerId: seller1.id,
      farmerId: farmer1.id,
      quantity: 50,
      unit: "kg",
      amount: 50 * 2500,
      status: "CONFIRMED",
      createdAt: new Date("2026-03-10"),
    },
  });

  // Order 5: Delivered (Emeka bought maize from Shola)
  const order5 = await prisma.order.create({
    data: {
      orderCode: "ORD-2026-005",
      produceId: maize.id,
      sellerId: seller2.id,
      farmerId: farmer1.id,
      quantity: 500,
      unit: "kg",
      amount: 500 * 600,
      status: "DELIVERED",
      createdAt: new Date("2026-02-25"),
    },
  });

  console.log("Orders created (5 orders)");

  // ─── DELIVERIES ───
  // Delivery for order 1 (delivered)
  const delivery1 = await prisma.delivery.create({
    data: {
      produceId: tomatoes.id,
      storageId: storage1.id,
      status: "DELIVERED",
      origin: "Kaduna",
      destination: "Mile 12 Market",
      progressPercent: 100,
      etaMinutes: 0,
      currentLocation: "Mile 12 Market",
    },
  });

  // Delivery for order 2 (in transit)
  const delivery2 = await prisma.delivery.create({
    data: {
      produceId: rice.id,
      storageId: storage1.id,
      status: "IN_TRANSIT",
      origin: "Kano",
      destination: "Mile 12 Market",
      progressPercent: 65,
      etaMinutes: 135,
      currentLocation: "Ibadan",
    },
  });

  // Delivery for order 4 (pending transport)
  const delivery3 = await prisma.delivery.create({
    data: {
      produceId: peppers.id,
      storageId: storage1.id,
      status: "PENDING",
      origin: "Kaduna",
      destination: "Mile 12 Market",
      progressPercent: 0,
      etaMinutes: null,
      currentLocation: "Kaduna",
    },
  });

  // Delivery for order 5 (delivered)
  const delivery4 = await prisma.delivery.create({
    data: {
      produceId: maize.id,
      storageId: storage2.id,
      status: "DELIVERED",
      origin: "Kaduna",
      destination: "Oshodi Market",
      progressPercent: 100,
      etaMinutes: 0,
      currentLocation: "Oshodi Market",
    },
  });

  // Link deliveries to orders
  await prisma.order.update({ where: { id: order1.id }, data: { deliveryId: delivery1.id } });
  await prisma.order.update({ where: { id: order2.id }, data: { deliveryId: delivery2.id } });
  await prisma.order.update({ where: { id: order4.id }, data: { deliveryId: delivery3.id } });
  await prisma.order.update({ where: { id: order5.id }, data: { deliveryId: delivery4.id } });

  console.log("Deliveries created & linked to orders");

  // ─── DELIVERY EVENTS ───
  await prisma.deliveryEvent.createMany({
    data: [
      { deliveryId: delivery1.id, status: "PENDING", location: "Kaduna" },
      { deliveryId: delivery1.id, status: "ASSIGNED", location: "Kaduna" },
      { deliveryId: delivery1.id, status: "IN_TRANSIT", location: "Zaria" },
      { deliveryId: delivery1.id, status: "DELIVERED", location: "Mile 12 Market" },
      { deliveryId: delivery2.id, status: "PENDING", location: "Kano" },
      { deliveryId: delivery2.id, status: "ASSIGNED", location: "Kano" },
      { deliveryId: delivery2.id, status: "IN_TRANSIT", location: "Ibadan" },
    ],
  });

  console.log("Delivery events created");

  // ─── TRANSPORT ASSIGNMENTS ───
  await prisma.transportAssignment.create({
    data: {
      deliveryId: delivery1.id,
      transporterId: transporter1.id,
      vehicleId: vehicle1.id,
    },
  });

  await prisma.transportAssignment.create({
    data: {
      deliveryId: delivery2.id,
      transporterId: transporter2.id,
      vehicleId: vehicle2.id,
    },
  });

  console.log("Transport assignments created");

  // ─── ROUTES ───
  const route1 = await prisma.route.create({
    data: {
      origin: "Kaduna",
      destination: "Lagos",
      distanceKm: 792,
      estimatedTimeMinutes: 900, // 15 hours
      riskLevel: "medium",
      fuelCost: 40500,
      tollCost: 3200,
      stops: {
        create: [
          { location: "Kaduna", stopOrder: 1 },
          { location: "Zaria", stopOrder: 2 },
          { location: "Abuja", stopOrder: 3 },
          { location: "Lokoja", stopOrder: 4 },
          { location: "Ibadan", stopOrder: 5 },
          { location: "Lagos", stopOrder: 6 },
        ],
      },
    },
  });

  const route2 = await prisma.route.create({
    data: {
      origin: "Kaduna",
      destination: "Lagos",
      distanceKm: 805,
      estimatedTimeMinutes: 960, // 16 hours
      riskLevel: "low",
      fuelCost: 42000,
      tollCost: 2800,
      stops: {
        create: [
          { location: "Kaduna", stopOrder: 1 },
          { location: "Zaria", stopOrder: 2 },
          { location: "Ibadan", stopOrder: 3 },
          { location: "Lagos", stopOrder: 4 },
        ],
      },
    },
  });

  const route3 = await prisma.route.create({
    data: {
      origin: "Kano",
      destination: "Lagos",
      distanceKm: 1050,
      estimatedTimeMinutes: 1200, // 20 hours
      riskLevel: "medium",
      fuelCost: 55000,
      tollCost: 4500,
      stops: {
        create: [
          { location: "Kano", stopOrder: 1 },
          { location: "Kaduna", stopOrder: 2 },
          { location: "Abuja", stopOrder: 3 },
          { location: "Ibadan", stopOrder: 4 },
          { location: "Lagos", stopOrder: 5 },
        ],
      },
    },
  });

  console.log("Routes with waypoints created");

  // ─── SHIPMENTS ───
  const shipment1 = await prisma.shipment.create({
    data: {
      shipmentCode: "SH-2603-001",
      farmerId: farmer1.id,
      cargo: "Tomatoes",
      weight: 2000,
      weightUnit: "kg",
      destination: "Mile 12 Market",
      price: 450000,
      status: "IN_TRANSIT",
      transporterId: transporter1.id,
      routeId: route1.id,
      routeAccepted: true,
      estimatedArrival: new Date("2026-03-14T18:00:00Z"),
    },
  });

  const shipment2 = await prisma.shipment.create({
    data: {
      shipmentCode: "SH-2603-002",
      farmerId: farmer1.id,
      cargo: "Peppers",
      weight: 500,
      weightUnit: "kg",
      destination: "Oshodi Market",
      price: 120000,
      status: "TRANSPORTER_ASSIGNED",
      transporterId: transporter1.id,
      routeId: route2.id,
      routeAccepted: false,
      estimatedArrival: new Date("2026-03-15T10:00:00Z"),
    },
  });

  const shipment3 = await prisma.shipment.create({
    data: {
      shipmentCode: "SH-2603-003",
      farmerId: farmer2.id,
      cargo: "Rice",
      weight: 3000,
      weightUnit: "kg",
      destination: "Mile 12 Market",
      price: 680000,
      status: "PENDING",
    },
  });

  // A delivered shipment for performance tracking
  await prisma.shipment.create({
    data: {
      shipmentCode: "SH-2602-001",
      farmerId: farmer1.id,
      cargo: "Maize",
      weight: 4000,
      weightUnit: "kg",
      destination: "Oshodi Market",
      price: 300000,
      status: "DELIVERED",
      transporterId: transporter1.id,
      routeId: route1.id,
      routeAccepted: true,
      estimatedArrival: new Date("2026-02-28T12:00:00Z"),
      updatedAt: new Date("2026-02-28T11:30:00Z"), // delivered on time
    },
  });

  await prisma.shipment.create({
    data: {
      shipmentCode: "SH-2602-002",
      farmerId: farmer2.id,
      cargo: "Beans",
      weight: 1500,
      weightUnit: "kg",
      destination: "Mile 12 Market",
      price: 200000,
      status: "DELIVERED",
      transporterId: transporter2.id,
      routeId: route3.id,
      routeAccepted: true,
      estimatedArrival: new Date("2026-02-26T16:00:00Z"),
      updatedAt: new Date("2026-02-26T18:30:00Z"), // delivered late
    },
  });

  console.log("Shipments created (5 shipments)");

  // ─── WALLETS ───
  const walletData = [
    { userId: farmer1.id, balance: 580000 },
    { userId: farmer2.id, balance: 320000 },
    { userId: seller1.id, balance: 1200000 },
    { userId: seller2.id, balance: 750000 },
    { userId: transporter1.id, balance: 180000 },
    { userId: transporter2.id, balance: 95000 },
  ];

  const wallets = {};
  for (const w of walletData) {
    const wallet = await prisma.wallet.create({ data: w });
    wallets[w.userId] = wallet;
  }

  console.log("Wallets created");

  // ─── TRANSACTIONS ───
  await prisma.transaction.createMany({
    data: [
      {
        walletId: wallets[seller1.id].id,
        type: "CREDIT",
        amount: 1500000,
        description: "Wallet top-up",
        reference: "TXN-SEED-001",
      },
      {
        walletId: wallets[seller1.id].id,
        type: "PAYMENT",
        amount: 180000,
        description: "Payment for Tomatoes - ORD-2026-001",
        reference: "TXN-SEED-002",
      },
      {
        walletId: wallets[farmer1.id].id,
        type: "CREDIT",
        amount: 180000,
        description: "Payment received for Tomatoes - ORD-2026-001",
        reference: "TXN-SEED-003",
      },
      {
        walletId: wallets[seller1.id].id,
        type: "PAYMENT",
        amount: 360000,
        description: "Payment for Rice - ORD-2026-002",
        reference: "TXN-SEED-004",
      },
      {
        walletId: wallets[farmer2.id].id,
        type: "CREDIT",
        amount: 360000,
        description: "Payment received for Rice - ORD-2026-002",
        reference: "TXN-SEED-005",
      },
      {
        walletId: wallets[seller2.id].id,
        type: "CREDIT",
        amount: 1000000,
        description: "Wallet top-up",
        reference: "TXN-SEED-006",
      },
      {
        walletId: wallets[transporter1.id].id,
        type: "CREDIT",
        amount: 180000,
        description: "Delivery payment - SH-2602-001",
        reference: "TXN-SEED-007",
      },
    ],
  });

  console.log("Transactions created");

  // ─── CART ITEMS (Seller1 has items in cart) ───
  await prisma.cartItem.createMany({
    data: [
      { userId: seller1.id, produceId: beans.id, quantity: 100 },
      { userId: seller1.id, produceId: onions.id, quantity: 200 },
      { userId: seller2.id, produceId: tomatoes.id, quantity: 75 },
    ],
  });

  console.log("Cart items created");

  // ─── ALERTS ───
  await prisma.alert.createMany({
    data: [
      {
        type: "supply_insight",
        message: "Supply drop expected next week due to Kaduna rains.",
        recommendation: "Stock up now to maintain inventory levels.",
        severity: "medium",
        userId: null, // global alert
      },
      {
        type: "supply_insight",
        message: "Tomato prices trending up 15% this month in Lagos markets.",
        recommendation: "Consider ordering in bulk at current prices.",
        severity: "low",
        userId: seller1.id,
      },
      {
        type: "price_alert",
        message: "Rice prices expected to stabilize next week.",
        recommendation: "Hold off on large purchases until prices drop.",
        severity: "low",
        userId: null,
      },
    ],
  });

  console.log("Alerts created");

  // ─── NOTIFICATIONS ───
  await prisma.notification.createMany({
    data: [
      // Seller notifications
      { userId: seller1.id, message: "Your order ORD-2026-001 has been delivered!", read: true },
      { userId: seller1.id, message: "Your order ORD-2026-002 is now in transit.", read: false },
      { userId: seller1.id, message: "New produce available: Peppers from Kaduna.", read: false },
      // Farmer notifications
      { userId: farmer1.id, message: "New order received: 150kg Tomatoes from Chioma Okafor.", read: true },
      { userId: farmer1.id, message: "Shipment SH-2603-001 is in transit.", read: false },
      { userId: farmer2.id, message: "New order received: 100kg Beans from Emeka Nwosu.", read: false },
      // Transporter notifications
      { userId: transporter1.id, message: "New shipment assigned: SH-2603-002 (Peppers to Oshodi).", read: false },
      { userId: transporter1.id, message: "Delivery for ORD-2026-001 marked as completed.", read: true },
    ],
  });

  console.log("Notifications created");

  // ─── AI RESULTS ───
  await prisma.aIResult.createMany({
    data: [
      // Route optimization for transporter
      {
        type: "ROUTE",
        result: {
          message: "Delay expected due to traffic on Lagos-Ibadan expressway",
          suggested_action: "Use alternate road via Ikorodu to avoid 2-hour delay",
        },
        deliveryId: delivery2.id,
      },
      // Cargo risk
      {
        type: "CARGO_RISK",
        result: {
          product: "Tomatoes",
          message: "High temperature (35°C) may reduce freshness by 15%",
          severity: "medium",
          recommendation: "Reduce transport time or use refrigerated vehicle",
        },
        deliveryId: delivery2.id,
      },
      // Supply insight
      {
        type: "SUPPLY_INSIGHT",
        result: {
          message: "Tomato supply from Kaduna expected to drop 30% next week",
          recommendation: "Stock up now to maintain inventory levels",
          affected_produce: "Tomatoes",
          confidence: 0.85,
        },
        produceId: tomatoes.id,
      },
      // Shipment insight for farmer
      {
        type: "SHIPMENT_INSIGHT",
        result: {
          message: "Shipment will arrive faster if sent via Ibadan route",
          suggested_route: "Kaduna → Zaria → Ibadan → Lagos",
          time_saved_minutes: 60,
        },
        produceId: peppers.id,
      },
      // Freshness prediction
      {
        type: "FRESHNESS",
        result: {
          produce: "Tomatoes",
          current_freshness: 92,
          predicted_freshness_on_arrival: 78,
          days_until_expiry: 12,
          recommendation: "Deliver within 48 hours for optimal quality",
        },
        produceId: tomatoes.id,
      },
      // Dispatch optimization
      {
        type: "DISPATCH",
        result: {
          message: "Combine shipments SH-2603-001 and SH-2603-002 for cost efficiency",
          potential_savings: 15000,
          suggested_vehicle: "Refrigerated Truck (LAG-234-KD)",
        },
        deliveryId: delivery2.id,
      },
    ],
  });

  console.log("AI results created");

  // ─── SUMMARY ───
  console.log("\n========================================");
  console.log("  Seed complete!");
  console.log("========================================");
  console.log("\nTest Accounts (password: password123):");
  console.log("  Admin:       admin@umojaagri.com");
  console.log("  Farmer 1:    shola@umojaagri.com   (Shola Adegboye, Kaduna)");
  console.log("  Farmer 2:    amina@umojaagri.com   (Amina Bello, Kano)");
  console.log("  Seller 1:    chioma@umojaagri.com  (Chioma Okafor, Mile 12)");
  console.log("  Seller 2:    emeka@umojaagri.com   (Emeka Nwosu, Oshodi)");
  console.log("  Transporter: adebayo@umojaagri.com (Transport Logistics Nigeria)");
  console.log("  Transporter: fatima@umojaagri.com  (Farm Transit)");
  console.log("\nData created:");
  console.log("  6 produce items, 5 orders, 4 deliveries");
  console.log("  3 routes with waypoints, 5 shipments");
  console.log("  6 wallets with transactions, 3 cart items");
  console.log("  3 alerts, 8 notifications, 6 AI results");
  console.log("========================================\n");
}

main()
  .catch((e) => {
    console.error("Seed error:", e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
