import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:umoja_agri/models/marketer/marketer_model.dart';
import 'package:umoja_agri/services/dashboard_service.dart';
import 'package:umoja_agri/services/order_service.dart';
import 'package:umoja_agri/services/produce_service.dart';
import 'package:umoja_agri/services/delivery_service.dart';
import 'package:umoja_agri/services/cart_service.dart';
import 'package:umoja_agri/utils/app_snackbar.dart';

class MarketerController extends GetxController {
  final currentIndex = 0.obs;
  void setIndex(int index) => currentIndex.value = index;

  final sellerName = ''.obs;
  final market = 'Mile 12 Market'.obs;
  final orders = <Order>[].obs;
  final farmProduce = <FarmProduce>[].obs;
  final deliveries = <Delivery>[].obs;
  final alerts = <Alert>[].obs;
  final cartItems = <CartItem>[].obs;
  final transactions = <FinanceTransaction>[].obs;
  final selectedStatusFilter = Rxn<OrderStatus>();
  final isLoading = true.obs;
  final _box = GetStorage();
  late Future<void> _initializationFuture;

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
      final dashboardRes = await DashboardService().getDashboard(token);
      final ordersRes = await OrderService().getSellerOrders(token);
      final produceRes = await ProduceService().getMarketplaceProduces(token);

      final deliveriesRes = await DeliveryService().getIncomingDeliveries(
        token,
      );
      if (dashboardRes.statusCode == 200) {
        final dashboardJson = jsonDecode(dashboardRes.body);
        final data = dashboardJson['data'];
        sellerName.value =
            data['user']['name'] ?? _box.read('name') ?? 'Marketer';
        // Load alerts from dashboard response
        if (data['alerts'] != null) {
          alerts.assignAll(
            (data['alerts'] as List).map(
              (a) => Alert(
                id: a['id'] ?? '',
                type: a['type'] ?? '',
                message: a['message'] ?? '',
                recommendation: a['recommendation'] ?? '',
                severity: a['severity'] ?? 'low',
              ),
            ),
          );
        
        }
      } else {
  
      }

      if (ordersRes.statusCode == 200) {
        final data = jsonDecode(ordersRes.body)['data'] as List;
        orders.assignAll(
          data.map(
            (o) => Order(
              id: o['id'],
              productName: o['produce']?['name'] ?? '',
              farmName: o['farmer']?['name'] ?? '',
              quantity: (o['quantity'] ?? 0).toDouble(),
              unit: o['unit'] ?? 'kg',
              amount: (o['amount'] ?? 0).toDouble(),
              date: DateTime.tryParse(o['createdAt'] ?? '') ?? DateTime.now(),
              status: _parseStatus(o['status']),
            ),
          ),
        );
      } else {
      
      }

      if (produceRes.statusCode == 200) {
        final data = jsonDecode(produceRes.body)['data'] as List;
        farmProduce.assignAll(
          data.map(
            (p) => FarmProduce(
              id: p['id'] ?? '',
              name: p['name'] ?? '',
              farm: p['owner']?['name'] ?? '',
              description: p['description'] ?? '',
              quantity: (p['quantity'] ?? 0).toDouble(),
              unit: p['unit'] ?? 'kg',
              pricePerKg: (p['pricePerUnit'] ?? 0).toDouble(),
              freshness: p['freshnessScore'] ?? 90,
              imageUrl: p['imageUrl'],
              location: p['location'] ?? '',
            ),
          ),
        );
      } else {
      }

