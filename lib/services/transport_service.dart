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

  Future<http.Response> getMyJobs(String token) {
    final uri = Uri.parse('$_baseUrl/api/shipments/my-jobs');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> acceptJob(String token, String shipmentId) {
    final uri = Uri.parse('$_baseUrl/api/shipments/$shipmentId/accept');
    return http.patch(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> declineJob(String token, String shipmentId) {
    final uri = Uri.parse('$_baseUrl/api/shipments/$shipmentId/decline');
    return http.patch(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> updateJobStatus(String token, String shipmentId, String status) {
    final uri = Uri.parse('$_baseUrl/api/shipments/$shipmentId/status');
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
