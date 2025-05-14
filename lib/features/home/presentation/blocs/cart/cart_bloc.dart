import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/features/home/models/cart_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CartBloc() : super(CartLoading()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartQuantity>(_onUpdateCartQuantity);
  }
  double calculateTotal(List<CartItem> cartItems, double shipping) {
    return cartItems.fold(
      0,
      (totalSum, item) => totalSum + item.price * item.quantity + shipping,
    );
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      final user = _auth.currentUser;
      if (user == null) {
        emit(CartError('User not logged in'));
        return;
      }

      final snapshot =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .get();

      final cartItems =
          snapshot.docs
              .map((doc) => CartItem.fromFirestore(doc.data()))
              .toList();

      emit(CartLoaded(cartItems));
    } catch (e) {
      emit(CartError('Failed to load cart: $e'));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(CartError('User not logged in'));
        return;
      }

      final cartRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(event.cartItem.productId);

      await cartRef.set(event.cartItem.toFirestore());
      add(LoadCart()); // Reload cart after adding
    } catch (e) {
      emit(CartError('Failed to add to cart: $e'));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(CartError('User not logged in'));
        return;
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(event.productId)
          .delete();

      add(LoadCart()); // Reload cart after removing
    } catch (e) {
      emit(CartError('Failed to remove from cart: $e'));
    }
  }

  Future<void> _onUpdateCartQuantity(
    UpdateCartQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(CartError('User not logged in'));
        return;
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(event.productId)
          .update({'quantity': event.quantity});

      add(LoadCart()); // Reload cart after updating
    } catch (e) {
      emit(CartError('Failed to update cart: $e'));
    }
  }
}
