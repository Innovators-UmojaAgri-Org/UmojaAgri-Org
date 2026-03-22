import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class TransportService {
  static const String _baseUrl = ApiConfig.baseUrl;

  Future<http.Response> getDriverProfile(String token) {
    final uri = Uri.parse('$_baseUrl/api/driver/profile');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getTransportAssignments(String token) {
    final uri = Uri.parse('$_baseUrl/api/transport');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getTransportAssignment(
    String token,
    String deliveryId,
  ) {
    final uri = Uri.parse('$_baseUrl/api/transport/$deliveryId');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getDriverShipments(String token) {
    final uri = Uri.parse('$_baseUrl/api/driver/shipments');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getDriverLoad(String token) {
    final uri = Uri.parse('$_baseUrl/api/driver/load');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getDriverPerformance(String token) {
    final uri = Uri.parse('$_baseUrl/api/driver/performance');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> updateDriverSettings({
    required String token,
    required bool dynamicRouting,
  }) {
    final uri = Uri.parse('$_baseUrl/api/driver/settings');
    return http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'dynamicRouting': dynamicRouting}),
    );
  }

  Future<http.Response> assignTransport({
    required String token,
    required String deliveryId,
    required String transporterId,
    required String vehicleId,
  }) {
    final uri = Uri.parse('$_baseUrl/api/transport/assign');
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
