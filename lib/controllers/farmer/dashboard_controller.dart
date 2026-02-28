import 'package:get/get.dart';
import '../../models/farmer/dashboard_model.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;
  var hasError = false.obs;
  var dashboardData = Rxn<DashboardStatsModel>();
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

      // Simulate API delay 
      await Future.delayed(const Duration(milliseconds: 800));

      /// Mock backend JSON response
      final mockJson = {
        "farmerName": "Shola Adebayo",
        "monthlyRevenue": 280836.00,
        "newOrders": 12,
        "totalCrops": 8,
        "weeklyYield": [
          {"day": "Mon", "value": 16},
          {"day": "Tue", "value": 22},
          {"day": "Wed", "value": 27},
          {"day": "Thu", "value": 45},
          {"day": "Fri", "value": 33},
        ],
      };

      dashboardData.value = DashboardStatsModel.fromJson(mockJson);
    } catch (e) {
      hasError(true);
    } finally {
      isLoading(false);
    }
  }

  void refreshDashboard() {
    fetchDashboardData();
  }
}
