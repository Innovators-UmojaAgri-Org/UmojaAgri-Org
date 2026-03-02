import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class DeliveryService {
  static const String _baseUrl = ApiConfig.baseUrl;

  Future<http.Response> getDeliveries(String token) {
    final uri = Uri.parse('$_baseUrl/api/deliveries');
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
