import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static Future<void> successSnackbar({
    required String title,
    required String message,
  }) async{
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
      ),
    );
  }

  static errorSnackbar({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      icon: const Icon(
        Icons.error_outline,
        color: Colors.white,
      ),
    );
  }
}
