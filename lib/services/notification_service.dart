import 'package:http/http.dart' as http;
import 'api_config.dart';

class NotificationService {
  static const String _baseUrl = ApiConfig.baseUrl;

  Future<http.Response> getNotifications(String token) {
    final uri = Uri.parse('$_baseUrl/api/notifications');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> markAsRead(String token, String notificationId) {
    final uri = Uri.parse('$_baseUrl/api/notifications/$notificationId/read');
    return http.patch(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> markAllAsRead(String token) {
    final uri = Uri.parse('$_baseUrl/api/notifications/read-all');
    return http.patch(uri, headers: {'Authorization': 'Bearer $token'});
  }
}
