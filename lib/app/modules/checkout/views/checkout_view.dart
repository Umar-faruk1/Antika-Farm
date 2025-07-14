import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_icon_button.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({Key? key}) : super(key: key);

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
              CustomIconButton(
                onPressed: () => Get.back(),
                backgroundColor: theme.scaffoldBackgroundColor,
                borderColor: theme.dividerColor,
                icon: SvgPicture.asset(
                  Constants.backArrowIcon,
                  fit: BoxFit.none,
                  color: theme.appBarTheme.iconTheme?.color,
                ),
              ),
              Text('Checkout', style: theme.textTheme.displaySmall),
              const Opacity(
                opacity: 0.0,
                child: CustomIconButton(onPressed: null, icon: Center()),
              ),
            ],
          ),
        ),
      ),
      body: GetBuilder<CheckoutController>(
        builder: (_) => Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Address',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              16.verticalSpace,
              TextField(
                onChanged: controller.setDeliveryAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your delivery address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                maxLines: 3,
              ),
              32.verticalSpace,
              Text(
                'Payment Method',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              16.verticalSpace,
              _buildPaymentMethodCard('Credit Card', Icons.credit_card),
              8.verticalSpace,
              _buildPaymentMethodCard('PayPal', Icons.payment),
              8.verticalSpace,
              _buildPaymentMethodCard('Cash on Delivery', Icons.money),
              32.verticalSpace,
              Text(
                'Order Summary',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              16.verticalSpace,
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
                        Text('Subtotal', style: theme.textTheme.bodyLarge),
                        Text('\$${controller.totalAmount.toStringAsFixed(2)}', 
                              style: theme.textTheme.bodyLarge),
                      ],
                    ),
                    8.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery Fee', style: theme.textTheme.bodyLarge),
                        Text('\$5.00', style: theme.textTheme.bodyLarge),
                      ],
                    ),
                    16.verticalSpace,
                    Divider(color: theme.dividerColor),
                    8.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                        Text('\$${(controller.totalAmount + 5.0).toStringAsFixed(2)}', 
                              style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Obx(() => CustomButton(
                text: controller.isLoading.value ? 'Processing...' : 'Place Order',
                onPressed: controller.isLoading.value ? null : controller.processOrder,
                fontSize: 16.sp,
                radius: 50.r,
                verticalPadding: 16.h,
                hasShadow: false,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(String title, IconData icon) {
    return Obx(() => GestureDetector(
      onTap: () => controller.setPaymentMethod(title),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: controller.selectedPaymentMethod.value == title 
              ? Get.theme.primaryColor.withOpacity(0.1)
              : Get.theme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: controller.selectedPaymentMethod.value == title 
                ? Get.theme.primaryColor
                : Get.theme.dividerColor,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24.w, color: Get.theme.primaryColor),
            12.horizontalSpace,
            Text(title, style: Get.theme.textTheme.bodyLarge),
            const Spacer(),
            if (controller.selectedPaymentMethod.value == title)
              Icon(Icons.check_circle, color: Get.theme.primaryColor),
          ],
        ),
      ),
    ));
  }
} 