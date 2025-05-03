import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sole_space_user1/features/home/models/product_model.dart';

class ProductRepsitory {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<Product>> fetchProducts() async {
    log('Fetching Product');
    try {
      final querySnapshot = await _firestore.collection('products').get();
      final products =
          querySnapshot.docs.map((doc) {
            log(
              'Product data: ${doc.data()}',
            ); // Log the raw Firestore document data
            return Product.fromFirestore(doc.data(), doc.id);
          }).toList();
      return products;
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }
}
