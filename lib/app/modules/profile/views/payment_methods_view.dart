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
  final ProfileController profileController = Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>()
      : Get.put(ProfileController());

  void _showPaymentDialog({Map<String, String>? initial, int? editIndex}) {
    final typeController = TextEditingController(text: initial?['type'] ?? '');
    final detailsController = TextEditingController(text: initial?['details'] ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(editIndex == null ? 'Add Payment Method' : 'Edit Payment Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: typeController,
              decoration: const InputDecoration(hintText: 'Type (e.g. Credit Card, PayPal)'),
            ),
            16.verticalSpace,
            TextField(
              controller: detailsController,
              decoration: const InputDecoration(hintText: 'Details (e.g. **** **** **** 1234)'),
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
              final type = typeController.text.trim();
              final details = detailsController.text.trim();
              if (type.isNotEmpty && details.isNotEmpty) {
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
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(() => ListView.separated(
                itemCount: profileController.paymentMethods.length,
                separatorBuilder: (_, __) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final method = profileController.paymentMethods[index];
                  return Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.payment, color: theme.primaryColor),
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
                },
              )),
            ),
            24.verticalSpace,
            SizedBox(
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
          ],
        ),
      ),
    );
  }
} 