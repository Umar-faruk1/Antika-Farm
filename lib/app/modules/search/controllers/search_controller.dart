import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../../utils/dummy_helper.dart';
import '../../../data/product_service.dart';

class SearchController extends GetxController {
  final searchController = TextEditingController();
  final isLightTheme = true.obs;
  final isLoading = false.obs;
  final selectedFilters = <String>[].obs;
  final filteredProducts = <ProductModel>[].obs;
  List<ProductModel> allProducts = [];

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    allProducts = await ProductService.fetchProducts();
    filteredProducts.value = allProducts;
    isLoading.value = false;
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      filteredProducts.value = allProducts;
    } else {
      final results = allProducts.where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        product.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
      filteredProducts.value = results;
    }
  }

  void clearSearch() {
    searchController.clear();
    filteredProducts.value = allProducts;
  }

  void showFilterDialog() {
    // Show filter dialog implementation
    Get.dialog(
      AlertDialog(
        title: Text('Filter Products'),
        content: Text('Filter options would go here'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }

  void addFilter(String filter) {
    if (!selectedFilters.contains(filter)) {
      selectedFilters.add(filter);
    }
  }

  void removeFilter(String filter) {
    selectedFilters.remove(filter);
  }
} 