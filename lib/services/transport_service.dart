import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class TransportService {
  static const String _baseUrl = ApiConfig.baseUrl;

  Future<http.Response> getTransportAssignments(String token) {
    final uri = Uri.parse('$_baseUrl/api/transport');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> assignTransport({
    required String token,
    required String deliveryId,
    required String transporterId,
    required String vehicleId,
  }) {
    final uri = Uri.parse('$_baseUrl/api/transport');
    return http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'deliveryId': deliveryId,
        'transporterId': transporterId,
        'vehicleId': vehicleId,
      }),
    );
  }
}