      if (deliveriesRes.statusCode == 200) {
        final data = jsonDecode(deliveriesRes.body)['data'] as List;
        print('✓ Deliveries loaded: ${data.length} deliveries found');
        deliveries.assignAll(
          data.map(
            (d) => Delivery(
              id: d['id'] ?? '',
              product: d['produce']?['name'] ?? '',
              quantity: (d['order']?['quantity'] ?? 0).toDouble(),
              unit: d['order']?['unit'] ?? 'kg',
              from: d['origin'] ?? '',
              to: d['destination'] ?? '',
              shipmentId: d['id'] ?? '',
              progressPercent: d['progressPercent'] ?? 0,
              eta: d['etaMinutes'] != null ? '${d['etaMinutes']} min' : 'N/A',
              status: d['status'] ?? 'PENDING',
              currentLocation: d['currentLocation'] ?? '',
              transporterName: d['transport']?['transporter']?['name'],
            ),
          ),
        );
      } else {
      }
    } catch (e, stackTrace) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCart() async {
    try {
      final token = _box.read('token') ?? '';
      final res = await CartService().getCart(token);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'] as List;
        cartItems.assignAll(
          data.map(
            (item) => CartItem(
              id: item['id'],
              produce: FarmProduce(
                id: item['produce']['id'] ?? '',
                name: item['produce']['name'] ?? '',
                farm: item['produce']['owner']['name'] ?? '',
                description: item['produce']['description'] ?? '',
                quantity: (item['produce']['quantity'] ?? 0).toDouble(),
                unit: item['produce']['unit'] ?? 'kg',
                pricePerKg: (item['produce']['pricePerUnit'] ?? 0).toDouble(),
                freshness: item['produce']['freshnessScore'] ?? 90,
                location: item['produce']['location'] ?? '',
                
              ),
              quantity: (item['quantity'] ?? 0).toDouble(),
            ),
          ),
        );
      } else {
        // print('Cart API returned status: ${res.statusCode}');
      }
    } catch (e, stackTrace) {
    
    }
  }

  Future<void> addToCart(String produceId, double quantity) async {
    try {
      final token = _box.read('token') ?? '';
      final res = await CartService().addToCart(
        token: token,
        produceId: produceId,
        quantity: quantity,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        await loadCart();
        AppSnackbar.success('Added to cart');
      } else {
        AppSnackbar.error('Failed to add to cart');
      }
    } catch (e) {
      AppSnackbar.error('Failed to add to cart: $e');
    }
  }

  Future<void> updateCartItem(String produceId, double quantity) async {
    try {
      final token = _box.read('token') ?? '';
      final res = await CartService().updateCartItem(
        token: token,
        produceId: produceId,
        quantity: quantity,
      );
      if (res.statusCode == 200) {
        await loadCart();
      } else {
        AppSnackbar.error('Failed to update cart');
      }
    } catch (e) {
      AppSnackbar.error('Failed to update cart: $e');
    }
  }

  Future<void> removeFromCart(String produceId) async {
    try {
      final token = _box.read('token') ?? '';
      final res = await CartService().removeCartItem(token, produceId);
      if (res.statusCode == 200) {
        await loadCart();
        AppSnackbar.success('Removed from cart');
      } else {
        AppSnackbar.error('Failed to remove from cart');
      }
    } catch (e) {
      AppSnackbar.error('Failed to remove from cart: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      final token = _box.read('token') ?? '';
      final res = await CartService().clearCart(token);
      if (res.statusCode == 200) {
        cartItems.clear();
        AppSnackbar.success('Cart cleared');
      } else {
        AppSnackbar.error('Failed to clear cart');
      }
    } catch (e) {
      AppSnackbar.error('Failed to clear cart: $e');
    }
  }

  Future<void> placeOrder(
    String produceId,
    double quantity,
    String? unit,
  ) async {
    try {
      final token = _box.read('token') ?? '';

      final res = await OrderService().createOrder(
        token: token,
        produceId: produceId,
        quantity: quantity,
        unit: unit,
      );
     
      if (res.statusCode == 200 || res.statusCode == 201) {
        await _loadData(); // Refresh orders
        AppSnackbar.success('Order placed successfully');
       
      } else {
        AppSnackbar.error('Failed to place order');
      }
    } catch (e, stackTrace) {
      AppSnackbar.error('Failed to place order: $e');
    }
  }

  OrderStatus _parseStatus(String? status) {
    switch (status) {
      case 'CONFIRMED':
        return OrderStatus.confirmed;
      case 'IN_TRANSIT':
        return OrderStatus.inTransit;
      case 'DELIVERED':
        return OrderStatus.delivered;
      case 'CANCELLED':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}
