// models/transporter_model.dart

// models/transporter/transporter_model.dart
// Add these fields to your existing Shipment class (or replace it entirely).
// Only the Shipment class is shown here — keep everything else in the file as-is.

enum ShipmentStatus { pending, inTransit, delivered, cancelled }

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
  final String departureTime; // formatted ETA string
  final double distanceKm;
  final ShipmentStatus shipmentStatus;

  // ── New fields parsed from API ──────────────────────────────────────────
  /// Human-readable stop path, e.g. "Kano → Kaduna → Abuja → Lagos"
  final String stopPath;

  /// Risk level from route: "low" | "medium" | "high"
  final String riskLevel;

  /// Estimated fuel cost in naira
  final double fuelCost;

  /// Estimated toll cost in naira
  final double tollCost;

  /// Farmer's name from the nested farmer object
  final String farmerName;

  /// Shipment reference code e.g. "SH-2602-002"
  final String shipmentCode;

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
    this.stopPath = '',
    this.riskLevel = 'low',
    this.fuelCost = 0,
    this.tollCost = 0,
    this.farmerName = '',
    this.shipmentCode = '',
  });
}

class TransporterStats {
  final int totalDeliveries;
  final double totalEarnings;
  final double rating;
  final int activeShipments;
  final int notificationsCount;

  const TransporterStats({
    required this.totalDeliveries,
    required this.totalEarnings,
    required this.rating,
    required this.activeShipments,
    this.notificationsCount = 0,
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

// Route reason/benefit for why a route is recommended
class RouteReason {
  final String icon; // emoji or icon type
  final String title;
  final String description;

  const RouteReason({
    required this.icon,
    required this.title,
    required this.description,
  });
}

// Complete route recommendation with backend-like structure
class RouteRecommendation {
  final String id;
  final String title; // e.g., "Kaduna - Lagos Route"
  final String originCity;
  final String destinationCity;
  final double distanceKm;
  final String duration;
  final int freshness; // freshness % at arrival
  final String trafficStatus; // Light, Moderate, Heavy
  final double realInfo; // cost in naira
  final String status; // "Active", "Suggested"
  final String note; // detailed explanation
  final List<RouteReason> reasons; // why this route
  final bool isAlternative; // true if alternative route

  const RouteRecommendation({
    required this.id,
    required this.title,
    required this.originCity,
    required this.destinationCity,
    required this.distanceKm,
    required this.duration,
    required this.freshness,
    required this.trafficStatus,
    required this.realInfo,
    required this.status,
    this.note = '',
    this.reasons = const [],
    this.isAlternative = false,
  });
}
