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
      final currentItems =
          state is CartLoading
              ? (state as CartLoading).cartItems
              : <CartItem>[];
      emit(CartLoading(cartItems: currentItems));
      final cartItems = await cartRepository.fetchCartItems();
      emit(CartLoaded(cartItems));
    } catch (e) {
      emit(CartError('Failed to load cart: $e'));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      final currentItems =
          state is CartLoading
              ? (state as CartLoading).cartItems
              : <CartItem>[];
      emit(CartLoading(cartItems: currentItems));
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
      final currentItems =
          state is CartLoading
              ? (state as CartLoading).cartItems
              : <CartItem>[];
      final updatedItems =
          currentItems
              .where(
                (item) => '${item.productId}_${item.size}' != event.productId,
              )
              .toList();
      emit(CartLoading(cartItems: updatedItems));
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
      final currentItems =
          state is CartLoading
              ? (state as CartLoading).cartItems
              : <CartItem>[];
      final updatedItems =
          currentItems.map((item) {
            if ('${item.productId}_${item.size}' == event.productId) {
              return CartItem(
                productId: item.productId,
                name: item.name,
                price: item.price,
                quantity: event.quantity,
                size: item.size,
                // color: item.color,
                imageUrl: item.imageUrl,
              );
            }
            return item;
          }).toList();
      emit(CartLoading(cartItems: updatedItems));
      await cartRepository.updateCartQuantity(event.productId, event.quantity);
      add(LoadCart());
    } catch (e) {
      emit(CartError('Failed to update cart: $e'));
    }
  }
}
