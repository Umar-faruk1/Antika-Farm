import 'package:get/get.dart';

import '../../../data/product_service.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/category_model.dart';

class ProductsController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final Rxn<CategoryModel> category = Rxn<CategoryModel>();

  @override
  void onInit() {
    super.onInit();
    _loadProductsFromArgs();
    ever(category, (_) => _loadProductsFromArgs());
  }

  void _loadProductsFromArgs() async {
    if (Get.arguments != null && Get.arguments is CategoryModel) {
      await setCategory(Get.arguments as CategoryModel);
    } else {
      await getProducts();
    }
  }

  Future<void> setCategory(CategoryModel cat) async {
    category.value = cat;
    final allProducts = await ProductService.fetchProducts();
    products.value = allProducts.where((p) => p.categoryId == cat.id).toList();
  }

  Future<void> getProducts() async {
    products.value = await ProductService.fetchProducts();
  }
}
