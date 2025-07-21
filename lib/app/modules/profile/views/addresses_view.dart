import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class AddressesView extends StatefulWidget {
  const AddressesView({Key? key}) : super(key: key);

  @override
  State<AddressesView> createState() => _AddressesViewState();
}

class _AddressesViewState extends State<AddressesView> {
  final ProfileController profileController = Get.find<ProfileController>();

  void _showAddressDialog({String? initial, int? editIndex}) {
    profileController.addressController.text = initial ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(editIndex == null ? 'Add Address' : 'Edit Address'),
        content: TextField(
          controller: profileController.addressController,
          decoration: const InputDecoration(hintText: 'Enter address'),
          autofocus: true,
          minLines: 1,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = profileController.addressController.text.trim();
              if (text.isNotEmpty) {
                if (editIndex == null) {
                  profileController.addresses.add(text);
                } else {
                  profileController.addresses[editIndex!] = text;
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

  void _deleteAddress(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              profileController.addresses.removeAt(index);
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
        title: Text('Addresses', style: theme.textTheme.displaySmall),
        centerTitle: true,
      ),
      body: Obx(() => Padding(
        padding: EdgeInsets.all(24.w),
        child: ListView.separated(
          itemCount: profileController.addresses.length + 1,
          separatorBuilder: (_, __) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            if (index < profileController.addresses.length) {
              final address = profileController.addresses[index];
              return Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: theme.primaryColor),
                    16.horizontalSpace,
                    Expanded(
                      child: Text(address, style: theme.textTheme.bodyLarge),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: theme.primaryColor),
                      onPressed: () => _showAddressDialog(initial: address, editIndex: index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteAddress(index),
                    ),
                  ],
                ),
              );
            } else {
              // Add Address button as footer
              return Padding(
                padding: EdgeInsets.only(top: 24.h),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddressDialog(),
                    icon: Icon(Icons.add),
                    label: Text('Add Address'),
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