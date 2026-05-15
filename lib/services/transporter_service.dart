import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class TransporterService {
  static const String _baseUrl = ApiConfig.baseUrl;

  Future<http.Response> getTransporters(String token) {
    final uri = Uri.parse('$_baseUrl/api/transporters');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getTransporterById(String token, String transporterId) {
    final uri = Uri.parse('$_baseUrl/api/transporters/$transporterId');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> createTransporterProfile({
    required String token,
    required String companyName,
    double? pricePerKm,
    String? vehicleType,
    double? estimatedDeliveryHours,
  }) {
    final uri = Uri.parse('$_baseUrl/api/transporters/profile');
    return http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'companyName': companyName,
        if (pricePerKm != null) 'pricePerKm': pricePerKm,
        if (vehicleType != null) 'vehicleType': vehicleType,
        if (estimatedDeliveryHours != null)
          'estimatedDeliveryHours': estimatedDeliveryHours,
      }),
    );
  }
}
