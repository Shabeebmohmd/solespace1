part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> data;
  const ProductLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

class ProductError extends ProductState {
  final String message;
  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}
