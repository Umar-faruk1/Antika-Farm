import 'package:flutter/material.dart';
import '../../../utils/dummy_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Remove dummy data, use Firestore for all metrics
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
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('products').snapshots(),
                  builder: (context, snapshot) {
                    final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                    return _DashboardCard(title: 'Products', value: count.toString(), icon: Icons.shopping_bag);
                  },
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                  builder: (context, snapshot) {
                    final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                    return _DashboardCard(title: 'Categories', value: count.toString(), icon: Icons.category);
                  },
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                    return _DashboardCard(title: 'Users', value: count.toString(), icon: Icons.people);
                  },
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('orders').snapshots(),
                  builder: (context, snapshot) {
                    int orderCount = 0;
                    double totalSales = 0.0;
                    if (snapshot.hasData) {
                      orderCount = snapshot.data!.docs.length;
                      totalSales = snapshot.data!.docs.fold(0.0, (sum, doc) {
                        final data = doc.data();
                        return sum + ((data['total'] as num?)?.toDouble() ?? 0.0);
                      });
                    }
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _DashboardCard(title: 'Orders', value: orderCount.toString(), icon: Icons.receipt_long),
                        _DashboardCard(title: 'Total Revenue', value: 'GHS${totalSales.toStringAsFixed(2)}', icon: Icons.attach_money),
                      ],
                    );
                  },
                ),
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