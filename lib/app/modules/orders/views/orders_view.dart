import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../components/custom_icon_button.dart';
import '../../../components/no_data.dart';
import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({Key? key}) : super(key: key);

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
              Text('My Orders', style: theme.textTheme.displaySmall),
              const Opacity(
                opacity: 0.0,
                child: CustomIconButton(onPressed: null, icon: Center()),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.orders.isEmpty) {
          return const NoData(text: 'No Orders Yet!');
        }
        
        return ListView.separated(
          padding: EdgeInsets.all(24.w),
          separatorBuilder: (_, index) => 16.verticalSpace,
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return _buildOrderCard(order, theme);
          },
        );
      }),
    );
  }

  Widget _buildOrderCard(Order order, ThemeData theme) {
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
            // match calendar_view.dart
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
            children: [
              Expanded(
                child: Text(
                  'Total: GHS${order.total.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
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