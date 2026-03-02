import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:umoja_agri/models/farmer/shipment_model.dart';
import 'package:umoja_agri/services/delivery_service.dart';

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
      final res = await DeliveryService().getDeliveries(token);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        shipments.value = data.map((d) => ShipmentModel(
          id: d['id'],
          product: d['produce']?['name'] ?? 'Unknown',
          bags: (d['produce']?['quantity'] ?? 0).toInt(),
          status: d['status'],
          destination: d['storage']?['address'] ?? 'Unknown',
          departureDate: d['createdAt']?.toString().substring(0, 10) ?? '',
          arrivalDate: '',
          distanceKm: 0,
          needsTransport: d['transport'] == null,
          driverName: d['transport']?['transporter']?['name'] ?? 'Not Assigned',
          recommendedVehicle: '',
          vehicleReasons: [],
        )).toList();
      }
    } catch (e) {
      // fail silently
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

  int get inTransitCount => shipments.where((s) => s.status == "IN_TRANSIT").length;
  int get deliveredCount => shipments.where((s) => s.status == "DELIVERED").length;
  int get pendingCount => shipments.where((s) => s.status == "PENDING").length;
  int get needsTransportCount => shipments.where((s) => s.needsTransport).length;
}