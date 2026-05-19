import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class AIService {
  static const String _baseUrl = ApiConfig.baseUrl;

  Future<http.Response> getRecommendations(String token) {
    final uri = Uri.parse('$_baseUrl/api/ai/recommendations');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getCargoRisks(String token) {
    final uri = Uri.parse('$_baseUrl/api/ai/risks');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getShipmentInsights(String token) {
    final uri = Uri.parse('$_baseUrl/api/ai/shipment-insights');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getSupplyInsights(String token) {
    final uri = Uri.parse('$_baseUrl/api/ai/supply-insights');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> createAIResult({
    required String token,
    required String type,
    required Map<String, dynamic> result,
    String? produceId,
    String? deliveryId,
  }) {
    final uri = Uri.parse('$_baseUrl/api/ai');
    return http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'type': type,
        'result': result,
        if (produceId != null) 'produceId': produceId,
        if (deliveryId != null) 'deliveryId': deliveryId,
      }),
    );
  }
}
