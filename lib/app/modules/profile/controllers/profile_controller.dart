import 'package:get/get.dart';

class ProfileController extends GetxController {
  final addresses = <String>[].obs;
  final paymentMethods = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with some default data (can be loaded from storage in real app)
    addresses.addAll([
      '123 Main St, Springfield, USA',
      '456 Market Ave, Lagos, Nigeria',
    ]);
    paymentMethods.addAll([
      {'type': 'Credit Card', 'details': '**** **** **** 1234'},
      {'type': 'PayPal', 'details': 'user@email.com'},
    ]);
  }
}
