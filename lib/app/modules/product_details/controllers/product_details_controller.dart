import 'package:get/get.dart';
import '../../../components/custom_snackbar.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';

class ProductDetailsController extends GetxController {

  // get product details from arguments
  ProductModel product = Get.arguments;

  /// when the user press on add to cart button
  onAddToCartPressed() {
    Get.find<CartController>().addToCart(product);
    Get.back();
    Future.delayed(const Duration(milliseconds: 300), () {
      CustomSnackBar.showCustomSnackBar(title: 'Added to Cart', message: '${product.name} has been added to your cart.');
    });
  }

}
