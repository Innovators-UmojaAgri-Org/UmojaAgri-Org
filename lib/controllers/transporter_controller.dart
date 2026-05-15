import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/transporter_model.dart';

class TransporterController extends GetxController {
  var isLoading = false.obs;
  var selectedTransporter = Rxn<TransporterModel>();
  final transporters = <TransporterModel>[].obs;
  final routeRecommendations = <RouteRecommendation>[].obs;
  var dispatchTimingEnabled = true.obs;
  var freshnessComparison = Rxn<FreshnessComparison>();

  @override
  void onInit() {
    super.onInit();
    loadMockTransporters();
  }

  void loadMockTransporters() async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 800));

    transporters.value = [
      const TransporterModel(
        id: "T-001",
        name: "TransLog Nigeria",
        tag: "Verified Carrier",
        driverName: "Ahmed Musa",
        vehicleType: "Ventilated Truck",
        phoneNumber: "+234 803 456 7890",
        licensePlate: "LAG-485-FD",
        rate: "₦85,000",
        eta: "2 days",
      ),
      const TransporterModel(
        id: "T-002",
        name: "SwiftHaul Ltd",
        tag: "Verified Carrier",
        driverName: "Chukwudi Obi",
        vehicleType: "Refrigerated Truck",
        phoneNumber: "+234 812 345 6789",
        licensePlate: "ABJ-221-KL",
        rate: "₦92,000",
        eta: "3 days",
      ),
      const TransporterModel(
        id: "T-003",
        name: "AgriMove Express",
        tag: "Carrier",
        driverName: "Emeka Nwosu",
        vehicleType: "Open Flatbed",
        phoneNumber: "+234 705 678 9012",
        licensePlate: "PHC-334-MN",
        rate: "₦70,000",
        eta: "2 days",
      ),
    ];

    isLoading.value = false;
  }

  /// Load mock route recommendations / freshness info
  Future<void> loadMockRoutes() async {

    await Future.delayed(const Duration(milliseconds: 400));

    freshnessComparison.value = const FreshnessComparison(
      currentRoutePercent: 70,
      aiRoutePercent: 95,
    );

    routeRecommendations.assignAll([
      const RouteRecommendation(
        id: 'R-001',
        title: 'Current Route',
        duration: '2hrs 45min',
        distance: '485 km',
        via: 'Via A2 Express - Major delay at Abuja checkpoint',
        trafficLabel: 'Heavy Traffic',
        note: 'Abuja Checkpoint: 45min delay due to inspection',
        freshnessPercent: 70,
        isAiRecommended: false,
      ),
      const RouteRecommendation(
        id: 'R-002',
        title: 'AI-Recommended Route',
        duration: '2hrs',
        distance: '492 km',
        via: 'Via A1 & B5 Route - Smooth highway conditions',
        trafficLabel: 'Clear Traffic',
        note: 'Smooth highway conditions',
        freshnessPercent: 95,
        isAiRecommended: true,
      ),
    ]);
  }

  void selectTransporter(TransporterModel transporter) {
    selectedTransporter.value = transporter;
  }

  void clearSelection() {
    selectedTransporter.value = null;
  }

  void toggleDispatchTiming(bool enabled) {
    dispatchTimingEnabled.value = enabled;
  }

  void keepCurrentRoute() {
   
    Get.snackbar(
      'Route kept',
      'You have chosen to keep the current route',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showSuccessModal() {
    Get.dialog(
      AlertDialog(
        title: const Text('Success'),
        content: const Text('Route successfully applied.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }
}
