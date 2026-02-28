import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl =
      'https://umojaagri-org.onrender.com'; // <- change to http://localhost:5000 for dev

  Future<http.Response> register({
    required String email,
    required String password,
    required String name,
    required String roleId,
  }) {
    final uri = Uri.parse('$_baseUrl/api/users/register');
    return http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'roleId': roleId,
      }),
    );
  }

  Future<http.Response> login({
    required String email,
    required String password,
  }) {
    final uri = Uri.parse('$_baseUrl/api/users/login');
    return http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }
}
