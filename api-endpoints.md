# UmojaAgri API Endpoints Documentation

All protected endpoints require the header: `Authorization: Bearer <token>`

Roles: `FARMER`, `SELLER`, `TRANSPORTER`, `ADMIN`

---

## Authentication & Users

### Register User
- **Endpoint**: `POST /api/users/register`
- **Description**: Registers a new user.
- **Request Body**:
  ```json
  {
    "email": "string",
    "password": "string",
    "name": "string",
    "location": "string (optional)",
    "phone": "string (optional)",
    "roleId": "string"
  }
  ```
- **Response**: Created user details.

### Login User
- **Endpoint**: `POST /api/users/login`
- **Description**: Logs in a user and returns a JWT token.
- **Request Body**:
  ```json
  {
    "email": "string",
    "password": "string"
  }
  ```
- **Response**:
  ```json
  {
    "token": "string"
  }
  ```

### Get User Profile
- **Endpoint**: `GET /api/users/profile`
- **Auth**: Any authenticated user
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "id": "string",
      "email": "string",
      "name": "string",
      "location": "string",
      "phone": "string",
      "role": { "name": "string" },
      "createdAt": "ISODate"
    }
  }
  ```

### Update User Profile
- **Endpoint**: `PATCH /api/users/profile`
- **Auth**: Any authenticated user
- **Request Body**:
  ```json
  {
    "name": "string (optional)",
    "location": "string (optional)",
    "phone": "string (optional)"
  }
  ```
- **Response**: Updated user details.

---

## Dashboard

### Get Role-Based Dashboard
- **Endpoint**: `GET /api/dashboard`
- **Auth**: Any authenticated user
- **Description**: Returns a combined dashboard payload based on the user's role.

**Seller response** includes: user info, notifications count, cart item count, alerts, incoming deliveries, marketplace products, order summary (active count + total value).

**Farmer response** includes: user info, notifications count, monthly revenue, yield trends, recent shipments.

**Transporter response** includes: driver info, notifications count, current load, active shipments.

---

## Produce

### Add Produce
- **Endpoint**: `POST /api/produces`
- **Auth**: FARMER
- **Request Body**:
  ```json
  {
    "name": "string",
    "description": "string (optional)",
    "quantity": "number",
    "unit": "string (optional)",
    "pricePerUnit": "number (optional)",
    "freshnessScore": "number (optional)",
    "imageUrl": "string (optional)",
    "location": "string (optional)",
    "harvestDate": "ISODate (optional)",
    "expiryDate": "ISODate (optional)"
  }
  ```
- **Response**: Created produce details.

### List My Produces
- **Endpoint**: `GET /api/produces/me`
- **Auth**: FARMER
- **Response**: List of farmer's produces.

### Edit Produce
- **Endpoint**: `PUT /api/produces/:id`
- **Auth**: FARMER
- **Request Body**: Fields to update.
- **Response**: Success message.

### Delete Produce
- **Endpoint**: `DELETE /api/produces/:id`
- **Auth**: FARMER
- **Response**: Success message.

### List Marketplace Produces
- **Endpoint**: `GET /api/produces/marketplace`
- **Auth**: ADMIN, SELLER, TRANSPORTER
- **Description**: Lists all produces with supplier (farmer) info for the marketplace.
- **Response**:
  ```json
  {
    "success": true,
    "count": "number",
    "data": [
      {
        "id": "string",
        "name": "string",
        "pricePerUnit": "number",
        "unit": "string",
        "freshnessScore": "number",
        "imageUrl": "string",
        "owner": { "id": "string", "name": "string", "email": "string" }
      }
    ]
  }
  ```

### List All Produces
- **Endpoint**: `GET /api/produces`
- **Auth**: ADMIN, FARMER, TRANSPORTER
- **Response**: List of all produces.

---

## Orders

### Place Order
- **Endpoint**: `POST /api/orders`
- **Auth**: SELLER
- **Description**: Places an order. Amount is auto-calculated as `quantity * pricePerUnit`. A human-readable `orderCode` (e.g. `ORD-2026-001`) is auto-generated.
- **Request Body**:
  ```json
  {
    "produceId": "string",
    "quantity": "number",
    "unit": "string (optional, defaults to produce unit)"
  }
  ```
- **Response**: Created order with orderCode and amount.

### List Seller Orders
- **Endpoint**: `GET /api/orders/seller`
- **Auth**: SELLER
- **Response**:
  ```json
  {
    "success": true,
    "count": "number",
    "data": [
      {
        "id": "string",
        "orderCode": "string",
        "quantity": "number",
        "unit": "string",
        "amount": "number",
        "status": "string",
        "createdAt": "ISODate",
        "produce": { "id": "string", "name": "string", "pricePerUnit": "number", "unit": "string" },
        "farmer": { "id": "string", "name": "string" },
        "delivery": { "id": "string", "status": "string", "progressPercent": "number", "etaMinutes": "number" }
      }
    ]
  }
  ```

### Seller Order Summary
- **Endpoint**: `GET /api/orders/seller/summary`
- **Auth**: SELLER
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "active_orders": "number",
      "total_value": "number"
    }
  }
  ```

