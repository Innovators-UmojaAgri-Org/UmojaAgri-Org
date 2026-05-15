import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class CartService {
  static const String _baseUrl = ApiConfig.baseUrl;

  Future<http.Response> getCart(String token) {
    final uri = Uri.parse('$_baseUrl/api/cart');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> addToCart({
    required String token,
    required String produceId,
    required double quantity,
  }) {
    final uri = Uri.parse('$_baseUrl/api/cart');
    return http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'produceId': produceId, 'quantity': quantity}),
    );
  }

  Future<http.Response> updateCartItem({
    required String token,
    required String produceId,
    required double quantity,
  }) {
    final uri = Uri.parse('$_baseUrl/api/cart/$produceId');
    return http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'quantity': quantity}),
    );
  }

  Future<http.Response> removeCartItem(String token, String produceId) {
    final uri = Uri.parse('$_baseUrl/api/cart/$produceId');
    return http.delete(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> clearCart(String token) {
    final uri = Uri.parse('$_baseUrl/api/cart/clear');
    return http.delete(uri, headers: {'Authorization': 'Bearer $token'});
  }
}
