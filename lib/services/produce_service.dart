import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ProduceService {
  static const String _baseUrl = ApiConfig.baseUrl;

  Future<http.Response> getAllProduce(String token) {
    final uri = Uri.parse('$_baseUrl/api/produces');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> createProduce({
    required String token,
    required String name,
    required double quantity,
    required String unit,
    String? harvestDate,
    String? expiryDate,
  }) {
    final uri = Uri.parse('$_baseUrl/api/produces');
    return http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'quantity': quantity,
        'unit': unit,
        if (harvestDate != null) 'harvestDate': harvestDate,
        if (expiryDate != null) 'expiryDate': expiryDate,
      }),
    );
  }
}
