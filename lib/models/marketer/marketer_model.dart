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

enum OrderStatus { pending, confirmed, inTransit, delivered }

class FarmProduce {
  final String name;
  final String farm;
  final double quantity;
  final String unit;
  final double pricePerKg;
  final int freshness;
  final String imageEmoji;

  FarmProduce({
    required this.name,
    required this.farm,
    required this.quantity,
    required this.unit,
    required this.pricePerKg,
    required this.freshness,
    required this.imageEmoji,
  });
}

class Delivery {
  final String product;
  final double quantity;
  final String unit;
  final String from;
  final String shipmentId;
  final int progressPercent;
  final String eta;

  Delivery({
    required this.product,
    required this.quantity,
    required this.unit,
    required this.from,
    required this.shipmentId,
    required this.progressPercent,
    required this.eta,
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
