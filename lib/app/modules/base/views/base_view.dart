import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../routes/app_pages.dart';
import '../../calendar/views/calendar_view.dart';
import '../../category/views/category_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/base_controller.dart';
import '../../home/views/home_view.dart';
import '../../cart/controllers/cart_controller.dart';

class BaseView extends GetView<BaseController> {
  const BaseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.theme;
    return GetBuilder<BaseController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: controller.currentIndex,
            children: const [
              HomeView(),
              CategoryView(),
              Center(),
              CalendarView(),
              ProfileView()
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex,
          type: BottomNavigationBarType.fixed,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0.0,
          items: [
            _mBottomNavItem(
              label: 'Home',
              icon: Constants.homeIcon,
            ),
            _mBottomNavItem(
              label: 'category',
              icon: Constants.categoryIcon,
            ),
            const BottomNavigationBarItem(
              label: '',
              icon: Center(),
            ),
            _mBottomNavItem(
              label: 'Calendar',
              icon: Constants.calendarIcon,
            ),
            _mBottomNavItem(
              label: 'Profile',
              icon: Constants.userIcon,
            ),
          ],
          onTap: controller.changeScreen,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          onPressed:() => Get.toNamed(Routes.CART),
          child: Obx(() {
            final cartCount = Get.find<CartController>().totalItems;
            return badges.Badge(
              position: badges.BadgePosition.bottomEnd(bottom: -16, end: 13),
              badgeContent: Text(
                cartCount.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              badgeStyle: badges.BadgeStyle(
                elevation: 2,
                badgeColor: theme.colorScheme.secondary,
                borderSide: const BorderSide(color: Colors.white, width: 1),
              ),
              child: CircleAvatar(
                radius: 22.r,
                backgroundColor: theme.primaryColor,
                child: SvgPicture.asset(
                  Constants.cartIcon, fit: BoxFit.none,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  _mBottomNavItem({required String label, required String icon}) {
    return BottomNavigationBarItem(
      label: label,
      icon: SvgPicture.asset(icon, color: Get.theme.iconTheme.color),
      activeIcon: SvgPicture.asset(icon, color: Get.theme.appBarTheme.iconTheme?.color),
    );
  }

}
