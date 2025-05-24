part of 'product_details_bloc.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object?> get props => [];
}

class SelectSize extends ProductDetailsEvent {
  final String size;

  const SelectSize(this.size);

  @override
  List<Object?> get props => [size];
}

class SelectColor extends ProductDetailsEvent {
  final String color;

  const SelectColor(this.color);

  @override
  List<Object?> get props => [color];
}

class UpdateQuantity extends ProductDetailsEvent {
  final int quantity;

  const UpdateQuantity(this.quantity);

  @override
  List<Object?> get props => [quantity];
}
