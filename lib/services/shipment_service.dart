import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ShipmentService {
  static const String _baseUrl = ApiConfig.baseUrl;

  // Get all shipments for farmer
  Future<http.Response> getShipments(String token) {
    final uri = Uri.parse('$_baseUrl/api/shipments');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  // Get shipment summary for farmer
  Future<http.Response> getShipmentSummary(String token) {
    final uri = Uri.parse('$_baseUrl/api/shipments/summary');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  // Create a new shipment
  Future<http.Response> createShipment({
    required String token,
    required String cargo,
    required double weight,
    String weightUnit = 'kg',
    required String destination,
    double? price,
  }) {
    final uri = Uri.parse('$_baseUrl/api/shipments');
    return http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'cargo': cargo,
        'weight': weight,
        'weightUnit': weightUnit,
        'destination': destination,
        if (price != null) 'price': price,
      }),
    );
  }

  // Get shipment by ID
  Future<http.Response> getShipmentById(String token, String shipmentId) {
    final uri = Uri.parse('$_baseUrl/api/shipments/$shipmentId');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  // Get recommended transporter for a shipment
  Future<http.Response> getRecommendedTransporter(
    String token,
    String shipmentId,
  ) {
    final uri = Uri.parse(
      '$_baseUrl/api/shipments/$shipmentId/recommendations',
    );
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  // Select transporter for shipment
  Future<http.Response> selectTransporter(
    String token,
    String shipmentId,
    String transporterId,
  ) {
    final uri = Uri.parse('$_baseUrl/api/shipments/select-transporter');
    return http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'shipmentId': shipmentId,
        'transporterId': transporterId,
      }),
    );
  }

  // Get available transporters
  Future<http.Response> getAvailableTransporters(String token) {
    final uri = Uri.parse('$_baseUrl/api/transporters');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }
}
