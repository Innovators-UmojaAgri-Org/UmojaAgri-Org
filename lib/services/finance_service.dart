import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class FinanceService {
  static const String _baseUrl = ApiConfig.baseUrl;

  Future<http.Response> getWallet(String token) {
    final uri = Uri.parse('$_baseUrl/api/finance/wallet');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getTransactions(String token) {
    final uri = Uri.parse('$_baseUrl/api/finance/transactions');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> fundWallet({
    required String token,
    required double amount,
    String? description,
  }) {
    final uri = Uri.parse('$_baseUrl/api/finance/fund');
    return http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'amount': amount,
        if (description != null) 'description': description,
      }),
    );
  }

  Future<http.Response> makePayment({
    required String token,
    required String recipientId,
    required double amount,
    String? description,
  }) {
    final uri = Uri.parse('$_baseUrl/api/finance/pay');
    return http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'recipientId': recipientId,
        'amount': amount,
        if (description != null) 'description': description,
      }),
    );
  }
}
