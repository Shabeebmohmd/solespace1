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
            return Product.fromFirestore(doc.data(), doc.id);
          }).toList();
      return products;
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<List<Product>> fetchProductsByBrand(String brandId) async {
    log('Fetching Products for Brand ID: $brandId');
    try {
      final querySnapshot =
          await _firestore
              .collection('products')
              .where('brandId', isEqualTo: brandId)
              .get();
      final products =
          querySnapshot.docs
              .map((doc) => Product.fromFirestore(doc.data(), doc.id))
              .toList();
      return products;
    } catch (e) {
      throw Exception('Failed to fetch products for brand: $e');
    }
  }

  Future<List<Product>> fetchProductsByCategory(String categoryId) async {
    log('Fetching Products for Category ID: $categoryId');
    try {
      final querySnapshot =
          await _firestore
              .collection('products')
              .where('categoryId', isEqualTo: categoryId)
              .get();
      final products =
          querySnapshot.docs
              .map((doc) => Product.fromFirestore(doc.data(), doc.id))
              .toList();
      return products;
    } catch (e) {
      throw Exception('Failed to fetch products for brand: $e');
    }
  }
}
