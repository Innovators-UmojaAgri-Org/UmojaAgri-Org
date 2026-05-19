import 'package:get/get.dart';
import 'package:umoja_agri/controllers/transporter/transporter_controller.dart';

class TransporterBinding extends Bindings {
  @override
  void dependencies() {
    // Register TransporterController as a singleton if not already registered
    if (!Get.isRegistered<TransporterController>()) {
      Get.put<TransporterController>(
        TransporterController(),
        permanent: true, // Keep alive across app lifecycle
      );
    }
  }
}
