import 'package:antika_farm/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../components/category_item.dart';
import '../../../components/custom_form_field.dart';
import '../../../components/custom_icon_button.dart';
import '../../../components/dark_transition.dart';
import '../../../components/product_item.dart';
import '../controllers/home_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../products/controllers/products_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return DarkTransition(
      offset: Offset(context.width, -1),
      isDark: !controller.isLightTheme,
      builder: (context, _) => Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: -100.h,
              child: SvgPicture.asset(
                Constants.container,
                fit: BoxFit.fill,
                color: theme.canvasColor,
              ),
            ),
            ListView(
              children: [
                Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
                      title: Text(
                        'Hello,',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp
                        ),
                      ),
                      subtitle: GetBuilder<AuthController>(
                        builder: (authController) => Text(
                          authController.currentUser?.name ?? '',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      leading: CircleAvatar(
                        radius: 22.r,
                        backgroundColor: theme.primaryColorDark,
                        child: ClipOval(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Image.asset(Constants.avatar),
                          ),
                        ),
                      ),
                      trailing: CustomIconButton(
                        onPressed: () => controller.onChangeThemePressed(),
                        backgroundColor: theme.primaryColorDark,
                        icon: GetBuilder<HomeController>(
                          id: 'Theme',
                          builder: (_) => Icon(
                            controller.isLightTheme
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                            color: theme.appBarTheme.iconTheme?.color,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: CustomFormField(
                        backgroundColor: theme.primaryColorDark,
                        textSize: 14.sp,
                        hint: 'Search category',
                        hintFontSize: 14.sp,
                        hintColor: theme.hintColor,
                        maxLines: 1,
                        borderRound: 60.r,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 10.w
                        ),
                        focusedBorderColor: Colors.transparent,
                        isSearchField: true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        prefixIcon: SvgPicture.asset(
                          Constants.searchIcon,
                          fit: BoxFit.none
                        ),
                      ),
                    ),
                    20.verticalSpace,
                    SizedBox(
                      width: double.infinity,
                      height: 158.h,
                      child: PageView.builder(
                        controller: PageController(
                          viewportFraction: 0.9,
                          initialPage: 1,
                        ),
                        itemCount: controller.cards.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Image.asset(
                              controller.cards[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      20.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Categories 😋',
                            style: theme.textTheme.headlineMedium,
                          ),
                          // Text(
                          //   'See all',
                          //   style: theme.textTheme.titleLarge?.copyWith(
                          //     color: theme.primaryColor,
                          //     fontWeight: FontWeight.normal,
                          //   ),
                          // ),
                        ],
                      ),
                      16.verticalSpace,
                      GetBuilder<HomeController>(
                        builder: (controller) {
                          if (controller.categories.isEmpty) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: controller.categories.map((category) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 16.w),
                                  child: CategoryItem(
                                    category: category,
                                    onTap: () {
                                      Get.delete<ProductsController>(force: true);
                                      Get.toNamed('/products', arguments: category);
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                      20.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Best selling 🔥',
                            style: theme.textTheme.headlineMedium,
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed(Routes.CATEGORY),
                            child: Text(
                              'See all',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      16.verticalSpace,
                      GetBuilder<HomeController>(
                        builder: (controller) {
                          if (controller.products.isEmpty) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.w,
                              mainAxisSpacing: 16.h,
                              mainAxisExtent: 214.h,
                            ),
                            shrinkWrap: true,
                            primary: false,
                            itemCount: controller.products.length,
                            itemBuilder: (context, index) => ProductItem(
                              product: controller.products[index],
                            ),
                          );
                        },
                      ),
                      20.verticalSpace,
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
