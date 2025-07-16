import 'package:flutter/material.dart';
import '../../../utils/dummy_helper.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use dummy data directly for dashboard metrics
    final products = DummyHelper.products;
    final categories = DummyHelper.categories;
    final users = [
      {'id': 1, 'name': 'John Doe', 'email': 'john@example.com', 'role': 'Customer'},
      {'id': 2, 'name': 'Jane Smith', 'email': 'jane@example.com', 'role': 'Customer'},
      {'id': 3, 'name': 'Admin User', 'email': 'admin@example.com', 'role': 'Admin'},
    ];
    final orders = [
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
    final totalSales = orders.fold<double>(0.0, (sum, o) => sum + ((o['total'] as num?)?.toDouble() ?? 0.0));

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Admin Dashboard',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _DashboardCard(title: 'Products', value: products.length.toString(), icon: Icons.shopping_bag),
                _DashboardCard(title: 'Categories', value: categories.length.toString(), icon: Icons.category),
                _DashboardCard(title: 'Users', value: users.length.toString(), icon: Icons.people),
                _DashboardCard(title: 'Orders', value: orders.length.toString(), icon: Icons.receipt_long),
                _DashboardCard(title: 'Total Revenue', value: 'GHS${totalSales.toStringAsFixed(2)}', icon: Icons.attach_money),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _DashboardCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
} 