### List Orders for Farmer
- **Endpoint**: `GET /api/orders/farmer`
- **Auth**: FARMER
- **Response**: List of orders placed for the farmer's produce.

### Approve/Reject Order
- **Endpoint**: `PATCH /api/orders/:id/status`
- **Auth**: FARMER
- **Request Body**:
  ```json
  {
    "status": "CONFIRMED | REJECTED"
  }
  ```
- **Response**: Updated order. If confirmed, a delivery is auto-created and linked.

### Get Order by ID
- **Endpoint**: `GET /api/orders/:id`
- **Auth**: ADMIN, SELLER, FARMER
- **Response**: Full order details with produce, seller, farmer, and delivery info.

---

## Deliveries

### Create Delivery
- **Endpoint**: `POST /api/deliveries`
- **Request Body**:
  ```json
  {
    "produceId": "string",
    "sellerId": "string",
    "quantity": "number",
    "storageId": "string"
  }
  ```
- **Response**: Created delivery details.

### Get All Deliveries
- **Endpoint**: `GET /api/deliveries`
- **Response**: List of all deliveries with produce, transport, and events.

### Get Incoming Deliveries (Seller)
- **Endpoint**: `GET /api/deliveries/incoming`
- **Auth**: SELLER
- **Description**: Lists deliveries for orders placed by the seller.
- **Response**:
  ```json
  {
    "success": true,
    "count": "number",
    "data": [
      {
        "id": "string",
        "status": "string",
        "progressPercent": "number",
        "etaMinutes": "number",
        "produce": { "name": "string" },
        "order": { "id": "string", "quantity": "number", "unit": "string", "farmer": { "name": "string", "location": "string" } },
        "transport": { "transporter": { "id": "string", "name": "string" } }
      }
    ]
  }
  ```

### Get Delivery by ID
- **Endpoint**: `GET /api/deliveries/:id`
- **Response**: Delivery details with produce, transport assignment, and events.

### Update Delivery Status
- **Endpoint**: `PATCH /api/deliveries/:id/status`
- **Description**: Updates delivery status and syncs linked order status. Emits socket.io events if configured.
- **Request Body**:
  ```json
  {
    "status": "PENDING | ASSIGNED | IN_TRANSIT | DELIVERED | CANCELLED",
    "location": "string (optional)"
  }
  ```
- **Response**: Updated delivery details.

---

## Transport Assignment

### Assign Transport
- **Endpoint**: `POST /api/transport/assign`
- **Description**: Assigns a transporter and vehicle to a pending delivery. Validates vehicle capacity.
- **Request Body**:
  ```json
  {
    "deliveryId": "string",
    "transporterId": "string",
    "vehicleId": "string"
  }
  ```
- **Response**: Transport assignment details.

### Get Transport Assignment
- **Endpoint**: `GET /api/transport/:deliveryId`
- **Response**: Assignment details with transporter, vehicle, and delivery info.

---

## Alerts

### List Alerts
- **Endpoint**: `GET /api/alerts`
- **Auth**: Any authenticated user
- **Description**: Returns alerts targeted at the user or global alerts (userId = null).
- **Response**:
  ```json
  {
    "success": true,
    "count": "number",
    "data": [
      {
        "id": "string",
        "type": "string",
        "message": "string",
        "recommendation": "string",
        "severity": "string",
        "createdAt": "ISODate"
      }
    ]
  }
  ```

### Create Alert
- **Endpoint**: `POST /api/alerts`
- **Auth**: Any authenticated user
- **Request Body**:
  ```json
  {
    "type": "string",
    "message": "string",
    "recommendation": "string (optional)",
    "severity": "string",
    "userId": "string (optional, null for global alerts)"
  }
  ```
