import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sole_space_user1/features/home/models/category_model.dart';

class CategoryRepsitory {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<Category>> fetchCategory() async {
    try {
      final querySnapshot = await _firestore.collection('categories').get();
      final category =
          querySnapshot.docs
              .map((doc) => Category.fromFirestore(doc.data(), doc.id))
              .toList();
      return category;
    } catch (e) {
      throw Exception('Failed to fetch category: $e');
    }
  }
}
