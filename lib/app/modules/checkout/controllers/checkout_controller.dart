import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../components/custom_snackbar.dart';

import '../../cart/controllers/cart_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../../data/order_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/controllers/auth_controller.dart';

class CheckoutController extends GetxController {
  final cartController = Get.find<CartController>();
  final isLoading = false.obs;
  final selectedPaymentMethod = 'Credit Card'.obs;
  final deliveryAddress = ''.obs;
  bool _disposed = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileController = Get.find<ProfileController>();
      if (profileController.addresses.isNotEmpty && deliveryAddress.value.isEmpty) {
        deliveryAddress.value = profileController.addresses.first;
      }
      // Set default payment method if not valid
      final methodTypes = profileController.paymentMethods.map((m) => m['type']).toList();
      if (methodTypes.isNotEmpty && !methodTypes.contains(selectedPaymentMethod.value)) {
        selectedPaymentMethod.value = methodTypes.first ?? '';
      }
    });
  }

  @override
  void onClose() {
    _disposed = true;
    super.onClose();
  }

  double get totalAmount {
    return cartController.cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void setDeliveryAddress(String address) {
    deliveryAddress.value = address;
  }

  Future<void> processOrder() async {
    if (deliveryAddress.value.isEmpty) {
      if (!_disposed) CustomSnackBar.showCustomErrorSnackBar(title: 'Error', message: 'Please enter delivery address');
      return;
    }

    if (_disposed) return;
    isLoading.value = true;
    try {
      // Simulate order processing
      await Future.delayed(const Duration(seconds: 2));

      // Save order to Firestore
      final authController = Get.find<AuthController>();
      final user = authController.currentUser;
      final orderData = {
        'userId': user?.uid ?? '',
        'userName': user?.name ?? '',
        'address': deliveryAddress.value,
        'paymentMethod': selectedPaymentMethod.value,
        'status': 'Processing',
        'total': totalAmount,
        'date': Timestamp.now(),
        'items': cartController.cartItems.map((item) => {
          'productId': item.product.id,
          'name': item.product.name,
          'quantity': item.quantity,
          'price': item.product.price,
        }).toList(),
      };
      await OrderService.addOrder(orderData);

      // Clear cart
      cartController.clearCart();

      // Navigate to order confirmation
      Get.offAllNamed('/order-confirmation');
    } catch (e) {
      if (!_disposed) CustomSnackBar.showCustomErrorSnackBar(title: 'Error', message: 'Failed to process order');
    } finally {
      if (!_disposed) isLoading.value = false;
    }
  }
}
