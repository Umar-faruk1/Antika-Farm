import 'package:get/get.dart';
import '../../../data/order_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/controllers/auth_controller.dart';

class Order {
  final String id;
  final String status;
  final double total;
  final DateTime date;
  final List<dynamic> items;
  final String address;
  final String paymentMethod;
  final String userName;

  Order({
    required this.id,
    required this.status,
    required this.total,
    required this.date,
    required this.items,
    required this.address,
    required this.paymentMethod,
    required this.userName,
  });

  factory Order.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      status: data['status'] ?? '',
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      date: (data['date'] as Timestamp).toDate(),
      items: data['items'] ?? [],
      address: data['address'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      userName: data['userName'] ?? '',
    );
  }
}

class OrdersController extends GetxController {
  final orders = <Order>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() {
    isLoading.value = true;
    final authController = Get.find<AuthController>();
    final user = authController.currentUser;
    OrderService.getOrders(userId: user?.uid).listen((snapshot) {
      orders.value = snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();
      isLoading.value = false;
    });
  }

  void viewOrderDetails(String orderId) {
    // Navigate to order details page
    Get.toNamed('/order-details', arguments: orderId);
  }
} 