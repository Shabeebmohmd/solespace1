import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/features/home/data/cart_repository.dart';
import 'package:sole_space_user1/features/home/models/cart_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;
  CartBloc({required this.cartRepository}) : super(CartLoading()) {
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

  double calculateSubTotal(List<CartItem> cartItems) {
    return cartItems.fold(
      0,
      (totalSum, item) => totalSum + item.price * item.quantity,
    );
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      final cartItems = await cartRepository.fetchCartItems();
      emit(CartLoaded(cartItems));
    } catch (e) {
      emit(CartError('Failed to load cart: $e'));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      await cartRepository.addToCart(event.cartItem);
      add(LoadCart());
    } catch (e) {
      emit(CartError('Failed to add to cart: $e'));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await cartRepository.removeFromCart(event.productId);
      add(LoadCart());
    } catch (e) {
      emit(CartError('Failed to remove from cart: $e'));
    }
  }

  Future<void> _onUpdateCartQuantity(
    UpdateCartQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      await cartRepository.updateCartQuantity(event.productId, event.quantity);
      add(LoadCart());
    } catch (e) {
      emit(CartError('Failed to update cart: $e'));
    }
  }
}
