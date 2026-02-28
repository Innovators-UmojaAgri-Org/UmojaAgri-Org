import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umoja_agri/services/auth_service.dart';
import 'package:umoja_agri/utils/constants.dart';
import 'package:umoja_agri/utils/app_routes.dart';

// controllers needed for post-login initialization
import 'package:umoja_agri/controllers/farmer/dashboard_controller.dart';
import 'package:umoja_agri/controllers/transporter/transporter_controller.dart';
import 'package:umoja_agri/controllers/marketer/market_controller.dart';

class AuthController extends GetxController {
  final AuthService _service = AuthService();

  // form controllers
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  /// role selection for sign up
  final selectedRole = RoleIds.farmer.obs;

  /// helper loading state
  final isLoading = false.obs;

  /// token returned from the server (if any)
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
        // clear inputs so form does not retain data
        emailCtrl.clear();
        passwordCtrl.clear();
        nameCtrl.clear();

        Get.snackbar('Success', 'Account created, please sign in');
        // navigate back to sign in screen
        //printing error response for debugging
        print('Registration response: ${res.statusCode} - ${res.body}');
        Get.offAllNamed(AppRoutes.sign_in);
      } else {
        final body = jsonDecode(res.body);
        Get.snackbar(
          'Registration failed',
          body['message'] ?? res.reasonPhrase,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not register. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    // temporary bypass for offline/demo mode. 
   

    isLoading.value = true;
    try {
      final roleId = selectedRole.value;
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

      /*
      final email = emailCtrl.text.trim();
      final password = passwordCtrl.text.trim();
      if (email.isEmpty || password.isEmpty) {
        Get.snackbar('Error', 'Email and password required');
        return;
      }

      final res = await _service.login(email: email, password: password);
      // ... original logic here ...
      */
    } catch (e) {
      // ignore
    } finally {
      isLoading.value = false;
    }
  }
}
