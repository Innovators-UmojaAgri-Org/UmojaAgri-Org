import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:umoja_agri/services/auth_service.dart';
import 'package:umoja_agri/utils/constants.dart';
import 'package:umoja_agri/utils/app_routes.dart';
import 'package:umoja_agri/controllers/farmer/dashboard_controller.dart';
import 'package:umoja_agri/controllers/transporter/transporter_controller.dart';
import 'package:umoja_agri/controllers/marketer/market_controller.dart';

class AuthController extends GetxController {
  final AuthService _service = AuthService();
  final _box = GetStorage();

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final selectedRole = RoleIds.farmer.obs;
  final isLoading = false.obs;
  final token = ''.obs;

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    nameCtrl.dispose();
    super.onClose();
  }

  Future<void> register() async {
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    final name = nameCtrl.text.trim();
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }
    isLoading.value = true;
    try {
      final res = await _service.register(
        email: email,
        password: password,
        name: name,
        roleId: selectedRole.value,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        emailCtrl.clear();
        passwordCtrl.clear();
        nameCtrl.clear();
        Get.snackbar('Success', 'Account created, please sign in');
        Get.offAllNamed(AppRoutes.sign_in);
      } else {
        final body = jsonDecode(res.body);
        Get.snackbar('Registration failed', body['message'] ?? res.reasonPhrase);
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not register. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email and password required');
      return;
    }
    isLoading.value = true;
    try {
      final res = await _service.login(email: email, password: password);
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final userToken = body['token'] ?? '';
        final roleId = body['user']?['roleId'] ?? selectedRole.value;
        final userName = body['user']?['name'] ?? '';

        token.value = userToken;
        _box.write('token', userToken);
        _box.write('roleId', roleId);
        _box.write('name', userName);
        _box.write('userId', body['user']?['id'] ?? '');

        if (roleId == RoleIds.farmer) {
          final dash = Get.put(DashboardController());
          await dash.ensureInitialized();
          Get.offAllNamed(AppRoutes.dashboard);
        } else if (roleId == RoleIds.transporter) {
          Get.put(TransporterController());
          Get.offAllNamed(AppRoutes.transporter);
        } else if (roleId == RoleIds.marketer) {
          final market = Get.put(MarketerController());
          await market.ensureInitialized();
          Get.offAllNamed(AppRoutes.home_marketer);
        } else {
          Get.offAllNamed(AppRoutes.home);
        }
      } else {
        final body = jsonDecode(res.body);
        Get.snackbar('Login failed', body['message'] ?? res.reasonPhrase);
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not login. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    _box.erase();
    token.value = '';
    Get.offAllNamed(AppRoutes.sign_in);
  }

  String get savedToken => _box.read('token') ?? '';
}