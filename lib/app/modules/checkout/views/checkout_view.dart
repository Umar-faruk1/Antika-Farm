// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';

// import '../../../../utils/constants.dart';
// import '../../../components/custom_button.dart';
// import '../../../components/custom_icon_button.dart';
// import '../controllers/checkout_controller.dart';
// import '../../profile/controllers/profile_controller.dart';

// class CheckoutView extends GetView<CheckoutController> {
//   const CheckoutView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final theme = context.theme;
//     final ProfileController profileController = Get.find<ProfileController>();

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8.w),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CustomIconButton(
//                 onPressed: () => Get.back(),
//                 backgroundColor: theme.scaffoldBackgroundColor,
//                 borderColor: theme.dividerColor,
//                 icon: SvgPicture.asset(
//                   Constants.backArrowIcon,
//                   fit: BoxFit.none,
//                   color: theme.appBarTheme.iconTheme?.color,
//                 ),
//               ),
//               Text('Checkout', style: theme.textTheme.displaySmall),
//               const Opacity(
//                 opacity: 0.0,
//                 child: CustomIconButton(onPressed: null, icon: Center()),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: GetBuilder<CheckoutController>(
//         builder: (_) {
//           // Removed post-frame callback logic from view. All defaulting is now in controller.
//           return Padding(
//             padding: EdgeInsets.all(24.w),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Delivery Address',
//                     style: theme.textTheme.headlineSmall?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   16.verticalSpace,
//                   // Delivery Address selection (remove Obx)
//                   GetBuilder<CheckoutController>(
//                     builder: (_) => DropdownButtonFormField<String>(
//                           value: profileController.addresses.isNotEmpty &&
//                                   controller.deliveryAddress.value.isNotEmpty
//                               ? controller.deliveryAddress.value
//                               : null,
//                           items: profileController.addresses
//                               .map((address) => DropdownMenuItem(
//                                     value: address,
//                                     child: Text(address),
//                                   ))
//                               .toList(),
//                           onChanged: (val) {
//                             if (val != null) controller.setDeliveryAddress(val);
//                           },
//                           decoration: InputDecoration(
//                             hintText: 'Select your delivery address',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                           ),
//                         )),
//                   32.verticalSpace,
//                   Text(
//                     'Payment Method',
//                     style: theme.textTheme.headlineSmall?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   16.verticalSpace,
//                   // Payment method selection redesign (remove Obx)
//                   GetBuilder<CheckoutController>(
//                     builder: (_) {
//                       final methods = profileController.paymentMethods;
//                       final selected = controller.selectedPaymentMethod.value;
//                       return Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: methods.map((method) {
//                               String type = method['type'] ?? '';
//                               String details = method['details'] ?? '';
//                               Widget iconWidget;
//                               if (type == 'Credit Card') {
//                                 iconWidget = Image.asset('assets/images/card1.png', width: 40, height: 28);
//                               } else if (type == 'Momo') {
//                                 iconWidget = Icon(Icons.phone_android, size: 32, color: theme.primaryColor); // Placeholder for Momo
//                               } else if (type == 'PayPal') {
//                                 iconWidget = Icon(Icons.account_balance_wallet, size: 32, color: theme.primaryColor);
//                               } else {
//                                 iconWidget = Icon(Icons.payment, size: 32, color: theme.primaryColor);
//                               }
//                               return GestureDetector(
//                                 onTap: () => controller.setPaymentMethod(type),
//                                 child: Container(
//                                   margin: EdgeInsets.symmetric(horizontal: 6.w),
//                                   padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
//                                   decoration: BoxDecoration(
//                                     color: selected == type ? theme.primaryColor.withOpacity(0.1) : theme.cardColor,
//                                     border: Border.all(
//                                       color: selected == type ? theme.primaryColor : theme.dividerColor,
//                                       width: selected == type ? 2 : 1,
//                                     ),
//                                     borderRadius: BorderRadius.circular(12.r),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       iconWidget,
//                                       8.verticalSpace,
//                                       Text(type, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                           16.verticalSpace,
//                           // Show details for selected payment method
//                           if (selected == 'Credit Card')
//                             Container(
//                               padding: EdgeInsets.all(12.w),
//                               decoration: BoxDecoration(
//                                 color: theme.cardColor,
//                                 borderRadius: BorderRadius.circular(12.r),
//                                 border: Border.all(color: theme.dividerColor),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Image.asset('assets/images/card1.png', width: 32, height: 22),
//                                   12.horizontalSpace,
//                                   Text(
//                                     methods.firstWhere((m) => m['type'] == 'Credit Card')['details'] ?? '',
//                                     style: theme.textTheme.bodyLarge,
//                                   ),
//                                   Spacer(),
//                                   TextButton(
//                                     onPressed: () => Get.toNamed('/payment-methods'),
//                                     child: Text('Change', style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor)),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           else if (selected == 'Momo')
//                             Container(
//                               padding: EdgeInsets.all(12.w),
//                               decoration: BoxDecoration(
//                                 color: theme.cardColor,
//                                 borderRadius: BorderRadius.circular(12.r),
//                                 border: Border.all(color: theme.dividerColor),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.phone_android, size: 28, color: theme.primaryColor),
//                                   12.horizontalSpace,
//                                   Text(
//                                     methods.firstWhere((m) => m['type'] == 'Momo')['details'] ?? '',
//                                     style: theme.textTheme.bodyLarge,
//                                   ),
//                                   Spacer(),
//                                   TextButton(
//                                     onPressed: () => Get.toNamed('/payment-methods'),
//                                     child: Text('Change', style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor)),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           else if (selected == 'PayPal')
//                             Container(
//                               padding: EdgeInsets.all(12.w),
//                               decoration: BoxDecoration(
//                                 color: theme.cardColor,
//                                 borderRadius: BorderRadius.circular(12.r),
//                                 border: Border.all(color: theme.dividerColor),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.account_balance_wallet, size: 28, color: theme.primaryColor),
//                                   12.horizontalSpace,
//                                   Text(
//                                     methods.firstWhere((m) => m['type'] == 'PayPal')['details'] ?? '',
//                                     style: theme.textTheme.bodyLarge,
//                                   ),
//                                   Spacer(),
//                                   TextButton(
//                                     onPressed: () => Get.toNamed('/payment-methods'),
//                                     child: Text('Change', style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor)),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                         ],
//                       );
//                     }),
//                   32.verticalSpace,
//                   Text(
//                     'Order Summary',
//                     style: theme.textTheme.headlineSmall?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   16.verticalSpace,
//                   Container(
//                     padding: EdgeInsets.all(16.w),
//                     decoration: BoxDecoration(
//                       color: theme.cardColor,
//                       borderRadius: BorderRadius.circular(12.r),
//                       border: Border.all(color: theme.dividerColor),
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('Subtotal', style: theme.textTheme.bodyLarge),
//                             Text('\$${controller.totalAmount.toStringAsFixed(2)}',
//                                 style: theme.textTheme.bodyLarge),
//                           ],
//                         ),
//                         8.verticalSpace,
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('Delivery Fee', style: theme.textTheme.bodyLarge),
//                             Text('\$5.00', style: theme.textTheme.bodyLarge),
//                           ],
//                         ),
//                         16.verticalSpace,
//                         Divider(color: theme.dividerColor),
//                         8.verticalSpace,
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('Total',
//                                 style: theme.textTheme.headlineSmall?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 )),
//                             Text(
//                                 '\$${(controller.totalAmount + 5.0).toStringAsFixed(2)}',
//                                 style: theme.textTheme.headlineSmall?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 )),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 24.h),
//                   Obx(() => CustomButton(
//                         text: controller.isLoading.value
//                             ? 'Processing...'
//                             : 'Pay Now',
//                         icon: controller.selectedPaymentMethod.value == 'Credit Card'
//                             ? Image.asset('assets/images/card1.png', width: 24, height: 16)
//                             : controller.selectedPaymentMethod.value == 'Momo'
//                                 ? Icon(Icons.phone_android, color: Colors.white, size: 20)
//                                 : controller.selectedPaymentMethod.value == 'PayPal'
//                                     ? Icon(Icons.account_balance_wallet, color: Colors.white, size: 20)
//                                     : null,
//                         onPressed: controller.isLoading.value
//                             ? null
//                             : controller.processOrder,
//                         fontSize: 16.sp,
//                         radius: 50.r,
//                         verticalPadding: 16.h,
//                         hasShadow: true,
//                       )),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
