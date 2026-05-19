import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:umoja_agri/services/finance_service.dart';
import 'package:umoja_agri/utils/app_snackbar.dart';

class WalletModel {
  final String id;
  final double balance;
  final String currency;
  final DateTime createdAt;

  WalletModel({
    required this.id,
    required this.balance,
    required this.currency,
    required this.createdAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'NGN',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class TransactionModel {
  final String id;
  final String type;
  final double amount;
  final String description;
  final String reference;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.reference,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      reference: json['reference'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class FinanceController extends GetxController {
  final wallet = Rxn<WalletModel>();
  final transactions = <TransactionModel>[].obs;
  final isLoading = false.obs;
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadWallet();
    loadTransactions();
  }

  Future<void> loadWallet() async {
    try {
      final token = _box.read('token') ?? '';
      final res = await FinanceService().getWallet(token);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'];
        wallet.value = WalletModel.fromJson(data);
      }
    } catch (e) {
      print('Error loading wallet: $e');
    }
  }

  Future<void> loadTransactions() async {
    isLoading.value = true;
    try {
      final token = _box.read('token') ?? '';
      final res = await FinanceService().getTransactions(token);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'] as List? ?? [];
        transactions.assignAll(data.map((t) => TransactionModel.fromJson(t)));
      }
    } catch (e) {
      print('Error loading transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fundWallet(double amount, String description) async {
    try {
      final token = _box.read('token') ?? '';
      final res = await FinanceService().fundWallet(
        token: token,
        amount: amount,
        description: description,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        await loadWallet();
        AppSnackbar.success('Wallet funded successfully');
      } else {
        AppSnackbar.error('Failed to fund wallet');
      }
    } catch (e) {
      AppSnackbar.error('Failed to fund wallet: $e');
    }
  }

  Future<void> makePayment(
    String recipientId,
    double amount,
    String description,
  ) async {
    try {
      final token = _box.read('token') ?? '';
      final res = await FinanceService().makePayment(
        token: token,
        recipientId: recipientId,
        amount: amount,
        description: description,
      );
      if (res.statusCode == 200) {
        await loadWallet();
        await loadTransactions();
        AppSnackbar.success('Payment made successfully');
      } else {
        AppSnackbar.error('Failed to make payment');
      }
    } catch (e) {
      AppSnackbar.error('Failed to make payment: $e');
    }
  }
}
