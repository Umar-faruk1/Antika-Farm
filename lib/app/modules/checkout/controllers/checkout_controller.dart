import 'package:get/get.dart';

import '../../cart/controllers/cart_controller.dart';

class CheckoutController extends GetxController {
  final cartController = Get.find<CartController>();
  final isLoading = false.obs;
  final selectedPaymentMethod = 'Credit Card'.obs;
  final deliveryAddress = ''.obs;

  double get totalAmount {
    return cartController.products.fold(0.0, (sum, product) => sum + (product.price * product.quantity));
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void setDeliveryAddress(String address) {
    deliveryAddress.value = address;
  }

  Future<void> processOrder() async {
    if (deliveryAddress.value.isEmpty) {
      Get.snackbar('Error', 'Please enter delivery address');
      return;
    }

    isLoading.value = true;
    try {
      // Simulate order processing
      await Future.delayed(const Duration(seconds: 2));
      
      // Clear cart
      cartController.clearCart();
      
      // Navigate to order confirmation
      Get.offAllNamed('/order-confirmation');
    } catch (e) {
      Get.snackbar('Error', 'Failed to process order');
    } finally {
      isLoading.value = false;
    }
  }
} 