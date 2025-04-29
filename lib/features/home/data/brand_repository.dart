// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:sole_space_user1/features/home/models/brand_model.dart';

// class BrandRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<Map<String, dynamic>>> fetchCategories() async {
//     try {
//       final querySnapshot = await _firestore.collection('categories').get();
//       return querySnapshot.docs.map((doc) => doc.data()).toList();
//     } catch (e) {
//       throw Exception('Failed to fetch categories: $e');
//     }
//   }

//   Future<List<Brand>> fetchBrands() async {
//     try {
//       final querySnapshot = await _firestore.collection('brands').get();
//       final brands =
//           querySnapshot.docs.map((doc) => Brand.fromJson(doc.data())).toList();
//       return brands;
//     } catch (e) {
//       throw Exception('Failed to fetch brands: $e');
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sole_space_user1/features/home/models/brand_model.dart';

class BrandRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final querySnapshot = await _firestore.collection('categories').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<List<Brand>> fetchBrands() async {
    try {
      final querySnapshot = await _firestore.collection('brands').get();
      final brands =
          querySnapshot.docs
              .map((doc) => Brand.fromFirestore(doc.data(), doc.id))
              .toList();
      return brands;
    } catch (e) {
      throw Exception('Failed to fetch brands: $e');
    }
  }
}
