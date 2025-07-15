import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../components/custom_icon_button.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Opacity(
                opacity: 0.0,
                child: CustomIconButton(onPressed: null, icon: Center()),
              ),
              Text('Profile', style: theme.textTheme.displaySmall),
              // CustomIconButton(
              //   onPressed: () => Get.toNamed(Routes.SEARCH),
              //   backgroundColor: theme.scaffoldBackgroundColor,
              //   borderColor: theme.dividerColor,
              //   icon: SvgPicture.asset(
              //     Constants.searchIcon,
              //     fit: BoxFit.none,
              //     color: theme.appBarTheme.iconTheme?.color,
              //   ),
              // ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50.r,
              backgroundColor: theme.primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 60.w,
                color: theme.primaryColor,
              ),
            ),
            24.verticalSpace,
            GetBuilder<AuthController>(
              builder: (authController) => Column(
                children: [
                  Text(
                    authController.currentUser?.name ?? '',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    authController.currentUser?.email ?? '',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            40.verticalSpace,
            _buildProfileOption(
              icon: Icons.shopping_bag,
              title: 'My Orders',
              subtitle: 'View your order history',
              onTap: () => Get.toNamed(Routes.ORDERS),
              theme: theme,
            ),
            16.verticalSpace,
            _buildProfileOption(
              icon: Icons.favorite,
              title: 'Favorites',
              subtitle: 'Your saved items',
              onTap: () {},
              theme: theme,
            ),
            16.verticalSpace,
            _buildProfileOption(
              icon: Icons.location_on,
              title: 'Addresses',
              subtitle: 'Manage your addresses',
              onTap: () => Get.toNamed('/addresses'),
              theme: theme,
            ),
            16.verticalSpace,
            _buildProfileOption(
              icon: Icons.payment,
              title: 'Payment Methods',
              subtitle: 'Manage your payment options',
              onTap: () => Get.toNamed('/payment-methods'),
              theme: theme,
            ),
            16.verticalSpace,
            _buildProfileOption(
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'App preferences and settings',
              onTap: () {},
              theme: theme,
            ),
            SizedBox(height: 24),
            _buildProfileOption(
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Sign out of your account',
              onTap: () => Get.offAllNamed(Routes.LOGIN),
              theme: theme,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeData theme,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isDestructive 
                    ? Colors.red.withOpacity(0.1)
                    : theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : theme.primaryColor,
                size: 20.w,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? Colors.red : null,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.w,
              color: theme.textTheme.bodySmall?.color,
            ),
          ],
        ),
      ),
    );
  }
}