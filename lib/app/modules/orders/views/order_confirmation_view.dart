import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../components/custom_button.dart';
import '../../../routes/app_pages.dart';

class OrderConfirmationView extends StatelessWidget {
  const OrderConfirmationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60.r,
                backgroundColor: Colors.green.withOpacity(0.1),
                child: Icon(
                  Icons.check_circle,
                  size: 80.w,
                  color: Colors.green,
                ),
              ).animate().fade().scale(
                duration: 500.ms,
                curve: Curves.easeInOut,
              ),
              32.verticalSpace,
              Text(
                'Order Confirmed!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ).animate().fade().slideY(
                duration: 300.ms,
                begin: -1,
                curve: Curves.easeInSine,
              ),
              16.verticalSpace,
              Text(
                'Your order has been successfully placed and is being processed.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ).animate().fade().slideY(
                duration: 300.ms,
                begin: 1,
                curve: Curves.easeInSine,
              ),
              24.verticalSpace,
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order ID', style: theme.textTheme.bodyMedium),
                        Text(
                          'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimated Delivery', style: theme.textTheme.bodyMedium),
                        Text(
                          '2-3 days',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fade().slideY(
                duration: 300.ms,
                begin: 1,
                curve: Curves.easeInSine,
              ),
              40.verticalSpace,
              CustomButton(
                text: 'Continue Shopping',
                onPressed: () => Get.offAllNamed(Routes.BASE),
                fontSize: 16.sp,
                radius: 50.r,
                verticalPadding: 16.h,
                hasShadow: false,
              ).animate().fade().slideY(
                duration: 300.ms,
                begin: 1,
                curve: Curves.easeInSine,
              ),
              16.verticalSpace,
              TextButton(
                onPressed: () => Get.toNamed(Routes.ORDERS),
                child: Text(
                  'View My Orders',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ).animate().fade().slideY(
                duration: 300.ms,
                begin: 1,
                curve: Curves.easeInSine,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 