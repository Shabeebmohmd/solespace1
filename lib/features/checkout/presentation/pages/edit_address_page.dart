import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/utils/snack_bar_utils.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/utils/validate_utils.dart';
import 'package:sole_space_user1/core/widgets/custom_text_field.dart';
import 'package:sole_space_user1/features/checkout/data/model/address_model.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_bloc.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_event.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_state.dart';

class EditAddressPage extends StatelessWidget {
  final AddressModel addressModel;
  const EditAddressPage({super.key, required this.addressModel});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // Form key and controllers
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

    // Form submission logic
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
            // Address updated successfully, navigate back
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
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                _nameField(fullNameController),
                mediumSpacing,
                _cityField(cityController),
                mediumSpacing,
                _stateField(stateController),
                mediumSpacing,
                _postalField(postalCodeController),
                mediumSpacing,
                _phoneField(phoneNumberController),
                mediumSpacing,
                _addressField(addressController),
                extraMediumSpacing,
                BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is AddressLoading ? null : submitForm,
                      child:
                          state is AddressLoading
                              ? const CircularProgressIndicator()
                              : const Text('Save Changes'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomTextField _nameField(TextEditingController fullNameController) {
    return CustomTextField(
      controller: fullNameController,
      label: 'Full name',
      validator:
          (value) => ValidationUtils.validateRequired(value, 'Full name'),
    );
  }

  CustomTextField _cityField(TextEditingController cityController) {
    return CustomTextField(
      controller: cityController,
      label: 'City',
      validator: (value) => ValidationUtils.validateRequired(value, 'City'),
    );
  }

  CustomTextField _stateField(TextEditingController stateController) {
    return CustomTextField(
      controller: stateController,
      label: 'State/Province',
      validator:
          (value) => ValidationUtils.validateRequired(value, 'State/Province'),
    );
  }

  CustomTextField _postalField(TextEditingController postalCodeController) {
    return CustomTextField(
      controller: postalCodeController,
      keyboardType: TextInputType.number,
      label: 'Postal code',
      validator:
          (value) => ValidationUtils.validateRequired(value, 'Postal code'),
    );
  }

  CustomTextField _phoneField(TextEditingController phoneNumberController) {
    return CustomTextField(
      controller: phoneNumberController,
      keyboardType: TextInputType.phone,
      label: 'Phone no',
      validator: (value) => ValidationUtils.validateNumber(value, 'Phone no'),
    );
  }

  CustomTextField _addressField(TextEditingController addressController) {
    return CustomTextField(
      controller: addressController,
      maxLines: 3,
      label: 'Address line',
      validator:
          (value) => ValidationUtils.validateRequired(value, 'Address line'),
    );
  }
}
