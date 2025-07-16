import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  static showCustomSnackBar({required String title, required String message, Duration? duration}) {
    Get.snackbar(
      title,
      message,
      duration: duration ?? const Duration(seconds: 3),
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      colorText: Colors.white,
      backgroundColor: Colors.green,
      icon: const Icon(Icons.check, color: Colors.white),
      snackPosition: SnackPosition.TOP,
    );
  }

  static showCustomErrorSnackBar({required String title, required String message, Color? color, Duration? duration}) {
    Get.snackbar(
      title,
      message,
      duration: duration ?? const Duration(seconds: 3),
      margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
      colorText: Colors.white,
      backgroundColor: color ?? Colors.red,
      icon: const Icon(Icons.error, color: Colors.white,),
      snackPosition: SnackPosition.TOP,
    );
  }

  static showCustomToast({String? title, required String message, Color? color, Duration? duration}) {
    Get.snackbar(
      title ?? '',
      message,
      duration: duration ?? const Duration(seconds: 3),
      colorText: Colors.white,
      backgroundColor: color ?? Colors.green,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      snackPosition: SnackPosition.TOP,
    );
  }

  static showCustomErrorToast({String? title, required String message, Color? color,Duration? duration}) {
    Get.snackbar(
      title ?? '',
      message,
      duration: duration ?? const Duration(seconds: 3),
      colorText: Colors.white,
      backgroundColor: color ?? Colors.red,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      snackPosition: SnackPosition.TOP,
    );
  }
}