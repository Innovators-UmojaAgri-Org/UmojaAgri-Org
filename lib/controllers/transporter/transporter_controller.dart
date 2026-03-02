import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:umoja_agri/models/transporter/transporter_model.dart';
import 'package:umoja_agri/services/transport_service.dart';
import 'package:umoja_agri/services/delivery_service.dart';

class TransporterController extends GetxController {
  final Rx<Transporter?> transporter = Rx<Transporter?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt selectedTabIndex = 0.obs;
  final routeRecommendations = <RouteRecommendation>[].obs;
  final _box = GetStorage();

  List<Shipment> get activeShipments => transporter.value?.shipments
      .where((s) => s.shipmentStatus == ShipmentStatus.inTransit).toList() ?? [];
  List<Shipment> get pendingShipments => transporter.value?.shipments
      .where((s) => s.shipmentStatus == ShipmentStatus.pending).toList() ?? [];
  List<Shipment> get completedShipments => transporter.value?.shipments
      .where((s) => s.shipmentStatus == ShipmentStatus.delivered).toList() ?? [];

  List<Shipment> get currentTabShipments {
    switch (selectedTabIndex.value) {
      case 0: return activeShipments;
      case 1: return pendingShipments;
      case 2: return completedShipments;
      default: return activeShipments;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadTransporterData();
  }

  Future<void> loadTransporterData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final token = _box.read('token') ?? '';
      final name = _box.read('name') ?? 'Transporter';

      final assignmentsRes = await TransportService().getTransportAssignments(token);

      List<Shipment> shipmentList = [];

      if (assignmentsRes.statusCode == 200) {
        final data = jsonDecode(assignmentsRes.body) as List;
        shipmentList = data.map((a) {
          final delivery = a['delivery'];
          final statusStr = delivery?['status'] ?? 'PENDING';
          return Shipment(
            id: a['id'],
            title: delivery?['produce']?['name'] ?? 'Shipment',
            origin: 'Farm',
            destination: delivery?['storage']?['address'] ?? 'Storage',
            status: statusStr,
            weight: (delivery?['produce']?['quantity'] ?? 0).toDouble(),
            weightUnit: delivery?['produce']?['unit'] ?? 'kg',
            estimatedEarnings: 0,
            currency: '₦',
            departureTime: '',
            distanceKm: 0,
            shipmentStatus: _parseStatus(statusStr),
          );
        }).toList();
      }

      transporter.value = Transporter(
        id: _box.read('userId') ?? '',
        name: name,
        vehicleType: 'Truck',
        vehiclePlate: '',
        stats: TransporterStats(
          totalDeliveries: completedShipments.length,
          totalEarnings: 0,
          rating: 0,
          activeShipments: activeShipments.length,
        ),
        shipments: shipmentList,
      );
    } catch (e) {
      errorMessage.value = 'Failed to load data. Please try again.';
    }
    isLoading.value = false;
  }

  void selectTab(int index) => selectedTabIndex.value = index;

  ShipmentStatus _parseStatus(String status) {
    switch (status) {
      case 'IN_TRANSIT': return ShipmentStatus.inTransit;
      case 'DELIVERED': return ShipmentStatus.delivered;
      case 'CANCELLED': return ShipmentStatus.cancelled;
      default: return ShipmentStatus.pending;
    }
  }

  void updateShipmentStatus(String id, ShipmentStatus newStatus) {
    final t = transporter.value;
    if (t == null) return;
    final updated = t.shipments.map((s) {
      if (s.id == id) {
        return Shipment(
          id: s.id, title: s.title, origin: s.origin,
          destination: s.destination, status: newStatus.name,
          weight: s.weight, weightUnit: s.weightUnit,
          estimatedEarnings: s.estimatedEarnings, currency: s.currency,
          departureTime: s.departureTime, distanceKm: s.distanceKm,
          shipmentStatus: newStatus,
        );
      }
      return s;
    }).toList();
    transporter.value = Transporter(
      id: t.id, name: t.name, vehicleType: t.vehicleType,
      vehiclePlate: t.vehiclePlate, stats: t.stats, shipments: updated,
    );
  }
}