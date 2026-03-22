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

  Future<http.Response> getProfile(String token) {
    final uri = Uri.parse('$_baseUrl/api/users/profile');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> updateProfile({
    required String token,
    String? name,
    String? location,
    String? phone,
  }) {
    final uri = Uri.parse('$_baseUrl/api/users/profile');
    return http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (name != null) 'name': name,
        if (location != null) 'location': location,
        if (phone != null) 'phone': phone,
      }),
    );
  }
}
