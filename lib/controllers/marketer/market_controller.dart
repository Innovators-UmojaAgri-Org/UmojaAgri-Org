// lib/controllers/app_controller.dart
import 'package:get/get.dart';
import '../../models/marketer/marketer_model.dart';

class MarketerController extends GetxController {
  // ── Navigation
  final currentIndex = 0.obs;
  void setIndex(int index) => currentIndex.value = index;

  // ── Seller Info 
  final sellerName = 'Chioma'.obs;
  final market = 'Mile 12 Market'.obs;

  // ── Observable Lists
  final orders = <Order>[].obs;
  final farmProduce = <FarmProduce>[].obs;
  final deliveries = <Delivery>[].obs;
  final transactions = <FinanceTransaction>[].obs;

  // ── Observable UI State 
  final selectedStatusFilter = Rxn<OrderStatus>();
  final isLoading = true.obs;
  late Future<void> _initializationFuture;

  // ── Computed Getters
  double get totalOrderValue => orders.fold(0.0, (s, o) => s + o.amount);

  int get activeOrderCount =>
      orders
          .where(
            (o) =>
                o.status == OrderStatus.pending ||
                o.status == OrderStatus.confirmed ||
                o.status == OrderStatus.inTransit,
          )
          .length;

  double get totalRevenue =>
      transactions.where((t) => t.isCredit).fold(0.0, (s, t) => s + t.amount);

  double get totalSpend =>
      transactions.where((t) => !t.isCredit).fold(0.0, (s, t) => s + t.amount);

  double get accountBalance => totalRevenue - totalSpend;

  List<Order> get filteredOrders =>
      selectedStatusFilter.value == null
          ? orders.toList()
          : orders
              .where((o) => o.status == selectedStatusFilter.value)
              .toList();

  // ── Actions 
  void filterByStatus(OrderStatus? status) =>
      selectedStatusFilter.value = status;

  void addOrder(Order order) => orders.add(order);

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

  // ── Initialization 
  Future<void> ensureInitialized() async {
    await _initializationFuture;
  }

  // ── Lifecycle 
  @override
  void onInit() {
    super.onInit();
    _initializationFuture = _loadMockData();
  }

  Future<void> _loadMockData() async {
    try {
      isLoading.value = true;

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));

      orders.assignAll([
        Order(
          id: 'ORD-2024-001',
          productName: 'Fresh Tomatoes',
          farmName: 'Swanta Farm',
          quantity: 150,
          unit: 'kg',
          amount: 540000,
          date: DateTime(2026, 2, 18),
          status: OrderStatus.pending,
        ),
        Order(
          id: 'ORD-2024-002',
          productName: 'Okra',
          farmName: 'Paniel Farms',
          quantity: 80,
          unit: 'kg',
          amount: 160000,
          date: DateTime(2026, 2, 17),
          status: OrderStatus.confirmed,
        ),
        Order(
          id: 'ORD-2024-003',
          productName: 'Sweet Corn',
          farmName: 'Biba Farms',
          quantity: 40,
          unit: 'kg',
          amount: 80000,
          date: DateTime(2026, 2, 18),
          status: OrderStatus.confirmed,
        ),
        Order(
          id: 'ORD-2024-004',
          productName: 'Onions',
          farmName: 'Suka Agro',
          quantity: 100,
          unit: 'kg',
          amount: 120000,
          date: DateTime(2026, 2, 18),
          status: OrderStatus.inTransit,
        ),
        Order(
          id: 'ORD-2024-005',
          productName: 'Sweet Corn',
          farmName: 'Victoria Island Stores',
          quantity: 100,
          unit: 'kg',
          amount: 80000,
          date: DateTime(2026, 2, 18),
          status: OrderStatus.inTransit,
        ),
      ]);

      farmProduce.assignAll([
        FarmProduce(
          name: 'Tomatoes',
          farm: 'Swanta Farm',
          quantity: 320,
          unit: 'kg',
          pricePerKg: 1200,
          freshness: 92,
          imageEmoji: '🍅',
        ),
        FarmProduce(
          name: 'Sweet Corn',
          farm: 'Paniel Farm',
          quantity: 320,
          unit: 'kg',
          pricePerKg: 1200,
          freshness: 92,
          imageEmoji: '🌽',
        ),
        FarmProduce(
          name: 'Okra',
          farm: 'Paniel Farm',
          quantity: 200,
          unit: 'kg',
          pricePerKg: 900,
          freshness: 88,
          imageEmoji: '🥬',
        ),
        FarmProduce(
          name: 'Palm Oil',
          farm: 'Biba Farms',
          quantity: 100,
          unit: 'L',
          pricePerKg: 2500,
          freshness: 95,
          imageEmoji: '🫙',
        ),
      ]);

      deliveries.assignAll([
        Delivery(
          product: '2 Tons of Tomatoes',
          quantity: 2,
          unit: 'Tons',
          from: 'Kaduna',
          shipmentId: 'TOM-3847',
          progressPercent: 65,
          eta: '2h 15m',
        ),
      ]);

      transactions.assignAll([
        FinanceTransaction(
          description: 'Fresh Tomatoes - Swanta Farm',
          orderId: 'ORD-2024-001',
          amount: 540000,
          date: DateTime(2026, 2, 18),
          isCredit: false,
        ),
        FinanceTransaction(
          description: 'Okra - Paniel Farms',
          orderId: 'ORD-2024-002',
          amount: 160000,
          date: DateTime(2026, 2, 17),
          isCredit: false,
        ),
        FinanceTransaction(
          description: 'Sweet Corn - Biba Farms',
          orderId: 'ORD-2024-003',
          amount: 80000,
          date: DateTime(2026, 2, 18),
          isCredit: false,
        ),
        FinanceTransaction(
          description: 'Sales Revenue - Tomatoes',
          orderId: 'SALE-001',
          amount: 750000,
          date: DateTime(2026, 2, 15),
          isCredit: true,
        ),
        FinanceTransaction(
          description: 'Sales Revenue - Corn',
          orderId: 'SALE-002',
          amount: 320000,
          date: DateTime(2026, 2, 14),
          isCredit: true,
        ),
      ]);
    } finally {
      isLoading.value = false;
    }
  }
}
