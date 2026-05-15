class TransporterModel {
  final String id;
  final String name;
  final String tag;
  final String driverName;
  final String vehicleType;
  final String phoneNumber;
  final String licensePlate;
  final String rate;
  final String eta;

  const TransporterModel({
    required this.id,
    required this.name,
    required this.tag,
    required this.driverName,
    required this.vehicleType,
    required this.phoneNumber,
    required this.licensePlate,
    required this.rate,
    required this.eta,
  });
}

class RouteRecommendation {
  final String id;
  final String title;
  final String duration;
  final String distance; 
  final String via;
  final String trafficLabel; 
  final String note; 
  final int freshnessPercent; 
  final bool isAiRecommended;

  const RouteRecommendation({
    required this.id,
    required this.title,
    required this.duration,
    required this.distance,
    required this.via,
    required this.trafficLabel,
    required this.note,
    required this.freshnessPercent,
    required this.isAiRecommended,
  });
}

class FreshnessComparison {
  final int currentRoutePercent;
  final int aiRoutePercent;

  const FreshnessComparison({
    required this.currentRoutePercent,
    required this.aiRoutePercent,
  });
}
