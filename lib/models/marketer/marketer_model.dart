// lib/models/order_model.dart

class Order {
  final String id;
  final String productName;
  final String farmName;
  final double quantity;
  final String unit;
  final double amount;
  final DateTime date;
  final OrderStatus status;

  Order({
    required this.id,
    required this.productName,
    required this.farmName,
    required this.quantity,
    required this.unit,
    required this.amount,
    required this.date,
    required this.status,
  });
}

enum OrderStatus { pending, confirmed, inTransit, delivered, cancelled }

class FarmProduce {
  final String id;
  final String name;
  final String farm;
  final String description;
  final double quantity;
  final String unit;
  final double pricePerKg;
  final int freshness;
  final String? imageUrl;
  final String location;

  FarmProduce({
    required this.id,
    required this.name,
    required this.farm,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.pricePerKg,
    required this.freshness,
    this.imageUrl,
    required this.location,
  });
}

class Delivery {
  final String id;
  final String product;
  final double quantity;
  final String unit;
  final String from;
  final String to;
  final String shipmentId;
  final int progressPercent;
  final String eta;
  final String status;
  final String currentLocation;
  final String? transporterName;

  Delivery({
    required this.id,
    required this.product,
    required this.quantity,
    required this.unit,
    required this.from,
    required this.to,
    required this.shipmentId,
    required this.progressPercent,
    required this.eta,
    required this.status,
    required this.currentLocation,
    this.transporterName,
  });
}

class Alert {
  final String id;
  final String type;
  final String message;
  final String recommendation;
  final String severity;

  Alert({
    required this.id,
    required this.type,
    required this.message,
    required this.recommendation,
    required this.severity,
  });
}

class FinanceTransaction {
  final String description;
  final String orderId;
  final double amount;
  final DateTime date;
  final bool isCredit;

  FinanceTransaction({
    required this.description,
    required this.orderId,
    required this.amount,
    required this.date,
    required this.isCredit,
  });
}

class CartItem {
  final String id;
  final FarmProduce produce;
  final double quantity;

  CartItem({required this.id, required this.produce, required this.quantity});

  double get totalPrice => quantity * produce.pricePerKg;
}
