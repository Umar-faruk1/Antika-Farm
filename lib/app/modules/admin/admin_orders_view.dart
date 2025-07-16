import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminOrdersView extends StatefulWidget {
  const AdminOrdersView({Key? key}) : super(key: key);

  @override
  State<AdminOrdersView> createState() => _AdminOrdersViewState();
}

class _AdminOrdersViewState extends State<AdminOrdersView> {
  List<Map<String, dynamic>> _orders = [
    {
      'id': 1,
      'customer': 'John Doe',
      'items': [
        {'name': 'Tomatoes', 'quantity': 2, 'price': 5.99, 'category': 'Vegetables'},
        {'name': 'Carrots', 'quantity': 1, 'price': 3.99, 'category': 'Vegetables'},
      ],
      'total': 15.97,
      'status': 'Pending',
      'date': '2024-01-15',
    },
    {
      'id': 2,
      'customer': 'Jane Smith',
      'items': [
        {'name': 'Lamb Meat', 'quantity': 1, 'price': 25.99, 'category': 'Livestock'},
      ],
      'total': 25.99,
      'status': 'Delivered',
      'date': '2024-01-14',
    },
  ];
  
  List<Map<String, dynamic>> get orders => _orders;

  void _showOrderDialog({Map<String, dynamic>? initial, int? editIndex}) {
    final customerController = TextEditingController(text: initial?['customer'] ?? '');
    final totalController = TextEditingController(text: initial?['total']?.toString() ?? '');
    final dateController = TextEditingController(text: initial?['date'] ?? '');
    String selectedStatus = initial?['status'] ?? 'Pending';
    final isEdit = editIndex != null;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(editIndex == null ? 'Add Order' : 'Edit Order'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isEdit) ...[
                  TextField(
                    controller: customerController,
                    decoration: const InputDecoration(hintText: 'Customer Name'),
                  ),
                  16.verticalSpace,
                  TextField(
                    controller: totalController,
                    decoration: const InputDecoration(hintText: 'Total Amount'),
                    keyboardType: TextInputType.number,
                  ),
                  16.verticalSpace,
                  TextField(
                    controller: dateController,
                    decoration: const InputDecoration(hintText: 'Date (YYYY-MM-DD)'),
                  ),
                  16.verticalSpace,
                ],
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items: ['Pending', 'Processing', 'Delivered', 'Cancelled'].map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  )).toList(),
                  onChanged: (val) => setDialogState(() => selectedStatus = val ?? selectedStatus),
                  decoration: const InputDecoration(hintText: 'Status'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (isEdit) {
                  setState(() {
                    _orders[editIndex!] = {
                      'id': _orders[editIndex!]['id'],
                      'customer': _orders[editIndex!]['customer'],
                      'items': _orders[editIndex!]['items'],
                      'total': _orders[editIndex!]['total'],
                      'status': selectedStatus,
                      'date': _orders[editIndex!]['date'],
                    };
                  });
                  Navigator.pop(context);
                } else {
                  final customer = customerController.text.trim();
                  final total = double.tryParse(totalController.text.trim()) ?? 0.0;
                  final date = dateController.text.trim();
                  if (customer.isNotEmpty && date.isNotEmpty) {
                    setState(() {
                      _orders.add({
                        'id': _orders.length + 1,
                        'customer': customer,
                        'items': [
                          {'name': 'Sample Item', 'quantity': 1, 'price': total, 'category': 'General'},
                        ],
                        'total': total,
                        'status': selectedStatus,
                        'date': date,
                      });
                    });
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(editIndex == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteOrder(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Order'),
        content: const Text('Are you sure you want to delete this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                orders.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
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
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: orders.length,
                separatorBuilder: (_, __) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final order = orders[index];
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
                              Text('Order #${order['id']}', style: theme.textTheme.titleMedium),
                              4.verticalSpace,
                              Text('Customer: ${order['customer']}', style: theme.textTheme.bodySmall),
                              4.verticalSpace,
                              Text('Date: ${order['date']}', style: theme.textTheme.bodySmall),
                              4.verticalSpace,
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(order['status']).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: _getStatusColor(order['status'])),
                                ),
                                child: Text(
                                  order['status'],
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: _getStatusColor(order['status']),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              4.verticalSpace,
                              Text('Total: GHS${order['total'].toStringAsFixed(2)}', style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: theme.primaryColor),
                          onPressed: () => _showOrderDialog(initial: order, editIndex: index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteOrder(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            24.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showOrderDialog(),
                icon: Icon(Icons.add),
                label: Text('Add Order'),
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