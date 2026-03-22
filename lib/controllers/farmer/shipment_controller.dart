import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:umoja_agri/models/farmer/shipment_model.dart';
import 'package:umoja_agri/services/shipment_service.dart';

class ShipmentController extends GetxController {
  var isLoading = false.obs;
  var selectedFilter = "All".obs;
  final shipments = <ShipmentModel>[].obs;
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadShipments();
  }

  void loadShipments() async {
    isLoading.value = true;
    try {
      final token = _box.read('token') ?? '';
      // print('=== FARMER LOADING SHIPMENTS ===');
      final res = await ShipmentService().getShipments(token);
       if (res.statusCode == 200) {
        final response = jsonDecode(res.body);
        final data = response['data'] as List;
        shipments.value =
            data
                .map(
                  (s) => ShipmentModel(
                    id: s['shipmentCode'] ?? s['id'],
                    product: s['cargo'] ?? 'Unknown',
                    bags: (s['weight'] ?? 0).toInt(),
                    status: s['status'] ?? 'PENDING',
                    destination: s['destination'] ?? 'Unknown',
                    departureDate:
                        DateTime.tryParse(
                          s['createdAt'] ?? '',
                        )?.toString().substring(0, 10) ??
                        '',
                    arrivalDate: '',
                    distanceKm: (s['route']?['distanceKm'] ?? 0).toInt(),
                    needsTransport:
                        s['status'] == 'PENDING' || s['transporter'] == null,
                    driverName: s['transporter']?['name'] ?? 'Not Assigned',
                    recommendedVehicle: _getRecommendedVehicle(
                      s['cargo'] ?? '',
                    ),
                    vehicleReasons: _getVehicleReasons(s['cargo'] ?? ''),
                  ),
                )
                .toList();
        // print('✓ Loaded ${shipments.length} shipments successfully');
      } else {

      }
    } catch (e, stackTrace) {
    } finally {
      isLoading.value = false;
    }
  }

  List<ShipmentModel> get filteredShipments {
    if (selectedFilter.value == "Needs") {
      return shipments.where((s) => s.needsTransport).toList();
    }
    return shipments.toList();
  }

  int get inTransitCount =>
      shipments.where((s) => s.status == "IN_TRANSIT").length;
  int get deliveredCount =>
      shipments.where((s) => s.status == "DELIVERED").length;
  int get pendingCount => shipments.where((s) => s.status == "PENDING").length;
  int get needsTransportCount =>
      shipments.where((s) => s.needsTransport).length;

  String _getRecommendedVehicle(String cargo) {
    // Generate vehicle recommendations based on cargo type
    final cargoLower = cargo.toLowerCase();
    if (cargoLower.contains('tomato') || cargoLower.contains('pepper')) {
      return 'Refrigerated Truck';
    } else if (cargoLower.contains('rice') || cargoLower.contains('beans')) {
      return 'Covered Truck';
    } else if (cargoLower.contains('maize') || cargoLower.contains('corn')) {
      return 'Open Truck';
    } else if (cargoLower.contains('onion')) {
      return 'Ventilated Truck';
    } else {
      return 'Standard Truck';
    }
  }

  List<String> _getVehicleReasons(String cargo) {
    // Generate backend-like reasons for vehicle recommendations
    final cargoLower = cargo.toLowerCase();
    if (cargoLower.contains('tomato') || cargoLower.contains('pepper')) {
      return [
        'Temperature control prevents spoilage',
        'Maintains freshness during transit',
        'Reduces waste by up to 30%',
      ];
    } else if (cargoLower.contains('rice') || cargoLower.contains('beans')) {
      return [
        'Protection from moisture and pests',
        'Prevents contamination',
        'Maintains grain quality',
      ];
    } else if (cargoLower.contains('maize') || cargoLower.contains('corn')) {
      return [
        'Cost-effective for dry goods',
        'Easy loading/unloading',
        'Suitable for bulk transport',
      ];
    } else if (cargoLower.contains('onion')) {
      return [
        'Proper ventilation prevents sprouting',
        'Reduces moisture buildup',
        'Maintains market quality',
      ];
    } else {
      return [
        'Versatile for various cargo types',
        'Reliable performance',
        'Cost-effective transportation',
      ];
    }
  }
}
