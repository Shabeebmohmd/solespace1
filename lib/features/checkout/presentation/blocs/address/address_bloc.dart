// address_bloc.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/features/checkout/data/model/address_model.dart';
import 'package:sole_space_user1/features/checkout/data/repository/address_repo.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository addressRepository;
  final user = FirebaseAuth.instance.currentUser;

  AddressBloc({required this.addressRepository}) : super(AddressInitial()) {
    on<LoadAddresses>(_onLoad);
    on<AddAddress>(_onAddAddress);
    on<UpdateAddress>(_onUpdate);
    on<DeleteAddress>(_onDelete);
    on<SelectAddress>(_onSelectAddress);
    add(LoadAddresses(user!.uid));
  }

  Future<void> _onLoad(event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    try {
      final addresses = await addressRepository.getAddresses(event.userId);
      emit(AddressLoaded(addresses));
    } catch (e) {
      emit(AddressError(message: 'Failed to load addresses'));
    }
  }

  Future<void> _onAddAddress(
    AddAddress event,
    Emitter<AddressState> emit,
  ) async {
    try {
      if (user == null) {
        emit(AddressError(message: 'User not logged in'));
        return;
      }
      // Check if there are other addresses
      final existingAddresses = await addressRepository.getAddresses(user!.uid);
      // Set isSelected to true if no other addresses exist
      final newAddress = AddressModel(
        id: event.address.id,
        fullName: event.address.fullName,
        address: event.address.address,
        city: event.address.city,
        state: event.address.state,
        postalCode: event.address.postalCode,
        phoneNumber: event.address.phoneNumber,
        isSelected:
            existingAddresses
                .isEmpty, // Set isSelected to true if no other addresses
      );
      await addressRepository.addAddress(user!.uid, newAddress);
      // If the new address is selected, unselect others
      if (newAddress.isSelected) {
        await addressRepository.selectAddress(user!.uid, newAddress.id);
      }
      add(LoadAddresses(user!.uid));
    } catch (e) {
      emit(AddressError(message: 'Failed to add address: $e'));
    }
  }

  Future<void> _onUpdate(
    UpdateAddress event,
    Emitter<AddressState> emit,
  ) async {
    await addressRepository.updateAddress(event.userId, event.address);
    add(LoadAddresses(event.userId));
  }

  Future<void> _onDelete(
    DeleteAddress event,
    Emitter<AddressState> emit,
  ) async {
    await addressRepository.deleteAddress(event.userId, event.addressId);
    add(LoadAddresses(event.userId));
  }

  Future<void> _onSelectAddress(
    SelectAddress event,
    Emitter<AddressState> emit,
  ) async {
    try {
      if (user == null) {
        emit(AddressError(message: 'User not logged in'));
        return;
      }
      await addressRepository.selectAddress(user!.uid, event.addressId);
      add(LoadAddresses(user!.uid));
    } catch (e) {
      emit(AddressError(message: 'Failed to select address: $e'));
    }
  }
}
