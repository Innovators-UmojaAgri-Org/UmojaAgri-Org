// models/transporter_model.dart

class Shipment {
  final String id;
  final String title;
  final String origin;
  final String destination;
  final String status;
  final double weight;
  final String weightUnit;
  final double estimatedEarnings;
  final String currency;
  final String departureTime;
  final double distanceKm;
  final ShipmentStatus shipmentStatus;

  const Shipment({
    required this.id,
    required this.title,
    required this.origin,
    required this.destination,
    required this.status,
    required this.weight,
    required this.weightUnit,
    required this.estimatedEarnings,
    required this.currency,
    required this.departureTime,
    required this.distanceKm,
    required this.shipmentStatus,
  });
}

enum ShipmentStatus { pending, inTransit, delivered, cancelled }

class TransporterStats {
  final int totalDeliveries;
  final double totalEarnings;
  final double rating;
  final int activeShipments;

  const TransporterStats({
    required this.totalDeliveries,
    required this.totalEarnings,
    required this.rating,
    required this.activeShipments,
  });
}

class Transporter {
  final String id;
  final String name;
  final String vehicleType;
  final String vehiclePlate;
  final TransporterStats stats;
  final List<Shipment> shipments;

  const Transporter({
    required this.id,
    required this.name,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.stats,
    required this.shipments,
  });
}

// simple class to represent a suggested route and any notes (e.g., traffic delays)
class RouteRecommendation {
  final String title;
  final String duration;
  final double distanceKm;
  final String note;

  const RouteRecommendation({
    required this.title,
    required this.duration,
    required this.distanceKm,
    required this.note,
  });
}
