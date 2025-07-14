import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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
    final ProfileController profileController = Get.isRegistered<ProfileController>()
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
        builder: (_) => Padding(
          padding: EdgeInsets.all(24.w),
          child: SingleChildScrollView(
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
                Obx(() => DropdownButtonFormField<String>(
                  value: profileController.addresses.isNotEmpty ? controller.deliveryAddress.value.isNotEmpty ? controller.deliveryAddress.value : profileController.addresses.first : null,
                  items: profileController.addresses.map((address) => DropdownMenuItem(
                    value: address,
                    child: Text(address),
                  )).toList(),
                  onChanged: (val) {
                    if (val != null) controller.setDeliveryAddress(val);
                  },
                  decoration: InputDecoration(
                    hintText: 'Select your delivery address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                )),
                32.verticalSpace,
                Text(
                  'Payment Method',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                16.verticalSpace,
                Obx(() => DropdownButtonFormField<String>(
                  value: profileController.paymentMethods.isNotEmpty ? controller.selectedPaymentMethod.value : null,
                  items: profileController.paymentMethods.map((method) => DropdownMenuItem(
                    value: method['type'],
                    child: Text('${method['type']} (${method['details']})'),
                  )).toList(),
                  onChanged: (val) {
                    if (val != null) controller.setPaymentMethod(val);
                  },
                  decoration: InputDecoration(
                    hintText: 'Select payment method',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                )),
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
                SizedBox(height: 24.h),
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
      ),
    );
  }
} 