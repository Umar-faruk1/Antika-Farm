import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../../utils/dummy_helper.dart';

class CategoryController extends GetxController {
  final searchController = ''.obs;
  final selectedCategory = ''.obs;
  final minPrice = 0.0.obs;
  final maxPrice = 1000.0.obs;
  final filteredProducts = <ProductModel>[].obs;

  List<String> get categories => DummyHelper.categories.map((c) => c.title).toList();
  double get minAvailablePrice => DummyHelper.products.map((p) => p.price).fold(0.0, (a, b) => a < b ? a : b);
  double get maxAvailablePrice => DummyHelper.products.map((p) => p.price).fold(0.0, (a, b) => a > b ? a : b);

  @override
  void onInit() {
    super.onInit();
    filteredProducts.value = DummyHelper.products;
    minPrice.value = minAvailablePrice;
    maxPrice.value = maxAvailablePrice;
  }

  void onSearchChanged(String query) {
    searchController.value = query;
    _applyFilters();
  }

  void onCategoryChanged(String? category) {
    selectedCategory.value = category ?? '';
    _applyFilters();
  }

  void onPriceRangeChanged(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
    _applyFilters();
  }

  void clearFilters() {
    searchController.value = '';
    selectedCategory.value = '';
    minPrice.value = minAvailablePrice;
    maxPrice.value = maxAvailablePrice;
    filteredProducts.value = DummyHelper.products;
  }

  void _applyFilters() {
    filteredProducts.value = DummyHelper.products.where((product) {
      final matchesSearch = searchController.value.isEmpty ||
        product.name.toLowerCase().contains(searchController.value.toLowerCase()) ||
        product.description.toLowerCase().contains(searchController.value.toLowerCase());
      final matchesCategory = selectedCategory.value.isEmpty ||
        DummyHelper.categories.firstWhereOrNull((c) => c.id == product.categoryId)?.title == selectedCategory.value;
      final matchesPrice = product.price >= minPrice.value && product.price <= maxPrice.value;
      return matchesSearch && matchesCategory && matchesPrice;
    }).toList();
  }
}
