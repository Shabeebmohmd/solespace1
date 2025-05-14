import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String productId;
  final String imageUrl;
  final String name; // Optional: for display purposes
  final double price;
  final int quantity;

  const CartItem({
    required this.productId,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
  });

  // Convert Firestore document to CartItem
  factory CartItem.fromFirestore(Map<String, dynamic> data) {
    return CartItem(
      productId: data['productId'] as String,
      imageUrl: data['imageUrl'] as String,
      name: data['name'] as String? ?? '',
      price: (data['price'] as num).toDouble(),
      quantity: data['quantity'] as int,
    );
  }

  // Convert CartItem to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'quantity': quantity,
      'addedAt': DateTime.now(),
    };
  }

  @override
  List<Object> get props => [productId, imageUrl, name, price, quantity];
}
