import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/utils/validate_utils.dart';
import 'package:sole_space_user1/core/widgets/custom_button.dart';
import 'package:sole_space_user1/core/widgets/custom_text_field.dart';
import 'package:sole_space_user1/features/auth/data/model/user_model.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/profile/profile_bloc.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  bool _isChangingPassword = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is ProfileLoaded) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProfileImage(context),
                  const SizedBox(height: 24),
                  _buildNameField(),
                  const SizedBox(height: 16),
                  _buildEmailField(),
                  const SizedBox(height: 24),
                  _buildPasswordSection(),
                  const SizedBox(height: 32),
                  _buildSaveButton(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage:
                widget.user.profileImageUrl != null
                    ? NetworkImage(widget.user.profileImageUrl!)
                    : null,
            child:
                widget.user.profileImageUrl == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                onPressed: () {
                  context.read<ProfileBloc>().add(UpdateProfileImage());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      controller: _nameController,
      label: 'Name',
      validator: (value) => ValidationUtils.validateRequired(value, 'Name'),
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      controller: _emailController,
      label: 'Email',
      keyboardType: TextInputType.emailAddress,
      validator: (value) => ValidationUtils.validateEmail(value),
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Change Password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Switch(
              value: _isChangingPassword,
              onChanged: (value) {
                setState(() {
                  _isChangingPassword = value;
                });
              },
            ),
          ],
        ),
        if (_isChangingPassword) ...[
          const SizedBox(height: 16),
          CustomTextField(
            controller: _currentPasswordController,
            label: 'Current Password',
            obscureText: true,
            validator: (value) {
              if (_isChangingPassword && (value == null || value.isEmpty)) {
                return 'Please enter your current password';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _newPasswordController,
            label: 'New Password',
            obscureText: true,
            validator: (value) {
              if (_isChangingPassword) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a new password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _confirmPasswordController,
            label: 'Confirm New Password',
            obscureText: true,
            validator: (value) {
              if (_isChangingPassword) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your new password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  Widget _buildSaveButton(ProfileState state) {
    return CustomButton(
      text: state is ProfileLoading ? 'Saving...' : 'Save Changes',
      onPressed:
          state is ProfileLoading
              ? () {} // Empty function when loading
              : () {
                if (_formKey.currentState?.validate() ?? false) {
                  context.read<ProfileBloc>().add(
                    UpdateProfile(
                      name: _nameController.text,
                      email: _emailController.text,
                      currentPassword:
                          _isChangingPassword
                              ? _currentPasswordController.text
                              : null,
                      newPassword:
                          _isChangingPassword
                              ? _newPasswordController.text
                              : null,
                    ),
                  );
                }
              },
    );
  }
}
