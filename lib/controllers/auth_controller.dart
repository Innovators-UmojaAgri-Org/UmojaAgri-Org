import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:umoja_agri/services/auth_service.dart';
import 'package:umoja_agri/utils/constants.dart';
import 'package:umoja_agri/utils/app_routes.dart';
import 'package:umoja_agri/utils/app_snackbar.dart';
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
    // Removed dispose calls to prevent "used after being disposed" error
    // since controllers are used across login/signup screens
    super.onClose();
  }

  Future<void> register() async {
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    final name = nameCtrl.text.trim();
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      AppSnackbar.error('All fields are required');
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
        AppSnackbar.success('Account created, please sign in');
        Get.offAllNamed(AppRoutes.sign_in);
      } else {
        final body = jsonDecode(res.body);
        AppSnackbar.error(body['message'] ?? res.reasonPhrase, title: 'Registration failed');
      }
    } catch (e) {
      AppSnackbar.error('Could not register. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    if (email.isEmpty || password.isEmpty) {
      AppSnackbar.error('Email and password required');
      return;
    }
    isLoading.value = true;
    try {
      final res = await _service.login(email: email, password: password);
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final userToken = body['token'] ?? '';

        // Fetch user profile to get role
        final profileRes = await _service.getProfile(userToken);
        String roleId = RoleIds.farmer; // default
        String userName = '';
        String userId = '';
        if (profileRes.statusCode == 200) {
          final profileBody = jsonDecode(profileRes.body);
          final userData = profileBody['data'];
          roleId = userData['role']['name'] ?? RoleIds.farmer;
          userName = userData['name'] ?? '';
          userId = userData['id'] ?? '';
        }

        token.value = userToken;
        _box.write('token', userToken);
        _box.write('roleId', roleId);
        _box.write('name', userName);
        _box.write('userId', userId);

        // Clear login fields after successful login
        emailCtrl.clear();
        passwordCtrl.clear();

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
          Get.offAllNamed(AppRoutes.home); // fallback
        }
      } else {
        final body = jsonDecode(res.body);
        AppSnackbar.error(body['message'] ?? res.reasonPhrase, title: 'Login failed');
      }
    } catch (e) {
      AppSnackbar.error('Could not login. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    _box.erase();
    token.value = '';
    // Clear fields on logout
    emailCtrl.clear();
    passwordCtrl.clear();
    nameCtrl.clear();
    Get.offAllNamed(AppRoutes.sign_in);
  }

  String get savedToken => _box.read('token') ?? '';
}
