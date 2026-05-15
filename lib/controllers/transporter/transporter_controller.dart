// import 'dart:convert';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:umoja_agri/models/transporter/transporter_model.dart';
import 'package:umoja_agri/services/transport_service.dart';
import 'package:umoja_agri/services/dashboard_service.dart';

class TransporterController extends GetxController {
  final Rx<Transporter?> transporter = Rx<Transporter?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoadingRoutes = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt selectedTabIndex = 0.obs;
  final routeRecommendations = <RouteRecommendation>[].obs;
  final _box = GetStorage();
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
  List<Shipment> get allShipments => transporter.value?.shipments ?? [];
  Shipment? get featuredShipment {
    final all = allShipments;
    if (all.isEmpty) return null;
    final inTransit = all.where(
      (s) => s.shipmentStatus == ShipmentStatus.inTransit,
    );
    if (inTransit.isNotEmpty) return inTransit.first;
    final pending = all.where(
      (s) => s.shipmentStatus == ShipmentStatus.pending,
    );
    if (pending.isNotEmpty) return pending.first;
    return all.first; // fall back to first
  }

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
  }

  bool isDataReady() {
    return transporter.value != null && !isLoading.value;
  }

  Future<void> ensureDataLoaded() async {
    if (isDataReady()) return;
    if (isLoading.value) {
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return isLoading.value;
      });
      return;
    }
    await loadTransporterData();
  }

  Future<void> loadTransporterData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final token = _box.read('token') ?? '';
      var name = _box.read('name') ?? 'Transporter';

      // Make API calls in parallel for better performance
      final results = await Future.wait([
        DashboardService().getDashboard(token),
        TransportService().getDriverShipments(token),
        TransportService().getDriverLoad(token),
      ]);

      final dashboardRes = results[0];
      final shipmentsRes = results[1];
      final loadRes = results[2];

      List<Shipment> shipmentList = [];

      if (shipmentsRes.statusCode == 200) {
        final body = jsonDecode(shipmentsRes.body) as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>? ?? [];

        shipmentList =
            data.map((s) {
              final statusStr = (s['status'] ?? 'PENDING') as String;
              final route = s['route'] as Map<String, dynamic>?;
              final origin = route?['origin'] as String? ?? 'Origin';
              final destination =
                  route?['destination'] as String? ??
                  s['destination'] as String? ??
                  'Destination';
              final distanceKm = (route?['distanceKm'] ?? 0).toDouble();

              // Parse estimatedArrival ISO string into a readable ETA string
              final arrivalRaw = s['estimatedArrival'] as String?;
              final eta = _formatEta(arrivalRaw);

              // Build route stops path string for display (e.g. "Kano → Kaduna → Lagos")
              final stops =
                  (route?['stops'] as List<dynamic>? ?? [])..sort(
                    (a, b) => (a['stopOrder'] as int).compareTo(
                      b['stopOrder'] as int,
                    ),
                  );
              final stopPath = stops
                  .map((st) => st['location'] as String)
                  .join(' → ');

              return Shipment(
                id: s['id'] as String,
                title: s['cargo'] as String? ?? 'Shipment',
                origin: origin,
                destination: destination,
                status: statusStr,
                weight: (s['weight'] ?? 0).toDouble(),
                weightUnit: s['weightUnit'] as String? ?? 'kg',
                estimatedEarnings: (s['price'] ?? 0).toDouble(),
                currency: '₦',
                departureTime: eta,
                distanceKm: distanceKm,
                shipmentStatus: _parseStatus(statusStr),
                stopPath: stopPath,
                riskLevel: route?['riskLevel'] as String? ?? 'low',
                fuelCost: (route?['fuelCost'] ?? 0).toDouble(),
                tollCost: (route?['tollCost'] ?? 0).toDouble(),
                farmerName: s['farmer']?['name'] as String? ?? '',
                shipmentCode: s['shipmentCode'] as String? ?? '',
              );
            }).toList();
      }
      int activeShipmentsCount = 0;
      int notificationsCount = 0;

      if (dashboardRes.statusCode == 200) {
        final dashboardData =
            (jsonDecode(dashboardRes.body) as Map<String, dynamic>)['data']
                as Map<String, dynamic>;
        final driverData =
            dashboardData['driver'] as Map<String, dynamic>? ?? {};
        name =
            driverData['name'] as String? ?? _box.read('name') ?? 'Transporter';
        notificationsCount = dashboardData['notifications_count'] as int? ?? 0;
      }
      if (loadRes.statusCode == 200) {
        final loadData =
            (jsonDecode(loadRes.body) as Map<String, dynamic>)['data']
                as Map<String, dynamic>? ??
            {};
        activeShipmentsCount = loadData['active_shipments'] as int? ?? 0;
      }
      transporter.value = Transporter(
        id: _box.read('userId') ?? '',
        name: name,
        vehicleType: 'Truck',
        vehiclePlate: '',
        stats: TransporterStats(
          totalDeliveries: completedShipments.length,
          totalEarnings: shipmentList.fold(
            0,
            (sum, s) => sum + s.estimatedEarnings,
          ),
          rating: 0,
          activeShipments: activeShipmentsCount,
          notificationsCount: notificationsCount,
        ),
        shipments: shipmentList,
      );

      // Load AI route recommendations after data is set
      await loadMockRoutes();
    } catch (e, stack) {
      errorMessage.value = 'Failed to load data. Please try again.';
      transporter.value = Transporter(
        id: _box.read('userId') ?? '',
        name: _box.read('name') ?? 'Transporter',
        vehicleType: 'Truck',
        vehiclePlate: '',
        stats: TransporterStats(
          totalDeliveries: 0,
          totalEarnings: 0,
          rating: 0,
          activeShipments: 0,
          notificationsCount: 0,
        ),
        shipments: [],
      );
    }

    isLoading.value = false;
  }

  Future<void> loadMockRoutes() async {
    isLoadingRoutes.value = true;
    final shipment = featuredShipment;
    final originCity = shipment?.origin ?? 'Kano';
    final destCity = shipment?.destination ?? 'Lagos';
    final distance = shipment?.distanceKm ?? 752;

    // Assign routes and mark load as complete
    routeRecommendations.assignAll([
      // Current/Active route
      RouteRecommendation(
        id: 'route-1',
        title: '$originCity - $destCity Route',
        originCity: originCity,
        destinationCity: destCity,
        distanceKm: distance,
        duration: '11 hrs 30 min',
        freshness: 70,
        trafficStatus: 'Heavy',
        realInfo: 800,
        status: 'Active',
        note:
            '45min Traffic Delay detected on your current route. Rerouting recommended to preserve tomato freshness and maintain optimal delivery temperature.',
        reasons: [
          const RouteReason(
            icon: '⚠️',
            title: 'Heavy Traffic',
            description:
                'Major highways experiencing congestion. Abuja toll gate backup.',
          ),
          const RouteReason(
            icon: '⏱️',
            title: '45min Delay Expected',
            description: 'Due to ongoing road work on Abuja-Ibadan highway.',
          ),
        ],
      ),
      // Alternative route 1
      RouteRecommendation(
        id: 'route-2',
        title: 'Alternative via Abuja',
        originCity: originCity,
        destinationCity: destCity,
        distanceKm: 780,
        duration: '10hrs 50min',
        freshness: 95,
        trafficStatus: 'Light',
        realInfo: 900,
        status: 'Suggested',
        note:
            'AI has analyzed real-time traffic conditions and identified a faster route that will help preserve your tomato freshness.',
        isAlternative: true,
        reasons: [
          const RouteReason(
            icon: '🌡️',
            title: 'Temperature Control',
            description:
                'Reduced oven-like heating from highway reflection. Optimal cargo preservation.',
          ),
          const RouteReason(
            icon: '⏰',
            title: 'Freshness Extended by 12 hours',
            description:
                'Smoother roads reduce cargo agitation and temperature fluctuations.',
          ),
          const RouteReason(
            icon: '⛽',
            title: 'Saves ₦2,500 Fuel',
            description:
                'Optimal route and highway positioning reduce fuel consumption.',
          ),
        ],
      ),
      // Alternative route 2
      RouteRecommendation(
        id: 'route-3',
        title: 'Northern Route via Zaria',
        originCity: originCity,
        destinationCity: destCity,
        distanceKm: 820,
        duration: '10hrs 15min',
        freshness: 85,
        trafficStatus: 'Moderate',
        realInfo: 850,
        status: 'Suggested',
        note:
            'Scenic rural roads with excellent infrastructure. Better for long-term cargo stability and consistent temperature.',
        isAlternative: true,
        reasons: [
          const RouteReason(
            icon: '🛣️',
            title: 'Better Road Quality',
            description:
                'Newly paved rural roads reduce wear and tear on cargo.',
          ),
          const RouteReason(
            icon: '📍',
            title: 'Multiple Rest Points',
            description: 'Safe stops at Zaria, Minna for quality checks.',
          ),
        ],
      ),
    ]);
    isLoadingRoutes.value = false;
    print(
      '[TransporterController] Route recommendations loaded: ${routeRecommendations.length} routes',
    );
  }

  String _formatEta(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');
      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');
      return '$day/$month/${dt.year} $hour:$minute';
    } catch (_) {
      return isoString;
    }
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

  ShipmentStatus _parseStatus(String status) {
    switch (status.toUpperCase()) {
      case 'IN_TRANSIT':
        return ShipmentStatus.inTransit;
      case 'DELIVERED':
        return ShipmentStatus.delivered;
      case 'CANCELLED':
        return ShipmentStatus.cancelled;
      default:
        return ShipmentStatus.pending;
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
              status: newStatus.name,
              weight: s.weight,
              weightUnit: s.weightUnit,
              estimatedEarnings: s.estimatedEarnings,
              currency: s.currency,
              departureTime: s.departureTime,
              distanceKm: s.distanceKm,
              shipmentStatus: newStatus,
              stopPath: s.stopPath,
              riskLevel: s.riskLevel,
              fuelCost: s.fuelCost,
              tollCost: s.tollCost,
              farmerName: s.farmerName,
              shipmentCode: s.shipmentCode,
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
}
