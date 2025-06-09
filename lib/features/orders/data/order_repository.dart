import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sole_space_user1/features/orders/model/order_model.dart';

class OrderRepository {
  final firestore.FirebaseFirestore _firestore =
      firestore.FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Order>> getUserOrders() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('orders')
              .orderBy('createdAt', descending: true)
              .get();

      return snapshot.docs
          .map((doc) => Order.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  Future<void> createOrder(Order order) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .add(order.toFirestore());
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .doc(orderId)
          .update({'status': status});
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }
}
