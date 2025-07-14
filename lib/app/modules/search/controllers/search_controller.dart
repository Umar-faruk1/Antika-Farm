import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../../utils/dummy_helper.dart';

class SearchController extends GetxController {
  final searchController = TextEditingController();
  final isLightTheme = true.obs;
  final isLoading = false.obs;
  final selectedFilters = <String>[].obs;
  final filteredProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with all products
    filteredProducts.value = DummyHelper.products;
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      filteredProducts.value = DummyHelper.products;
    } else {
      final results = DummyHelper.products.where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        product.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
      filteredProducts.value = results;
    }
  }

  void clearSearch() {
    searchController.clear();
    filteredProducts.value = DummyHelper.products;
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