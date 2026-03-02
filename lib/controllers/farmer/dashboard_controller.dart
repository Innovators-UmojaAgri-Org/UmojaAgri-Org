import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:umoja_agri/models/farmer/dashboard_model.dart';
import 'package:umoja_agri/services/produce_service.dart';
import 'package:umoja_agri/services/order_service.dart';

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

      final produceRes = await ProduceService().getAllProduce(token);
      final ordersRes = await OrderService().getOrders(token);

      if (produceRes.statusCode == 200 && ordersRes.statusCode == 200) {
        final produces = jsonDecode(produceRes.body) as List;
        final orders = jsonDecode(ordersRes.body) as List;
        final newOrders = orders.where((o) => o['status'] == 'PENDING').length;

        dashboardData.value = DashboardStatsModel.fromJson({
          "farmerName": _box.read('name') ?? 'Farmer',
          "monthlyRevenue": 0.0,
          "newOrders": newOrders,
          "totalCrops": produces.length,
          "weeklyYield": [],
        });
      } else {
        hasError(true);
      }
    } catch (e) {
      hasError(true);
    } finally {
      isLoading(false);
    }
  }

  void refreshDashboard() => fetchDashboardData();
}