- **Response**: Created alert.

---

## Notifications

### List Notifications
- **Endpoint**: `GET /api/notifications`
- **Auth**: Any authenticated user
- **Response**:
  ```json
  {
    "success": true,
    "unread_count": "number",
    "count": "number",
    "data": [
      {
        "id": "string",
        "message": "string",
        "read": "boolean",
        "createdAt": "ISODate"
      }
    ]
  }
  ```

### Mark Notification as Read
- **Endpoint**: `PATCH /api/notifications/:id/read`
- **Auth**: Any authenticated user
- **Response**: Success message.

### Mark All Notifications as Read
- **Endpoint**: `PATCH /api/notifications/read-all`
- **Auth**: Any authenticated user
- **Response**: Success message.

---

## Cart

### Get Cart
- **Endpoint**: `GET /api/cart`
- **Auth**: SELLER
- **Response**:
  ```json
  {
    "success": true,
    "count": "number",
    "data": [
      {
        "id": "string",
        "quantity": "number",
        "produce": {
          "id": "string",
          "name": "string",
          "pricePerUnit": "number",
          "unit": "string",
          "imageUrl": "string",
          "freshnessScore": "number",
          "owner": { "id": "string", "name": "string" }
        }
      }
    ]
  }
  ```

### Add to Cart
- **Endpoint**: `POST /api/cart`
- **Auth**: SELLER
- **Description**: Adds a produce to the cart. If the item already exists, updates the quantity.
- **Request Body**:
  ```json
  {
    "produceId": "string",
    "quantity": "number"
  }
  ```
- **Response**: Cart item details.

### Update Cart Item Quantity
- **Endpoint**: `PATCH /api/cart/:produceId`
- **Auth**: SELLER
- **Request Body**:
  ```json
  {
    "quantity": "number"
  }
  ```
- **Response**: Updated cart item.

### Remove Cart Item
- **Endpoint**: `DELETE /api/cart/:produceId`
- **Auth**: SELLER
- **Response**: Success message.

### Clear Cart
- **Endpoint**: `DELETE /api/cart/clear`
- **Auth**: SELLER
- **Response**: Success message.

---

## Finance

### Get Wallet
- **Endpoint**: `GET /api/finance/wallet`
- **Auth**: Any authenticated user
- **Description**: Returns the user's wallet. Auto-creates one if it doesn't exist.
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "id": "string",
      "balance": "number",
      "currency": "NGN",
      "createdAt": "ISODate"
    }
  }
  ```

### Get Transactions
- **Endpoint**: `GET /api/finance/transactions`
- **Auth**: Any authenticated user
- **Response**:
  ```json
  {
    "success": true,
    "count": "number",
    "data": [
      {
        "id": "string",
        "type": "CREDIT | DEBIT | PAYMENT | REFUND",
        "amount": "number",
        "description": "string",
        "reference": "string",
        "createdAt": "ISODate"
      }
    ]
  }
  ```

### Fund Wallet
- **Endpoint**: `POST /api/finance/fund`
- **Auth**: Any authenticated user
- **Request Body**:
  ```json
  {
    "amount": "number",
    "description": "string (optional)"
  }
  ```
- **Response**: Transaction details.

### Make Payment
- **Endpoint**: `POST /api/finance/pay`
- **Auth**: Any authenticated user
- **Description**: Transfers funds from the authenticated user's wallet to a recipient's wallet.
- **Request Body**:
  ```json
  {
    "recipientId": "string",
    "amount": "number",
    "description": "string (optional)"
  }
  ```
- **Response**: Payment confirmation.

---

## Farmer

### Get Farmer Profile
- **Endpoint**: `GET /api/farmer/profile`
- **Auth**: FARMER
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "id": "string",
      "name": "string",
      "location": "string",
      "phone": "string",
      "email": "string",
      "notifications_count": "number"
    }
  }
  ```

