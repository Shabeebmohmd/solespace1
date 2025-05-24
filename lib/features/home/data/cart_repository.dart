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
    final user = auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    final cartRef = firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(cartItem.productId);
    await cartRef.set(cartItem.toFirestore());
  }

  Future<void> removeFromCart(String productId) async {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(productId)
        .delete();
  }

  Future<void> updateCartQuantity(String productId, int quantity) async {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(productId)
        .update({'quantity': quantity});
  }
}
