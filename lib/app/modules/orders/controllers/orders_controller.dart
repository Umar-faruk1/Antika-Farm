import 'package:get/get.dart';

class Order {
  final String id;
  final String status;
  final double total;
  final String date;
  final List<String> items;

  Order({
    required this.id,
    required this.status,
    required this.total,
    required this.date,
    required this.items,
  });
}

class OrdersController extends GetxController {
  final orders = <Order>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  void loadOrders() {
    isLoading.value = true;
    
    // Simulate loading orders
    Future.delayed(const Duration(seconds: 1), () {
      orders.value = [
        Order(
          id: 'ORD-001',
          status: 'Delivered',
          total: 45.99,
          date: '2024-01-15',
          items: ['Tomatoes', 'Carrots', 'Spinach'],
        ),
        Order(
          id: 'ORD-002',
          status: 'In Transit',
          total: 32.50,
          date: '2024-01-16',
          items: ['Bell Pepper', 'Cabbage', 'Ginger'],
        ),
        Order(
          id: 'ORD-003',
          status: 'Processing',
          total: 28.75,
          date: '2024-01-17',
          items: ['Lamb Meat', 'Pumpkin'],
        ),
      ];
      isLoading.value = false;
    });
  }

  void viewOrderDetails(String orderId) {
    // Navigate to order details page
    Get.toNamed('/order-details', arguments: orderId);
  }
} 