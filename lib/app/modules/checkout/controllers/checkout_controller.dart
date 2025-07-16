// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';

// import '../../cart/controllers/cart_controller.dart';
// import '../../profile/controllers/profile_controller.dart';

// class CheckoutController extends GetxController {
//   final cartController = Get.find<CartController>();
//   final isLoading = false.obs;
//   final selectedPaymentMethod = 'Credit Card'.obs;
//   final deliveryAddress = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final profileController = Get.find<ProfileController>();
//       if (profileController.addresses.isNotEmpty && deliveryAddress.value.isEmpty) {
//         deliveryAddress.value = profileController.addresses.first;
//       }
//       // Set default payment method if not valid
//       final methodTypes = profileController.paymentMethods.map((m) => m['type']).toList();
//       if (methodTypes.isNotEmpty && !methodTypes.contains(selectedPaymentMethod.value)) {
//         selectedPaymentMethod.value = methodTypes.first ?? '';
//       }
//     });
//   }

//   double get totalAmount {
//     return cartController.cartItems.fold(
//       0.0,
//       (sum, item) => sum + (item.product.price * item.quantity),
//     );
//   }

//   void setPaymentMethod(String method) {
//     selectedPaymentMethod.value = method;
//   }

//   void setDeliveryAddress(String address) {
//     deliveryAddress.value = address;
//   }

//   Future<void> processOrder() async {
//     if (deliveryAddress.value.isEmpty) {
//       Get.snackbar('Error', 'Please enter delivery address');
//       return;
//     }

//     isLoading.value = true;
//     try {
//       // Simulate order processing
//       await Future.delayed(const Duration(seconds: 2));

//       // Clear cart
//       cartController.clearCart();

//       // Navigate to order confirmation
//       Get.offAllNamed('/order-confirmation');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to process order');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
