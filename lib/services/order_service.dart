import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class OrderService {
  static const String _baseUrl = ApiConfig.baseUrl;

  Future<http.Response> createOrder({
    required String token,
    required String produceId,
    required String sellerId,
    required String farmerId,
    required double quantity,
    required String unit,
  }) {
    final uri = Uri.parse('$_baseUrl/api/orders');
    return http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'produceId': produceId,
        'sellerId': sellerId,
        'farmerId': farmerId,
        'quantity': quantity,
        'unit': unit,
      }),
    );
  }

  Future<http.Response> getOrders(String token) {
    final uri = Uri.parse('$_baseUrl/api/orders');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> updateOrderStatus({
    required String token,
    required String orderId,
    required String status,
  }) {
    final uri = Uri.parse('$_baseUrl/api/orders/$orderId/status');
    return http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status}),
    );
  }
}
