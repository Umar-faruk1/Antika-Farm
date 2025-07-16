import 'package:get/get.dart';

import '../../cart/controllers/cart_controller.dart';

class BaseController extends GetxController {

  // current screen index
  int currentIndex = 0;

  // to count the number of products in the cart
  int cartItemsCount = 0;

  @override
  void onInit() {
    ever(Get.find<CartController>().cartItems, (_) => updateCartItemsCount());
    updateCartItemsCount();
    update(['cart_items_count']);
    super.onInit();
  }

  /// change the selected screen index
  changeScreen(int selectedIndex) {
    currentIndex = selectedIndex;
    update();
    updateCartItemsCount();
  }

  /// calculate the number of products in the cart
  void updateCartItemsCount() {
    cartItemsCount = Get.find<CartController>().totalItems;
    update(['CartBadge']);
  }
}
