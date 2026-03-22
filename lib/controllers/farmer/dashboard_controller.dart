import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:umoja_agri/models/farmer/dashboard_model.dart';
import 'package:umoja_agri/services/dashboard_service.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;
  var hasError = false.obs;
  var dashboardData = Rxn<DashboardStatsModel>();
  final _box = GetStorage();
  late Future<void> _initializationFuture;

  @override
  void onInit() {
    super.onInit();
    _initializationFuture = fetchDashboardData();
  }

  Future<void> ensureInitialized() async {
    await _initializationFuture;
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading(true);
      hasError(false);
      final token = _box.read('token') ?? '';

      final dashboardRes = await DashboardService().getDashboard(token);

      if (dashboardRes.statusCode == 200) {
        print('Dashboard API response: ${dashboardRes.body}');
        final dashboardJson = jsonDecode(dashboardRes.body);
        final data = dashboardJson['data'];

        if (data != null && data is Map<String, dynamic>) {
          dashboardData.value = DashboardStatsModel.fromJson(data);
        } else {
          // If API returns a different shape, use safe defaults.
          dashboardData.value = DashboardStatsModel(
            farmerName: _box.read('name') ?? 'Farmer',
            monthlyRevenue: 0.0,
            notificationsCount: 0,
            yieldTrends: [],
            recentShipments: [],
          );
        }
      } else {
        
        // print(
        //   'Dashboard API error: ${dashboardRes.statusCode} ${dashboardRes.body}',
        // );
        dashboardData.value = DashboardStatsModel(
          farmerName: _box.read('name') ?? 'Farmer',
          monthlyRevenue: 0.0,
          notificationsCount: 0,
          yieldTrends: [],
          recentShipments: [],
        );
      }
    } catch (e, st) {
      print('Dashboard fetch failed: $e\n$st');
      dashboardData.value = DashboardStatsModel(
        farmerName: _box.read('name') ?? 'Farmer',
        monthlyRevenue: 0.0,
        notificationsCount: 0,
        yieldTrends: [],
        recentShipments: [],
      );
    } finally {
      isLoading(false);
    }
  }

  void refreshDashboard() => fetchDashboardData();
}
