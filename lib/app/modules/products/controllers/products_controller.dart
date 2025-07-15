import 'package:get/get.dart';

import '../../../data/product_service.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/category_model.dart';

class ProductsController extends GetxController {
  List<ProductModel> products = [];
  CategoryModel? category;

  @override
  void onInit() {
    super.onInit();
    // If a category is passed as argument, filter products
    if (Get.arguments != null && Get.arguments is CategoryModel) {
      setCategory(Get.arguments as CategoryModel);
    } else {
      getProducts();
    }
  }

  Future<void> setCategory(CategoryModel cat) async {
    category = cat;
    final allProducts = await ProductService.fetchProducts();
    products = allProducts.where((p) => p.categoryId == cat.id).toList();
    update();
  }

  Future<void> getProducts() async {
    products = await ProductService.fetchProducts();
    update();
  }
}
