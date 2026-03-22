import 'package:get/get.dart';
import 'package:umoja_agri/controllers/farmer/dashboard_controller.dart';

class FarmerBinding extends Bindings {
  @override
  void dependencies() {
    // Register DashboardController as a singleton if not already registered
    if (!Get.isRegistered<DashboardController>()) {
      Get.lazyPut<DashboardController>(
        () => DashboardController(),
        fenix: true, // Rebuild if cleared from memory
      );
    }
  }
}
