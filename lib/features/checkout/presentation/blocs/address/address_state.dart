// address_state.dart
import 'package:equatable/equatable.dart';
import 'package:sole_space_user1/features/checkout/data/model/address_model.dart';

abstract class AddressState extends Equatable {
  const AddressState();
  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<AddressModel> addresses;
  const AddressLoaded(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

class AddressError extends AddressState {
  final String message;
  const AddressError({required this.message});
}
