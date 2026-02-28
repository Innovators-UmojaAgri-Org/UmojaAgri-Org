// controllers/transporter_controller.dart

import 'package:get/get.dart';
import 'package:umoja_agri/models/transporter/transporter_model.dart';

class TransporterController extends GetxController {
  // Observable state
  final Rx<Transporter?> transporter = Rx<Transporter?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt selectedTabIndex = 0.obs;

  // route recommendations 
  final routeRecommendations = <RouteRecommendation>[].obs;

  // Derived lists 
  List<Shipment> get activeShipments =>
      transporter.value?.shipments
          .where((s) => s.shipmentStatus == ShipmentStatus.inTransit)
          .toList() ??
      [];

  List<Shipment> get pendingShipments =>
      transporter.value?.shipments
          .where((s) => s.shipmentStatus == ShipmentStatus.pending)
          .toList() ??
      [];

  List<Shipment> get completedShipments =>
      transporter.value?.shipments
          .where((s) => s.shipmentStatus == ShipmentStatus.delivered)
          .toList() ??
      [];

  List<Shipment> get currentTabShipments {
    switch (selectedTabIndex.value) {
      case 0:
        return activeShipments;
      case 1:
        return pendingShipments;
      case 2:
        return completedShipments;
      default:
        return activeShipments;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadTransporterData();
    // populate dummy routes when controller initializes
    loadMockRoutes();
  }

  Future<void> loadTransporterData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      transporter.value = const Transporter(
        id: 'T-00123',
        name: 'Samuel Okeke',
        vehicleType: 'Truck',
        vehiclePlate: 'LAG-334-KJ',
        stats: TransporterStats(
          totalDeliveries: 148,
          totalEarnings: 1240000,
          rating: 4.8,
          activeShipments: 2,
        ),
        shipments: [
          Shipment(
            id: 'SH-4521',
            title: 'A Ton of Tomatoes',
            origin: 'Kano',
            destination: 'Lagos',
            status: 'In Transit',
            weight: 1000,
            weightUnit: 'kg',
            estimatedEarnings: 85000,
            currency: '₦',
            departureTime: '08:00 AM',
            distanceKm: 1140,
            shipmentStatus: ShipmentStatus.inTransit,
          ),
          Shipment(
            id: 'SH-4522',
            title: 'Bagged Rice',
            origin: 'Abuja',
            destination: 'Port Harcourt',
            status: 'In Transit',
            weight: 2500,
            weightUnit: 'kg',
            estimatedEarnings: 120000,
            currency: '₦',
            departureTime: '10:30 AM',
            distanceKm: 680,
            shipmentStatus: ShipmentStatus.inTransit,
          ),
          Shipment(
            id: 'SH-4518',
            title: 'Fertilizer Supply',
            origin: 'Lagos',
            destination: 'Ibadan',
            status: 'Pending',
            weight: 800,
            weightUnit: 'kg',
            estimatedEarnings: 42000,
            currency: '₦',
            departureTime: '02:00 PM',
            distanceKm: 130,
            shipmentStatus: ShipmentStatus.pending,
          ),
          Shipment(
            id: 'SH-4510',
            title: 'Maize Bulk Order',
            origin: 'Kaduna',
            destination: 'Lagos',
            status: 'Delivered',
            weight: 3000,
            weightUnit: 'kg',
            estimatedEarnings: 160000,
            currency: '₦',
            departureTime: '06:00 AM',
            distanceKm: 1020,
            shipmentStatus: ShipmentStatus.delivered,
          ),
        ],
      );
    } catch (e) {
      errorMessage.value = 'Failed to load data. Please try again.';
    }

    isLoading.value = false;
  }

  void selectTab(int index) => selectedTabIndex.value = index;

  String statusToString(ShipmentStatus status) {
    switch (status) {
      case ShipmentStatus.pending:
        return 'At Farm';
      case ShipmentStatus.inTransit:
        return 'In Transit';
      case ShipmentStatus.delivered:
        return 'At the Market';
      case ShipmentStatus.cancelled:
        return 'Cancelled';
    }
  }

  void updateShipmentStatus(String id, ShipmentStatus newStatus) {
    final t = transporter.value;
    if (t == null) return;
    final updated =
        t.shipments.map((s) {
          if (s.id == id) {
            return Shipment(
              id: s.id,
              title: s.title,
              origin: s.origin,
              destination: s.destination,
              status: statusToString(newStatus),
              weight: s.weight,
              weightUnit: s.weightUnit,
              estimatedEarnings: s.estimatedEarnings,
              currency: s.currency,
              departureTime: s.departureTime,
              distanceKm: s.distanceKm,
              shipmentStatus: newStatus,
            );
          }
          return s;
        }).toList();
    transporter.value = Transporter(
      id: t.id,
      name: t.name,
      vehicleType: t.vehicleType,
      vehiclePlate: t.vehiclePlate,
      stats: t.stats,
      shipments: updated,
    );
  }

  /// generate some dummy route recommendations
  void loadMockRoutes() {
    routeRecommendations.assignAll([
      const RouteRecommendation(
        title: 'Lagos → Ibadan via Lekki Expressway',
        duration: '3h 40m',
        distanceKm: 126,
        note:
            'Heavy traffic expected near Lekki Expressway. Consider departure before 6 AM.',
      ),
      const RouteRecommendation(
        title: 'Abuja → Kaduna (A2 highway)',
        duration: '2h 15m',
        distanceKm: 190,
        note: 'Road works between Zaria and Kaduna might slow progress.',
      ),
    ]);
  }
}
