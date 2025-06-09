import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sole_space_user1/features/home/models/cart_model.dart';

class Order extends Equatable {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double total;
  final String status;
  final DateTime createdAt;
  final String paymentIntentId;
  final String addressId;
  final String fullName;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String phoneNumber;
  final String? trackingNumber;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.paymentIntentId,
    required this.addressId,
    required this.fullName,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.phoneNumber,
    this.trackingNumber,
  });

  factory Order.fromFirestore(Map<String, dynamic> data, String id) {
    return Order(
      id: id,
      userId: data['userId'] as String,
      items:
          (data['items'] as List)
              .map(
                (item) => CartItem.fromFirestore(item as Map<String, dynamic>),
              )
              .toList(),
      total: (data['total'] as num).toDouble(),
      status: data['status'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      paymentIntentId: data['paymentIntentId'] as String,
      addressId: data['addressId'] as String,
      fullName: data['fullName'] as String,
      address: data['address'] as String,
      city: data['city'] as String,
      state: data['state'] as String,
      postalCode: data['postalCode'] as String,
      phoneNumber: data['phoneNumber'] as String,
      trackingNumber: data['trackingNumber'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toFirestore()).toList(),
      'total': total,
      'status': status,
      'createdAt': createdAt,
      'paymentIntentId': paymentIntentId,
      'addressId': addressId,
      'fullName': fullName,
      'address': address,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'phoneNumber': phoneNumber,
      'trackingNumber': trackingNumber,
    };
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    items,
    total,
    status,
    createdAt,
    paymentIntentId,
    addressId,
    fullName,
    address,
    city,
    state,
    postalCode,
    phoneNumber,
    trackingNumber,
  ];
}
