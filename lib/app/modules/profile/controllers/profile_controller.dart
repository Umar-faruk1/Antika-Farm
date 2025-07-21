import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  final addresses = <String>[].obs;
  final paymentMethods = <Map<String, String>>[].obs;
  bool _initialized = false;

  // Persistent controllers for dialogs
  final addressController = TextEditingController();
  final paymentTypeController = TextEditingController();
  final paymentDetailsController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (!_initialized) {
      _initialized = true;
    }
  }

  @override
  void onClose() {
    addressController.dispose();
    paymentTypeController.dispose();
    paymentDetailsController.dispose();
    super.onClose();
  }
}
