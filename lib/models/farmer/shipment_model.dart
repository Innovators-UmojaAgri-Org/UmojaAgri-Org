
class ShipmentModel {
  final String id;
  final String product;
  final int bags;
  final String status;
  final String destination;
  final String departureDate;
  final String arrivalDate;
  final int distanceKm;
  final bool needsTransport;
  final String? driverName; 
  final String? recommendedVehicle; 
  final List<String>? vehicleReasons; 

  ShipmentModel({
    required this.id,
    required this.product,
    required this.bags,
    required this.status,
    required this.destination,
    required this.departureDate,
    required this.arrivalDate,
    required this.distanceKm,
    required this.needsTransport,
    this.driverName,
    this.recommendedVehicle,
    this.vehicleReasons,
  });
}
