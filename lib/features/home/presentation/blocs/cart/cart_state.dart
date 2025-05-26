part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {
  final List<CartItem> cartItems;

  const CartLoading({this.cartItems = const []});

  @override
  List<Object> get props => [cartItems];
}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;

  const CartLoaded(this.cartItems);

  @override
  List<Object> get props => [cartItems];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}
