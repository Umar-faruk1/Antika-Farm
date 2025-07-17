import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/orders_controller.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Object? arg = Get.arguments;
    final String? orderId = arg is String ? arg : null;
    if (orderId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(child: Text('No order selected.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('orders').doc(orderId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !(snapshot.data?.exists ?? false)) {
            return const Center(child: Text('Order not found.'));
          }
          final data = snapshot.data?.data();
          if (data == null) {
            return const Center(child: Text('Order data is missing.'));
          }
          final items = (data['items'] as List<dynamic>? ?? []);
          return Padding(
            padding: EdgeInsets.all(24.w),
            child: ListView(
              children: [
                Text('Order ID: $orderId', style: Theme.of(context).textTheme.titleMedium),
                12.verticalSpace,
                Text('Status: ${data['status'] ?? '-'}', style: Theme.of(context).textTheme.bodyLarge),
                12.verticalSpace,
                Text('Date: ${_formatDate(data['date'])}', style: Theme.of(context).textTheme.bodyLarge),
                12.verticalSpace,
                Text('Customer: ${data['userName'] ?? '-'}', style: Theme.of(context).textTheme.bodyLarge),
                12.verticalSpace,
                Text('Address: ${data['address'] ?? '-'}', style: Theme.of(context).textTheme.bodyLarge),
                12.verticalSpace,
                Text('Payment Method: ${data['paymentMethod'] ?? '-'}', style: Theme.of(context).textTheme.bodyLarge),
                12.verticalSpace,
                Text('Total: GHS${(data['total'] as num?)?.toStringAsFixed(2) ?? '0.00'}', style: Theme.of(context).textTheme.bodyLarge),
                24.verticalSpace,
                Text('Items:', style: Theme.of(context).textTheme.titleMedium),
                ...items.map((item) {
                  final map = item is Map<String, dynamic> ? item : <String, dynamic>{};
                  final name = map['name'] ?? '-';
                  final quantity = map['quantity']?.toString() ?? '0';
                  final price = (map['price'] as num?)?.toStringAsFixed(2) ?? '0.00';
                  final imageUrl = map['image'] as String?;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (imageUrl != null && imageUrl.isNotEmpty && !imageUrl.contains('via.placeholder.com'))
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Image.network(
                              imageUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 40),
                            ),
                          ),
                        Expanded(
                          child: Text(name, style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis),
                        ),
                        Text('x$quantity', style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(width: 8),
                        Text('GHS$price', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      final d = date.toDate();
      return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }
    return '';
  }
} 