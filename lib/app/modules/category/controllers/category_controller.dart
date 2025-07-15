import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/category_service.dart';
import '../../../data/product_service.dart';

class CategoryController extends GetxController {
  final searchController = ''.obs;
  final selectedCategory = ''.obs;
  final minPrice = 0.0.obs;
  final maxPrice = 1000.0.obs;
  final filteredProducts = <ProductModel>[].obs;
  List<CategoryModel> categories = [];
  List<ProductModel> allProducts = [];

  double get minAvailablePrice => allProducts.isEmpty ? 0.0 : allProducts.map((p) => p.price).reduce((a, b) => a < b ? a : b);
  double get maxAvailablePrice => allProducts.isEmpty ? 1.0 : allProducts.map((p) => p.price).reduce((a, b) => a > b ? a : b);

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    categories = await CategoryService.fetchCategories();
    allProducts = await ProductService.fetchProducts();
    // Ensure min < max for RangeSlider
    if (allProducts.isEmpty) {
      minPrice.value = 0.0;
      maxPrice.value = 1.0;
    } else {
      minPrice.value = minAvailablePrice;
      maxPrice.value = maxAvailablePrice > minAvailablePrice ? maxAvailablePrice : minAvailablePrice + 1.0;
    }
    filteredProducts.value = allProducts;
  }

  void onSearchChanged(String query) {
    searchController.value = query;
    _applyFilters();
  }

  void onCategoryChanged(String? categoryId) {
    selectedCategory.value = categoryId ?? '';
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
    filteredProducts.value = allProducts;
  }

  void _applyFilters() {
    filteredProducts.value = allProducts.where((product) {
      final matchesSearch = searchController.value.isEmpty ||
        product.name.toLowerCase().contains(searchController.value.toLowerCase()) ||
        product.description.toLowerCase().contains(searchController.value.toLowerCase());
      final matchesCategory = selectedCategory.value.isEmpty ||
        product.categoryId == selectedCategory.value;
      final matchesPrice = product.price >= minPrice.value && product.price <= maxPrice.value;
      return matchesSearch && matchesCategory && matchesPrice;
    }).toList();
  }
}
