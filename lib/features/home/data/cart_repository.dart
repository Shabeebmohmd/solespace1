import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sole_space_user1/features/home/models/cart_model.dart';

class CartRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CartRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : firestore = firestore ?? FirebaseFirestore.instance,
      auth = auth ?? FirebaseAuth.instance;

  Future<List<CartItem>> fetchCartItems() async {
    log('fetching cart items');
    final user = auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    final snapshot =
        await firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .get();
    return snapshot.docs
        .map((doc) => CartItem.fromFirestore(doc.data()))
        .toList();
  }

  Future<void> addToCart(CartItem cartItem) async {
    log('adding to cart');
    final user = auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    // Create a unique ID for the cart item that includes size and color
    final cartItemId =
        '${cartItem.productId}_${cartItem.size}_${cartItem.color}';

    final cartRef = firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(cartItemId);

    // Check if the item already exists
    final existingDoc = await cartRef.get();
    if (existingDoc.exists) {
      // If it exists, update the quantity
      final existingItem = CartItem.fromFirestore(existingDoc.data()!);
      await cartRef.update({
        'quantity': existingItem.quantity + cartItem.quantity,
      });
    } else {
      // If it doesn't exist, add it as a new item
      await cartRef.set(cartItem.toFirestore());
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    log('removing from cart');
    final user = auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(cartItemId)
        .delete();
  }

  Future<void> updateCartQuantity(String cartItemId, int quantity) async {
    log('updating cart');
    final user = auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(cartItemId)
        .update({'quantity': quantity});
  }
}
