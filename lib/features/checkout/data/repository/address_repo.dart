// address_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sole_space_user1/features/checkout/data/model/address_model.dart';

class AddressRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AddressModel>> getAddresses(String userId) async {
    final snapshot =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('addresses')
            .get();
    return snapshot.docs
        .map((doc) => AddressModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> addAddress(String userId, AddressModel address) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .add(address.toMap());
  }

  Future<void> updateAddress(String userId, AddressModel address) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(address.id)
        .update(address.toMap());
  }

  Future<void> deleteAddress(String userId, String addressId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(addressId)
        .delete();
  }

  Future<void> selectAddress(String userId, String addressId) async {
    final snapshot =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('addresses')
            .get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isSelected': doc.id == addressId});
    }
    await batch.commit();
  }
}
