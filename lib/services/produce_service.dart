import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ProduceService {
  static const String _baseUrl = ApiConfig.baseUrl;

  Future<http.Response> getAllProduce(String token) {
    final uri = Uri.parse('$_baseUrl/api/produces');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getMyProduces(String token) {
    final uri = Uri.parse('$_baseUrl/api/produces/me');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getMarketplaceProduces(String token) {
    final uri = Uri.parse('$_baseUrl/api/produces/marketplace');
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

  Future<http.Response> editProduce({
    required String token,
    required String produceId,
    String? name,
    String? description,
    double? quantity,
    String? unit,
    double? pricePerUnit,
    double? freshnessScore,
    String? imageUrl,
    String? location,
    String? harvestDate,
    String? expiryDate,
  }) {
    final uri = Uri.parse('$_baseUrl/api/produces/$produceId');
    return http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (quantity != null) 'quantity': quantity,
        if (unit != null) 'unit': unit,
        if (pricePerUnit != null) 'pricePerUnit': pricePerUnit,
        if (freshnessScore != null) 'freshnessScore': freshnessScore,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (location != null) 'location': location,
        if (harvestDate != null) 'harvestDate': harvestDate,
        if (expiryDate != null) 'expiryDate': expiryDate,
      }),
    );
  }

  Future<http.Response> deleteProduce(String token, String produceId) {
    final uri = Uri.parse('$_baseUrl/api/produces/$produceId');
    return http.delete(uri, headers: {'Authorization': 'Bearer $token'});
  }
}
