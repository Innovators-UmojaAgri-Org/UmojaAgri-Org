import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void success(String message, {String title = 'Success'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xFF16A34A),
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 22),
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(14),
      duration: const Duration(seconds: 3),
      isDismissible: true,
    );
  }

  static void error(String message, {String title = 'Error'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xFFDC2626),
      colorText: Colors.white,
      icon: const Icon(Icons.error_outline_rounded, color: Colors.white, size: 22),
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(14),
      duration: const Duration(seconds: 4),
      isDismissible: true,
    );
  }

  static void info(String message, {String title = ''}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xFF1D4ED8),
      colorText: Colors.white,
      icon: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 22),
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(14),
      duration: const Duration(seconds: 3),
      isDismissible: true,
    );
  }
}
