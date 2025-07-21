import 'package:antika_farm/app/components/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class PaymentMethodsView extends StatefulWidget {
  const PaymentMethodsView({Key? key}) : super(key: key);

  @override
  State<PaymentMethodsView> createState() => _PaymentMethodsViewState();
}

class _PaymentMethodsViewState extends State<PaymentMethodsView> {
  final ProfileController profileController = Get.find<ProfileController>();

  void _showPaymentDialog({Map<String, String>? initial, int? editIndex}) {
    profileController.paymentTypeController.text = initial?['type'] ?? '';
    profileController.paymentDetailsController.text = initial?['details'] ?? '';
    String selectedType = initial?['type'] ?? '';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(editIndex == null ? 'Add Payment Method' : 'Edit Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType.isNotEmpty ? selectedType : null,
                items: [
                  DropdownMenuItem(value: 'Credit Card', child: Text('Credit Card')),
                  DropdownMenuItem(value: 'PayPal', child: Text('PayPal')),
                  DropdownMenuItem(value: 'Momo', child: Text('Momo')),
                ],
                onChanged: (val) {
                  setState(() {
                    selectedType = val ?? '';
                    profileController.paymentTypeController.text = selectedType;
                    profileController.paymentDetailsController.text = '';
                  });
                },
                decoration: const InputDecoration(hintText: 'Type'),
              ),
              16.verticalSpace,
              if (selectedType == 'Credit Card')
                TextField(
                  controller: profileController.paymentDetailsController,
                  decoration: const InputDecoration(hintText: 'Card Number (e.g. **** **** **** 1234)'),
                )
              else if (selectedType == 'PayPal')
                TextField(
                  controller: profileController.paymentDetailsController,
                  decoration: const InputDecoration(hintText: 'PayPal Email'),
                )
              else if (selectedType == 'Momo')
                TextField(
                  controller: profileController.paymentDetailsController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(hintText: 'Momo Phone Number'),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final type = profileController.paymentTypeController.text.trim();
                final details = profileController.paymentDetailsController.text.trim();
                if (type.isNotEmpty && details.isNotEmpty) {
                  if (type == 'Momo' && !RegExp(r'^\+?\d{9,15}\$').hasMatch(details)) {
                    CustomSnackBar.showCustomErrorSnackBar(title: 'Invalid', message: 'Enter a valid phone number for Momo');
                    return;
                  }
                  if (editIndex == null) {
                    profileController.paymentMethods.add({'type': type, 'details': details});
                  } else {
                    profileController.paymentMethods[editIndex!] = {'type': type, 'details': details};
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(editIndex == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _deletePaymentMethod(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment Method'),
        content: const Text('Are you sure you want to delete this payment method?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              profileController.paymentMethods.removeAt(index);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Methods', style: theme.textTheme.displaySmall),
        centerTitle: true,
      ),
      body: Obx(() => Padding(
        padding: EdgeInsets.all(24.w),
        child: ListView.separated(
          itemCount: profileController.paymentMethods.length + 1,
          separatorBuilder: (_, __) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            if (index < profileController.paymentMethods.length) {
              final method = profileController.paymentMethods[index];
              Widget iconWidget;
              if (method['type'] == 'Credit Card') {
                iconWidget = Image.asset('assets/images/card1.png', width: 32, height: 22);
              } else if (method['type'] == 'Momo') {
                iconWidget = Icon(Icons.phone_android, color: theme.primaryColor, size: 28);
              } else if (method['type'] == 'PayPal') {
                iconWidget = Icon(Icons.account_balance_wallet, color: theme.primaryColor, size: 28);
              } else {
                iconWidget = Icon(Icons.payment, color: theme.primaryColor, size: 28);
              }
              return Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Row(
                  children: [
                    iconWidget,
                    16.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(method['type']!, style: theme.textTheme.titleMedium),
                          4.verticalSpace,
                          Text(method['details']!, style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: theme.primaryColor),
                      onPressed: () => _showPaymentDialog(initial: method, editIndex: index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deletePaymentMethod(index),
                    ),
                  ],
                ),
              );
            } else {
              // Add Payment Method button as footer
              return Padding(
                padding: EdgeInsets.only(top: 24.h),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showPaymentDialog(),
                    icon: Icon(Icons.add),
                    label: Text('Add Payment Method'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      )),
    );
  }
} 