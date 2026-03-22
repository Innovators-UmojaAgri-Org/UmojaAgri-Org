import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class AlertService {
  static const String _baseUrl = ApiConfig.baseUrl;

  Future<http.Response> getAlerts(String token) {
    final uri = Uri.parse('$_baseUrl/api/alerts');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> createAlert({
    required String token,
    required String type,
    required String message,
    String? recommendation,
    required String severity,
    String? userId,
  }) {
    final uri = Uri.parse('$_baseUrl/api/alerts');
    return http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'type': type,
        'message': message,
        if (recommendation != null) 'recommendation': recommendation,
        'severity': severity,
        if (userId != null) 'userId': userId,
      }),
    );
  }
}
