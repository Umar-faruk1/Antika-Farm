import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  static final _ordersCollection = FirebaseFirestore.instance.collection('orders');

  // Add a new order
  static Future<void> addOrder(Map<String, dynamic> orderData) async {
    await _ordersCollection.add(orderData);
  }

  // Fetch all orders (optionally by userId)
  static Stream<QuerySnapshot<Map<String, dynamic>>> getOrders({String? userId}) {
    if (userId != null) {
      return _ordersCollection.where('userId', isEqualTo: userId).snapshots();
    }
    return _ordersCollection.snapshots();
  }

  // Update order status
  static Future<void> updateOrderStatus(String orderId, String status) async {
    await _ordersCollection.doc(orderId).update({'status': status});
  }

  // Delete an order (if needed)
  static Future<void> deleteOrder(String orderId) async {
    await _ordersCollection.doc(orderId).delete();
  }
} 