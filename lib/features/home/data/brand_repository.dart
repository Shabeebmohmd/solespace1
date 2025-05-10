import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sole_space_user1/features/home/models/brand_model.dart';

class BrandRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
