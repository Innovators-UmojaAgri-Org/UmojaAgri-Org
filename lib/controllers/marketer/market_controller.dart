import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:umoja_agri/models/marketer/marketer_model.dart';
import 'package:umoja_agri/services/order_service.dart';
import 'package:umoja_agri/services/produce_service.dart';
import 'package:umoja_agri/services/delivery_service.dart';

class MarketerController extends GetxController {
  final currentIndex = 0.obs;
  void setIndex(int index) => currentIndex.value = index;

  final sellerName = ''.obs;
  final market = 'Mile 12 Market'.obs;
  final orders = <Order>[].obs;
  final farmProduce = <FarmProduce>[].obs;
  final deliveries = <Delivery>[].obs;
  final transactions = <FinanceTransaction>[].obs;
  final selectedStatusFilter = Rxn<OrderStatus>();
  final isLoading = true.obs;
  final _box = GetStorage();
  late Future<void> _initializationFuture;

  double get totalOrderValue => orders.fold(0.0, (s, o) => s + o.amount);
  int get activeOrderCount => orders.where((o) =>
    o.status == OrderStatus.pending ||
    o.status == OrderStatus.confirmed ||
    o.status == OrderStatus.inTransit).length;
  double get totalRevenue => transactions.where((t) => t.isCredit)
      .fold(0.0, (s, t) => s + t.amount);
  double get totalSpend => transactions.where((t) => !t.isCredit)
      .fold(0.0, (s, t) => s + t.amount);
  double get accountBalance => totalRevenue - totalSpend;

  List<Order> get filteredOrders => selectedStatusFilter.value == null
      ? orders.toList()
      : orders.where((o) => o.status == selectedStatusFilter.value).toList();

  void filterByStatus(OrderStatus? status) =>
      selectedStatusFilter.value = status;

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final idx = orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;
    final o = orders[idx];
    orders[idx] = Order(
      id: o.id,
      productName: o.productName,
      farmName: o.farmName,
      quantity: o.quantity,
      unit: o.unit,
      amount: o.amount,
      date: o.date,
      status: newStatus,
    );
  }

  Future<void> ensureInitialized() async => await _initializationFuture;

  @override
  void onInit() {
    super.onInit();
    sellerName.value = _box.read('name') ?? 'Marketer';
    _initializationFuture = _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      final token = _box.read('token') ?? '';

      final ordersRes = await OrderService().getOrders(token);
      final produceRes = await ProduceService().getAllProduce(token);
      final deliveriesRes = await DeliveryService().getDeliveries(token);

      if (ordersRes.statusCode == 200) {
        final data = jsonDecode(ordersRes.body) as List;
        orders.assignAll(data.map((o) => Order(
          id: o['id'],
          productName: o['produce']?['name'] ?? '',
          farmName: o['farmer']?['name'] ?? '',
          quantity: (o['quantity'] ?? 0).toDouble(),
          unit: o['unit'] ?? 'kg',
          amount: 0.0,
          date: DateTime.tryParse(o['createdAt'] ?? '') ?? DateTime.now(),
          status: _parseStatus(o['status']),
        )));
      }

      if (produceRes.statusCode == 200) {
        final data = jsonDecode(produceRes.body) as List;
        farmProduce.assignAll(data.map((p) => FarmProduce(
          name: p['name'] ?? '',
          farm: p['owner']?['name'] ?? '',
          quantity: (p['quantity'] ?? 0).toDouble(),
          unit: p['unit'] ?? 'kg',
          pricePerKg: 0,
          freshness: 90,
          imageEmoji: '🌿',
        )));
      }

      if (deliveriesRes.statusCode == 200) {
        final data = jsonDecode(deliveriesRes.body) as List;
        deliveries.assignAll(data.map((d) => Delivery(
          product: d['produce']?['name'] ?? '',
          quantity: (d['produce']?['quantity'] ?? 0).toDouble(),
          unit: d['produce']?['unit'] ?? 'kg',
          from: 'Farm',
          shipmentId: d['id'],
          progressPercent: d['status'] == 'IN_TRANSIT' ? 50 : 0,
          eta: '',
        )));
      }
    } finally {
      isLoading.value = false;
    }
  }

  OrderStatus _parseStatus(String? status) {
    switch (status) {
      case 'CONFIRMED': return OrderStatus.confirmed;
      case 'IN_TRANSIT': return OrderStatus.inTransit;
      case 'DELIVERED': return OrderStatus.delivered;
      case 'CANCELLED': return OrderStatus.cancelled;
      default: return OrderStatus.pending;
    }
  }
}