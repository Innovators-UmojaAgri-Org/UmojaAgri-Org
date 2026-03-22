import 'package:http/http.dart' as http;
import 'api_config.dart';

class DashboardService {
  static const String _baseUrl = ApiConfig.baseUrl;

  Future<http.Response> getDashboard(String token) {
    final uri = Uri.parse('$_baseUrl/api/dashboard');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }
}
