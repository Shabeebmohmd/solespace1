part of 'product_details_bloc.dart';

class ProductDetailsState extends Equatable {
  final String? selectedSize;
  final String? selectedColor;
  final int quantity;

  const ProductDetailsState({
    this.selectedSize,
    this.selectedColor,
    this.quantity = 1,
  });

  ProductDetailsState copyWith({
    String? selectedSize,
    String? selectedColor,
    int? quantity,
  }) {
    return ProductDetailsState(
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [selectedSize, selectedColor, quantity];
}
