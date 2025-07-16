import 'package:get/get.dart';

class ProfileController extends GetxController {
  final addresses = <String>[].obs;
  final paymentMethods = <Map<String, String>>[].obs;
  bool _initialized = false;

  @override
  void onInit() {
    super.onInit();
    if (!_initialized) {
      addresses.addAll([
        '123 Main St, Springfield, USA',
        '456 Market Ave, Lagos, Nigeria',
      ]);
      paymentMethods.addAll([
        {'type': 'Credit Card', 'details': '**** **** **** 1234'},
        {'type': 'PayPal', 'details': 'user@email.com'},
        {'type': 'Momo', 'details': '+233 123 456 789'},
      ]);
      _initialized = true;
    }
  }
}