### Get Monthly Revenue
- **Endpoint**: `GET /api/farmer/revenue`
- **Auth**: FARMER
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "month": "February",
      "amount": "number",
      "currency": "NGN"
    }
  }
  ```

### Get Yield Trends
- **Endpoint**: `GET /api/farmer/yields`
- **Auth**: FARMER
- **Response**:
  ```json
  {
    "success": true,
    "data": [
      { "crop": "Tomatoes", "yield": 45 },
      { "crop": "Maize", "yield": 60 }
    ]
  }
  ```

---

## Shipments

### Create Shipment
- **Endpoint**: `POST /api/shipments`
- **Auth**: FARMER
- **Description**: Creates a farmer-to-market shipment. Auto-generates a `shipmentCode` (e.g. `SH-2603-001`).
- **Request Body**:
  ```json
  {
    "cargo": "string",
    "weight": "number",
    "weightUnit": "string (optional, default: kg)",
    "destination": "string",
    "price": "number (optional)"
  }
  ```
- **Response**: Created shipment with shipmentCode.

### List Farmer Shipments
- **Endpoint**: `GET /api/shipments`
- **Auth**: FARMER
- **Response**:
  ```json
  {
    "success": true,
    "count": "number",
    "data": [
      {
        "id": "string",
        "shipmentCode": "string",
        "cargo": "string",
        "weight": "number",
        "destination": "string",
        "price": "number",
        "status": "PENDING | TRANSPORTER_ASSIGNED | PICKED_UP | IN_TRANSIT | DELIVERED | CANCELLED",
        "transporter": { "id": "string", "name": "string", "transporterProfile": {} },
        "route": { "origin": "string", "destination": "string", "distanceKm": "number" }
      }
    ]
  }
  ```

### Shipment Summary
- **Endpoint**: `GET /api/shipments/summary`
- **Auth**: FARMER
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "active_shipments": "number",
      "total_shipments": "number",
      "routes": "number"
    }
  }
  ```

### Get Shipment by ID
- **Endpoint**: `GET /api/shipments/:id`
- **Auth**: FARMER, TRANSPORTER
- **Response**: Full shipment details with farmer, transporter profile, and route with stops.

### Get Recommended Transporter
- **Endpoint**: `GET /api/shipments/:shipmentId/recommendations`
- **Auth**: FARMER
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "id": "string",
      "company_name": "string",
      "rating": "number",
      "reason": "string"
    }
  }
  ```

### Select Transporter
- **Endpoint**: `POST /api/shipments/select-transporter`
- **Auth**: FARMER
- **Description**: Assigns a transporter to a shipment and updates status to `TRANSPORTER_ASSIGNED`.
- **Request Body**:
  ```json
  {
    "shipmentId": "string",
    "transporterId": "string"
  }
  ```
- **Response**: Updated shipment with transporter info.

---

## Transporters

### List Available Transporters
- **Endpoint**: `GET /api/transporters`
- **Auth**: Any authenticated user
- **Response**:
  ```json
  {
    "success": true,
    "count": "number",
    "data": [
      {
        "id": "string",
        "name": "string",
        "rating": "number",
        "price_per_km": "number",
        "vehicle_type": "string",
        "estimated_delivery_hours": "number",
        "location": "string"
      }
    ]
  }
  ```

### Get Transporter by ID
- **Endpoint**: `GET /api/transporters/:id`
- **Auth**: Any authenticated user
- **Response**: Transporter profile details.

### Create Transporter Profile
- **Endpoint**: `POST /api/transporters/profile`
- **Auth**: TRANSPORTER
- **Request Body**:
  ```json
  {
    "companyName": "string",
    "pricePerKm": "number (optional)",
    "vehicleType": "string (optional)",
    "estimatedDeliveryHours": "number (optional)"
  }
  ```
- **Response**: Created transporter profile.

---

## Driver

### Get Driver Profile
- **Endpoint**: `GET /api/driver/profile`
- **Auth**: TRANSPORTER
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "id": "string",
      "name": "string",
      "location": "string",
      "status": "string",
      "licenseNumber": "string",
      "experienceYears": "number",
      "rating": "number",
      "dynamicRouting": "boolean"
    }
  }
  ```

### Get Driver Shipments
- **Endpoint**: `GET /api/driver/shipments`
- **Auth**: TRANSPORTER
- **Response**: List of shipments assigned to the driver, with farmer info and route details.

### Get Current Load
- **Endpoint**: `GET /api/driver/load`
- **Auth**: TRANSPORTER
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "total_weight": "number",
      "weight_unit": "kg",
      "active_shipments": "number",
      "remaining_stops": "number",
      "progress_percent": "number"
    }
  }
  ```

### Get Driver Performance
- **Endpoint**: `GET /api/driver/performance`
- **Auth**: TRANSPORTER
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "total_deliveries": "number",
      "on_time_percent": "number",
      "late_percent": "number"
    }
  }
  ```

