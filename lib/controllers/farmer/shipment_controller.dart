import 'package:get/get.dart';
import '../../models/farmer/shipment_model.dart';

class ShipmentController extends GetxController {
  var isLoading = false.obs;
  var selectedFilter = "All".obs;

  final shipments = <ShipmentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMockShipments();
  }

  void loadMockShipments() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    shipments.value = [
      ShipmentModel(
        id: "SH-2403",
        product: "Cassava",
        bags: 200,
        status: "Pending",
        destination: "Port Harcourt",
        departureDate: "Feb 18, 2026",
        arrivalDate: "Feb 20, 2026",
        distanceKm: 420,
        needsTransport: true,
        driverName: "Not Assigned",
        recommendedVehicle: "Ventilated Vehicle",
        vehicleReasons: [
          "Root vegetables need ventilation",
          "Medium storage duration (2 days)",
        ],
      ),
      ShipmentModel(
        id: "SH-2403",
        product: "Cassava",
        bags: 300,
        status: "In Transit",
        destination: "Port Harcourt",
        departureDate: "Feb 18, 2026",
        arrivalDate: "Feb 20, 2026",
        distanceKm: 420,
        needsTransport: false,
        driverName: "Ahmed Musa",
        recommendedVehicle: "Ventilated Truck",
        vehicleReasons: [
          "Root vegetables need ventilation",
          "Medium storage duration (2 days)",
        ],
      ),
      ShipmentModel(
        id: "SH-2402",
        product: "Rice",
        bags: 300,
        status: "Delivered",
        destination: "Port Harcourt",
        departureDate: "Feb 18, 2026",
        arrivalDate: "Feb 20, 2026",
        distanceKm: 280,
        needsTransport: false,
        driverName: "Mary Eze",
        recommendedVehicle: "Standard Vehicle",
        vehicleReasons: [
          "Packaged grain, minimal special handling",
          "Short duration (1 day)",
        ],
      ),
      ShipmentModel(
        id: "SH-2404",
        product: "Tomatoes",
        bags: 20,
        status: "Pending",
        destination: "Kano",
        departureDate: "Feb 20, 2026",
        arrivalDate: "Feb 22, 2026",
        distanceKm: 610,
        needsTransport: true,
        driverName: "Not Assigned",
        recommendedVehicle: "Refrigerated Vehicle",
        vehicleReasons: [
          "Perishable item requiring cold chain",
          "Long distance delivery (610 km)",
        ],
      ),
    ];

    isLoading.value = false;
  }

  List<ShipmentModel> get filteredShipments {
    if (selectedFilter.value == "Needs") {
      return shipments.where((s) => s.needsTransport).toList();
    }
    return shipments;
  }

  int get inTransitCount =>
      shipments.where((s) => s.status == "In Transit").length;

  int get deliveredCount =>
      shipments.where((s) => s.status == "Delivered").length;

  int get pendingCount => shipments.where((s) => s.status == "Pending").length;

  int get needsTransportCount =>
      shipments.where((s) => s.needsTransport).length;
}
