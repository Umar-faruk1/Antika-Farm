import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

import '../../../../utils/constants.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_icon_button.dart';
import '../controllers/checkout_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    // Ensure profileController is registered
    final ProfileController profileController =
        Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

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
        builder: (_) {
          return Padding(
          padding: EdgeInsets.all(24.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  /// DELIVERY ADDRESS
                Text(
                  'Delivery Address',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                16.verticalSpace,
                  DropdownButtonFormField<String>(
                    value: profileController.addresses.isNotEmpty
                        ? (controller.deliveryAddress.value.isNotEmpty
                          ? controller.deliveryAddress.value
                            : profileController.addresses.first)
                          : null,
                      items: profileController.addresses
                          .map((address) => DropdownMenuItem(
                                value: address,
                                child: Text(address),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) controller.setDeliveryAddress(val);
                      },
                      decoration: InputDecoration(
                        hintText: 'Select your delivery address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                  ),
                32.verticalSpace,

                  /// PAYMENT METHOD
                Text(
                  'Payment Method',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                16.verticalSpace,
                Obx(() {
                  final methods = profileController.paymentMethods;
                  final selected = controller.selectedPaymentMethod.value;
                  return Column(
                    children: [
                      if (methods.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: methods.map((method) {
                            final type = (method['type'] ?? '').trim();
                            final details = method['details'] ?? '';
                            final normalizedType = type.toLowerCase();
                            final selectedNormalized = selected.trim().toLowerCase();
                            Widget iconWidget;
                            if (normalizedType == 'credit card') {
                              iconWidget = Image.asset(
                                'assets/images/card1.png',
                                width: 40,
                                height: 28,
                              );
                            } else if (normalizedType == 'momo') {
                              iconWidget = Icon(Icons.phone_android,
                                  size: 32, color: theme.primaryColor);
                            } else if (normalizedType == 'paypal') {
                              iconWidget = Icon(
                                  Icons.account_balance_wallet,
                                  size: 32,
                                  color: theme.primaryColor);
                            } else {
                              iconWidget = Icon(Icons.payment,
                                  size: 32, color: theme.primaryColor);
                            }
                            return GestureDetector(
                              onTap: () => controller.setPaymentMethod(type),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 6.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: selectedNormalized == normalizedType
                                      ? theme.primaryColor.withOpacity(0.1)
                                      : theme.cardColor,
                                  border: Border.all(
                                    color: selectedNormalized == normalizedType
                                        ? theme.primaryColor
                                        : theme.dividerColor,
                                    width: selectedNormalized == normalizedType ? 4 : 1.2,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Column(
                                  children: [
                                    iconWidget,
                                    8.verticalSpace,
                                    Text(type,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      16.verticalSpace,
                      Builder(
                        builder: (_) {
                          final current = methods.firstWhereOrNull(
                              (m) => (m['type'] ?? '').trim().toLowerCase() == selected.trim().toLowerCase());
                          if (current == null) return SizedBox.shrink();
                          final details = current['details'] ?? '';
                          Widget icon;
                          final normalizedSelected = selected.trim().toLowerCase();
                          if (normalizedSelected == 'credit card') {
                            icon = Image.asset('assets/images/card1.png',
                                width: 32, height: 22);
                          } else if (normalizedSelected == 'momo') {
                            icon = Icon(Icons.phone_android,
                                size: 28, color: theme.primaryColor);
                          } else if (normalizedSelected == 'paypal') {
                            icon = Icon(Icons.account_balance_wallet,
                                size: 28, color: theme.primaryColor);
                          } else {
                            icon = Icon(Icons.payment,
                                size: 28, color: theme.primaryColor);
                          }
                          return Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: Row(
                              children: [
                                icon,
                                12.horizontalSpace,
                                Text(details, style: theme.textTheme.bodyLarge),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => Get.toNamed('/payment-methods'),
                                  child: Text(
                                    'Change',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }),

                32.verticalSpace,

                  /// ORDER SUMMARY
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
                            Text(
                              'GHS${controller.totalAmount.toStringAsFixed(2)}',
                              style: theme.textTheme.bodyLarge,
                            ),
                        ],
                      ),
                      8.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text('Delivery Fee',
                                style: theme.textTheme.bodyLarge),
                            Text('GHS5.00',
                                style: theme.textTheme.bodyLarge),
                        ],
                      ),
                      16.verticalSpace,
                      Divider(color: theme.dividerColor),
                      8.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total',
                                style: theme.textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                          Text(
                              'GHS${(controller.totalAmount + 5.0).toStringAsFixed(2)}',
                              style: theme.textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                  24.verticalSpace,

                  /// PAY BUTTON
                Obx(() => CustomButton(
                      text: controller.isLoading.value
                          ? 'Processing...'
                            : 'Pay Now',
                        icon: controller.selectedPaymentMethod.value ==
                                'Credit Card'
                            ? Image.asset('assets/images/card1.png',
                                width: 24, height: 16)
                            : controller.selectedPaymentMethod.value == 'Momo'
                                ? Icon(Icons.phone_android,
                                    color: Colors.white, size: 20)
                                : controller.selectedPaymentMethod.value ==
                                        'PayPal'
                                    ? Icon(Icons.account_balance_wallet,
                                        color: Colors.white, size: 20)
                                    : null,
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.processOrder,
                      fontSize: 16.sp,
                      radius: 50.r,
                      verticalPadding: 16.h,
                        hasShadow: true,
                    )),
              ],
            ),
          ),
          );
        },
      ),
    );
  }
}
