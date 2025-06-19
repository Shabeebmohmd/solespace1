import 'package:flutter/material.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/utils/validate_utils.dart';
import 'package:sole_space_user1/core/widgets/custom_text_field.dart';

class AddressForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController postalCodeController;
  final TextEditingController phoneNumberController;
  final TextEditingController addressController;
  final VoidCallback onSubmit;
  final bool isLoading;
  final String submitButtonText;

  const AddressForm({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.cityController,
    required this.stateController,
    required this.postalCodeController,
    required this.phoneNumberController,
    required this.addressController,
    required this.onSubmit,
    required this.isLoading,
    required this.submitButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth > 600 ? 500 : double.infinity;
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  _nameField(),
                  mediumSpacing,
                  _cityField(),
                  mediumSpacing,
                  _stateField(),
                  mediumSpacing,
                  _postalField(),
                  mediumSpacing,
                  _phoneField(),
                  mediumSpacing,
                  _addressField(),
                  extraMediumSpacing,
                  ElevatedButton(
                    onPressed: isLoading ? null : onSubmit,
                    child:
                        isLoading
                            ? const CircularProgressIndicator()
                            : Text(submitButtonText),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  CustomTextField _nameField() {
    return CustomTextField(
      controller: fullNameController,
      label: 'Full name',
      validator:
          (value) => ValidationUtils.validateRequired(value, 'Full name'),
    );
  }

  CustomTextField _cityField() {
    return CustomTextField(
      controller: cityController,
      label: 'City',
      validator: (value) => ValidationUtils.validateRequired(value, 'City'),
    );
  }

  CustomTextField _stateField() {
    return CustomTextField(
      controller: stateController,
      label: 'State/Province',
      validator:
          (value) => ValidationUtils.validateRequired(value, 'State/Province'),
    );
  }

  CustomTextField _postalField() {
    return CustomTextField(
      controller: postalCodeController,
      keyboardType: TextInputType.number,
      label: 'Postal code',
      validator:
          (value) => ValidationUtils.validateRequired(value, 'Postal code'),
    );
  }

  CustomTextField _phoneField() {
    return CustomTextField(
      controller: phoneNumberController,
      keyboardType: TextInputType.phone,
      label: 'Phone no',
      validator: (value) => ValidationUtils.validateNumber(value, 'Phone no'),
    );
  }

  CustomTextField _addressField() {
    return CustomTextField(
      controller: addressController,
      maxLines: 3,
      label: 'Address line',
      validator:
          (value) => ValidationUtils.validateRequired(value, 'Address line'),
    );
  }
}
