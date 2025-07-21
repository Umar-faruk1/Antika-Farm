import 'package:antika_farm/app/data/local/my_shared_pref.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../data/local/my_shared_pref.dart';

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
      _loadAddresses();
      _loadPaymentMethods();
    }
  }

  @override
  void onClose() {
    addressController.dispose();
    paymentTypeController.dispose();
    paymentDetailsController.dispose();
    super.onClose();
  }

  void _loadAddresses() {
    final list = MySharedPref.getUserAddresses();
    addresses.assignAll(list);
  }

  void _saveAddresses() {
    MySharedPref.setUserAddresses(addresses.toList());
  }

  void _loadPaymentMethods() {
    final jsonString = MySharedPref.getUserPaymentMethods();
    if (jsonString != null) {
      final List<dynamic> decoded = json.decode(jsonString);
      paymentMethods.assignAll(decoded.map((e) => Map<String, String>.from(e)));
    }
  }

  void _savePaymentMethods() {
    final jsonString = json.encode(paymentMethods.toList());
    MySharedPref.setUserPaymentMethods(jsonString);
  }
}
