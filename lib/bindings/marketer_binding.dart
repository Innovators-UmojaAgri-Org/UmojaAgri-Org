import 'package:get/get.dart';
import 'package:umoja_agri/controllers/marketer/market_controller.dart';

class MarketerBinding extends Bindings {
  @override
  void dependencies() {
    // Register MarketerController as a singleton if not already registered
    if (!Get.isRegistered<MarketerController>()) {
      Get.lazyPut<MarketerController>(
        () => MarketerController(),
        fenix: true, // Rebuild if cleared from memory
      );
    }
  }
}
