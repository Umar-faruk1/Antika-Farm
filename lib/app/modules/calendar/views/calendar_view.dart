import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/calendar_controller.dart';
import '../../orders/controllers/orders_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final OrdersController ordersController = Get.put(OrdersController());
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders', style: theme.textTheme.displaySmall),
        centerTitle: true,
      ),
      body: Obx(() {
        if (ordersController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ordersController.orders.isEmpty) {
          return const Center(child: Text('No Orders Yet!'));
        }
        return ListView.separated(
          padding: EdgeInsets.all(24.w),
          separatorBuilder: (_, __) => SizedBox(height: 16.h),
          itemCount: ordersController.orders.length,
          itemBuilder: (context, index) {
            final order = ordersController.orders[index];
            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Order #${order.id}',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          order.status,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _getStatusColor(order.status),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  8.verticalSpace,
                  Text(
                    'Date: ${order.date}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                  8.verticalSpace,
                  Text('Items:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(child: Text(item['name'] ?? '', style: theme.textTheme.bodyMedium, overflow: TextOverflow.ellipsis)),
                        Text('x${item['quantity']}', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  )).toList(),
                  12.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: GHS${order.total.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed('/order-details', arguments: order.id),
                        child: Text(
                          'View Details',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'in transit':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}