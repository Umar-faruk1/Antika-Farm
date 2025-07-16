import 'package:get/get.dart';
import '../../../data/models/product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;
  CartItem({required this.product, required this.quantity});
}

class CartController extends GetxController {
  // List of items in the cart
  final RxList<CartItem> cartItems = <CartItem>[].obs;

  // Add a product to the cart (or increment if already present)
  void addToCart(ProductModel product) {
    final index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      cartItems.add(CartItem(product: product, quantity: 1));
    } else {
      cartItems[index].quantity++;
    }
    update(['ProductQuantity_${product.id}', 'CartBadge']);
  }

  // Increment quantity
  void incrementQuantity(String productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      cartItems[index].quantity++;
      update(['ProductQuantity_$productId', 'CartBadge']);
    }
  }

  // Decrement quantity
  void decrementQuantity(String productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1 && cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      update(['ProductQuantity_$productId', 'CartBadge']);
    } else if (index != -1) {
      cartItems.removeAt(index);
      update(['ProductQuantity_$productId', 'CartBadge']);
    }
  }

  // Get quantity for a product
  int getQuantity(String productId) {
    final item = cartItems.firstWhereOrNull((item) => item.product.id == productId);
    return item?.quantity ?? 0;
  }

  // Clear cart
  void clearCart() {
    cartItems.clear();
    update(['CartBadge']);
  }

  // Total items in cart
  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);

  // Get only items with quantity > 0
  List<CartItem> get nonEmptyCartItems => cartItems.where((item) => item.quantity > 0).toList();

  void onPurchaseNowPressed() {
    Get.toNamed('/checkout');
  }
}