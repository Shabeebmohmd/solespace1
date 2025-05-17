// address_model.dart
import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String id;
  final String fullName;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String phoneNumber;
  final bool isSelected;

  const AddressModel({
    required this.id,
    required this.fullName,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.phoneNumber,
    this.isSelected = false,
  });

  factory AddressModel.fromMap(String id, Map<String, dynamic> map) {
    return AddressModel(
      id: id,
      fullName: map['fullName'],
      address: map['address'],
      city: map['city'],
      state: map['state'],
      postalCode: map['postalCode'],
      phoneNumber: map['phoneNumber'],
      isSelected: map['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'address': address,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'phoneNumber': phoneNumber,
      'isSelected': isSelected,
    };
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    address,
    city,
    state,
    postalCode,
    phoneNumber,
    isSelected,
  ];
}