### Update Driver Settings
- **Endpoint**: `PATCH /api/driver/settings`
- **Auth**: TRANSPORTER
- **Request Body**:
  ```json
  {
    "dynamicRouting": "boolean"
  }
  ```
- **Response**: Updated driver profile.

---

## Routes

### Get Current Route for Shipment
- **Endpoint**: `GET /api/routes/:shipmentId/current`
- **Auth**: TRANSPORTER
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "id": "string",
      "origin": "string",
      "destination": "string",
      "distance_km": "number",
      "estimated_time_hours": "number",
      "risk_level": "string",
      "fuel_cost": "number",
      "toll_cost": "number",
      "total_cost": "number",
      "waypoints": ["string"]
    }
  }
  ```

### Get Route Cost
- **Endpoint**: `GET /api/routes/:routeId/cost`
- **Auth**: TRANSPORTER
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "fuel_cost": "number",
      "toll_cost": "number",
      "total_cost": "number"
    }
  }
  ```

### Get Route Waypoints
- **Endpoint**: `GET /api/routes/:routeId/waypoints`
- **Auth**: TRANSPORTER
- **Response**:
  ```json
  {
    "success": true,
    "data": ["Kaduna", "Zaria", "Ibadan", "Lagos"]
  }
  ```

### Get Alternative Routes
- **Endpoint**: `GET /api/routes/alternatives?origin=Kaduna&destination=Lagos`
- **Auth**: TRANSPORTER
- **Response**: List of alternative routes between origin and destination.

### Accept Route
- **Endpoint**: `POST /api/routes/accept`
- **Auth**: TRANSPORTER
- **Request Body**:
  ```json
  {
    "shipmentId": "string",
    "routeId": "string"
  }
  ```
- **Response**: Updated shipment with accepted route.

### Create Route
- **Endpoint**: `POST /api/routes`
- **Auth**: ADMIN, TRANSPORTER
- **Request Body**:
  ```json
  {
    "origin": "string",
    "destination": "string",
    "distanceKm": "number",
    "estimatedTimeMinutes": "number",
    "riskLevel": "string (optional)",
    "fuelCost": "number (optional)",
    "tollCost": "number (optional)",
    "stops": ["Kaduna", "Zaria", "Ibadan", "Lagos"]
  }
  ```
- **Response**: Created route with stops.

---

## AI

### Get AI Recommendations
- **Endpoint**: `GET /api/ai/recommendations`
- **Auth**: TRANSPORTER
- **Description**: Returns AI-powered logistics recommendations (route optimization, dispatch, vehicle).
- **Response**:
  ```json
  {
    "success": true,
    "count": "number",
    "data": [
      {
        "id": "string",
        "type": "route",
        "message": "string",
        "suggested_action": "string",
        "created_at": "ISODate"
      }
    ]
  }
  ```

### Get Cargo Risks
- **Endpoint**: `GET /api/ai/risks`
- **Auth**: TRANSPORTER
- **Response**:
  ```json
  {
    "success": true,
    "count": "number",
    "data": [
      {
        "id": "string",
        "type": "cargo_risk",
        "product": "string",
        "message": "string",
        "severity": "string",
        "created_at": "ISODate"
      }
    ]
  }
  ```

### Get Shipment Insights
- **Endpoint**: `GET /api/ai/shipment-insights`
- **Auth**: FARMER
- **Response**: AI suggestions for shipment optimization.

### Get Supply Insights
- **Endpoint**: `GET /api/ai/supply-insights`
- **Auth**: SELLER
- **Description**: Returns supply forecasting alerts (e.g. "Supply drop expected due to Kaduna rains").
- **Response**: List of supply insight alerts.

### Create AI Result (Admin)
- **Endpoint**: `POST /api/ai`
- **Auth**: ADMIN
- **Request Body**:
  ```json
  {
    "type": "FRESHNESS | ROUTE | DISPATCH | VEHICLE | CARGO_RISK | SUPPLY_INSIGHT | SHIPMENT_INSIGHT",
    "result": "JSON object",
    "produceId": "string (optional)",
    "deliveryId": "string (optional)"
  }
  ```
- **Response**: Created AI result.

---

## Health Check

### Health Check
- **Endpoint**: `GET /health`
- **Response**:
  ```json
  {
    "status": "ok"
  }
  ```
