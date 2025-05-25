import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/utils/snack_bar_utils.dart';
import 'package:sole_space_user1/features/checkout/data/model/address_model.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_bloc.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_event.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_state.dart';
import 'package:sole_space_user1/features/checkout/presentation/widgets/address/address_form.dart';

class EditAddressPage extends StatelessWidget {
  final AddressModel addressModel;
  const EditAddressPage({super.key, required this.addressModel});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final formKey = GlobalKey<FormState>();
    final fullNameController = TextEditingController(
      text: addressModel.fullName,
    );
    final addressController = TextEditingController(text: addressModel.address);
    final cityController = TextEditingController(text: addressModel.city);
    final stateController = TextEditingController(text: addressModel.state);
    final postalCodeController = TextEditingController(
      text: addressModel.postalCode,
    );
    final phoneNumberController = TextEditingController(
      text: addressModel.phoneNumber,
    );

    void submitForm() {
      if (formKey.currentState!.validate()) {
        final updatedAddress = AddressModel(
          id: addressModel.id,
          fullName: fullNameController.text,
          address: addressController.text,
          city: cityController.text,
          state: stateController.text,
          postalCode: postalCodeController.text,
          phoneNumber: phoneNumberController.text,
          isSelected: addressModel.isSelected,
        );
        context.read<AddressBloc>().add(
          UpdateAddress(userId: user!.uid, address: updatedAddress),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Address')),
      body: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressLoaded) {
            Navigator.pop(context);
            SnackbarUtils.showSnackbar(
              context: context,
              message: 'Address updated successfully',
            );
          } else if (state is AddressError) {
            SnackbarUtils.showSnackbar(
              context: context,
              message: state.message,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AddressForm(
            formKey: formKey,
            fullNameController: fullNameController,
            cityController: cityController,
            stateController: stateController,
            postalCodeController: postalCodeController,
            phoneNumberController: phoneNumberController,
            addressController: addressController,
            onSubmit: submitForm,
            isLoading: context.watch<AddressBloc>().state is AddressLoading,
            submitButtonText: 'Save Changes',
          ),
        ),
      ),
    );
  }
}
