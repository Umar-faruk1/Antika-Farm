import 'package:get/get.dart';

import '../../../../utils/dummy_helper.dart';
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

  void setCategory(CategoryModel cat) {
    category = cat;
    products = DummyHelper.products
        .where((p) => p.categoryId == cat.id)
        .toList();
    update();
  }

  void getProducts() {
    products = List<ProductModel>.from(DummyHelper.products);
    update();
  }
}
