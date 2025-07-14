import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/search_controller.dart' as search_controller;
import '../../../data/models/product_model.dart';
import '../../../components/custom_form_field.dart';
import '../../../components/custom_icon_button.dart';
import '../../../components/dark_transition.dart';
import '../../../components/product_item.dart';
import '../../../../utils/constants.dart';

class SearchView extends GetView<search_controller.SearchController> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return DarkTransition(
      offset: Offset(context.width, -1),
      isDark: !controller.isLightTheme.value,
      builder: (context, _) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: CustomIconButton(
            onPressed: () => Get.back(),
            backgroundColor: theme.primaryColorDark,
            icon: SvgPicture.asset(
              Constants.backArrowIcon,
              fit: BoxFit.none,
            ),
          ),
          title: Text(
            'Search',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            CustomIconButton(
              onPressed: () => controller.showFilterDialog(),
              backgroundColor: theme.primaryColorDark,
              icon: Icon(
                Icons.filter_list,
                color: theme.iconTheme.color,
                size: 20,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomFormField(
                controller: controller.searchController,
                onChanged: (value) => controller.onSearchChanged(value ?? ''),
                backgroundColor: theme.primaryColorDark,
                textSize: 14.sp,
                hint: 'Search products...',
                hintFontSize: 14.sp,
                hintColor: theme.hintColor,
                maxLines: 1,
                borderRound: 12.r,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 16.w,
                ),
                focusedBorderColor: Colors.transparent,
                isSearchField: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                prefixIcon: SvgPicture.asset(
                  Constants.searchIcon,
                  fit: BoxFit.none,
                ),
                suffixIcon: controller.searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: theme.hintColor),
                        onPressed: controller.clearSearch,
                      )
                    : null,
              ),
            ),
            
            // Filter Chips
            Obx(() => controller.selectedFilters.isNotEmpty
                ? Container(
                    height: 50.h,
                    margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.selectedFilters.length,
                      itemBuilder: (context, index) {
                        final filter = controller.selectedFilters[index];
                        return Container(
                          margin: EdgeInsets.only(right: 8.w),
                          child: Chip(
                            label: Text(filter),
                            deleteIcon: Icon(Icons.close, size: 16),
                            onDeleted: () => controller.removeFilter(filter),
                            backgroundColor: theme.primaryColor.withOpacity(0.1),
                            labelStyle: TextStyle(color: theme.primaryColor),
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox.shrink()),
            
            // Results Count
            Obx(() => Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${controller.filteredProducts.length} results',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                  if (controller.isLoading.value)
                    SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                      ),
                    ),
                ],
              ),
            )),
            
            // Products Grid
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                    ),
                  );
                }
                
                if (controller.filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64.w,
                          color: theme.hintColor,
                        ),
                        16.verticalSpace,
                        Text(
                          controller.searchController.text.isEmpty
                              ? 'Search for products to find what you need'
                              : 'No products found matching your search',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      mainAxisExtent: 214.h,
                    ),
                    itemCount: controller.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = controller.filteredProducts[index];
                      return ProductItem(product: product);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
} 