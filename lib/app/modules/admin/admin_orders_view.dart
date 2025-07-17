import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/order_service.dart';

class AdminOrdersView extends StatefulWidget {
  const AdminOrdersView({Key? key}) : super(key: key);

  @override
  State<AdminOrdersView> createState() => _AdminOrdersViewState();
}

class _AdminOrdersViewState extends State<AdminOrdersView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders', style: theme.textTheme.displaySmall),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: OrderService.getOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No orders found.'));
            }
            final orders = snapshot.data!.docs;
            return ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final order = orders[index].data();
                final orderId = orders[index].id;
                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _getStatusColor(order['status']).withOpacity(0.1),
                        child: Icon(Icons.receipt_long, color: _getStatusColor(order['status'])),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order #$orderId', style: theme.textTheme.titleMedium),
                            4.verticalSpace,
                            Text('Customer: ${order['userName'] ?? ''}', style: theme.textTheme.bodySmall),
                            4.verticalSpace,
                            Text('Date: ${_formatDate(order['date'])}', style: theme.textTheme.bodySmall),
                            4.verticalSpace,
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order['status']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: _getStatusColor(order['status'])),
                              ),
                              child: DropdownButton<String>(
                                value: order['status'],
                                underline: const SizedBox(),
                                items: ['Pending', 'Processing', 'Delivered', 'Cancelled']
                                    .map((status) => DropdownMenuItem(
                                          value: status,
                                          child: Text(status),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    OrderService.updateOrderStatus(orderId, val);
                                  }
                                },
                              ),
                            ),
                            4.verticalSpace,
                            Text('Total: GHS${(order['total'] as num?)?.toStringAsFixed(2) ?? '0.00'}', style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      final d = date.toDate();
      return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }
    return '';
  }
} 