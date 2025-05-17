import 'package:equatable/equatable.dart';
import 'package:sole_space_user1/features/checkout/data/model/address_model.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();
  @override
  List<Object?> get props => [];
}

class LoadAddresses extends AddressEvent {
  final String userId;
  const LoadAddresses(this.userId);
  @override
  List<Object?> get props => [userId];
}

class AddAddress extends AddressEvent {
  final String userId;
  final AddressModel address;
  const AddAddress(this.userId, this.address);
}

class UpdateAddress extends AddressEvent {
  final String userId;
  final AddressModel address;
  const UpdateAddress({required this.userId, required this.address});
}

class DeleteAddress extends AddressEvent {
  final String userId;
  final String addressId;
  const DeleteAddress({required this.userId, required this.addressId});
}

class SelectAddress extends AddressEvent {
  final String addressId;
  const SelectAddress({required this.addressId});
  @override
  List<Object> get props => [addressId];
}
