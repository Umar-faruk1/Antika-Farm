import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/product_item.dart';
import '../controllers/category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      appBar: AppBar(
        title: Text('All Products', style: theme.textTheme.displaySmall),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            16.verticalSpace,
            // Filter Row
            Row(
              children: [
                // Category Dropdown
                Expanded(
                  child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedCategory.value.isNotEmpty ? controller.selectedCategory.value : null,
                    items: [
                      DropdownMenuItem(value: '', child: Text('All Categories')),
                      ...controller.categories.map((cat) => DropdownMenuItem(value: cat.id, child: Text(cat.title)))
                    ],
                    onChanged: controller.onCategoryChanged,
                    decoration: InputDecoration(
                      hintText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  )),
                ),
                16.horizontalSpace,
                // Price Range (min-max)
                Expanded(
                  child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price Range', style: theme.textTheme.bodySmall),
                      RangeSlider(
                        values: RangeValues(controller.minPrice.value, controller.maxPrice.value),
                        min: controller.minAvailablePrice,
                        max: controller.maxAvailablePrice,
                        divisions: 20,
                        labels: RangeLabels(
                          controller.minPrice.value.toStringAsFixed(0),
                          controller.maxPrice.value.toStringAsFixed(0),
                        ),
                        onChanged: (range) => controller.onPriceRangeChanged(range.start, range.end),
                      ),
                    ],
                  )),
                ),
              ],
            ),
            16.verticalSpace,
            // Results Grid
            Expanded(
              child: Obx(() => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  mainAxisExtent: 214.h,
                ),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) => ProductItem(
                  product: controller.filteredProducts[index],
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}