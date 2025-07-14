import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_home_view.dart';
import 'admin_products_view.dart';
import 'admin_categories_view.dart';
import 'admin_users_view.dart';
import 'admin_orders_view.dart';

class AdminBaseView extends StatefulWidget {
  const AdminBaseView({Key? key}) : super(key: key);

  @override
  State<AdminBaseView> createState() => _AdminBaseViewState();
}

class _AdminBaseViewState extends State<AdminBaseView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AdminHomeView(),
    const AdminProductsView(),
    const AdminCategoriesView(),
    const AdminUsersView(),
    const AdminOrdersView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
} 