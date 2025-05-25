import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/utils/snack_bar_utils.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/utils/validate_utils.dart';
import 'package:sole_space_user1/core/widgets/custom_text_field.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_bloc.dart';
import 'package:sole_space_user1/features/checkout/data/model/address_model.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_event.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_state.dart';
import 'package:sole_space_user1/features/checkout/presentation/widgets/address/address_form.dart';
import 'package:uuid/uuid.dart';

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final formKey = GlobalKey<FormState>();
    final fullNameController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final postalCodeController = TextEditingController();
    final addressController = TextEditingController();
    final phoneNumberController = TextEditingController();

    void submitForm() {
      if (formKey.currentState!.validate()) {
        final uuid = Uuid();
        final address = AddressModel(
          id: uuid.v4(),
          fullName: fullNameController.text,
          city: cityController.text,
          state: stateController.text,
          postalCode: postalCodeController.text,
          address: addressController.text,
          phoneNumber: phoneNumberController.text,
        );
        context.read<AddressBloc>().add(AddAddress(user!.uid, address));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add Address')),
      body: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressLoaded) {
            Navigator.pop(context);
            SnackbarUtils.showSnackbar(
              context: context,
              message: 'Address added successfully',
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
            submitButtonText: 'Save Address',
          ),
        ),
      ),
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

  CustomTextField _postalField(TextEditingController postalCodeController) {
    return CustomTextField(
      controller: postalCodeController,
      keyboardType: TextInputType.number,
      label: 'Postal code',
      validator:
          (value) => ValidationUtils.validateRequired(value, 'Postal code'),
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

  CustomTextField _cityField(TextEditingController cityController) {
    return CustomTextField(
      controller: cityController,
      label: 'City',
      validator: (value) => ValidationUtils.validateRequired(value, 'City'),
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
}
