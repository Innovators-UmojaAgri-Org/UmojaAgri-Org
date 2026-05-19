import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class DeliveryService {
  static const String _baseUrl = ApiConfig.baseUrl;

  Future<http.Response> createDelivery({
    required String token,
    required String produceId,
    required String sellerId,
    required double quantity,
    required String storageId,
  }) {
    final uri = Uri.parse('$_baseUrl/api/deliveries');
    return http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'produceId': produceId,
        'sellerId': sellerId,
        'quantity': quantity,
        'storageId': storageId,
      }),
    );
  }

  Future<http.Response> getDeliveries(String token) {
    final uri = Uri.parse('$_baseUrl/api/deliveries');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getDeliveryById(String token, String deliveryId) {
    final uri = Uri.parse('$_baseUrl/api/deliveries/$deliveryId');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getIncomingDeliveries(String token) {
    final uri = Uri.parse('$_baseUrl/api/deliveries/incoming');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> updateDeliveryStatus({
    required String token,
    required String deliveryId,
    required String status,
    required String location,
  }) {
    final uri = Uri.parse('$_baseUrl/api/deliveries/$deliveryId/status');
    return http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status, 'location': location}),
    );
  }
}
