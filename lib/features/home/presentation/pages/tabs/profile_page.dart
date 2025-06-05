import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/features/auth/data/model/user_model.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/profile/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: const Text('Profile')),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return _buildProfileContent(context, state.user);
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserModel user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfileSection(context, user),
          extraMediumSpacing,
          _buildSettingsSection(context, 'Account', [
            _buildSettingsItem(
              context,
              'Addresses',
              Icons.location_on_outlined,
              () => Navigator.pushNamed(context, AppRouter.addressList),
            ),
            Divider(),
            _buildSettingsItem(
              context,
              'Manage Account',
              Icons.edit_outlined,
              () => Navigator.pushNamed(
                context,
                AppRouter.editUser,
                arguments: user,
              ),
            ),
            Divider(),
            _buildSettingsItem(
              context,
              'Settings',
              Icons.settings_outlined,
              () => Navigator.pushNamed(context, AppRouter.settingsPage),
            ),
            Divider(),
            _buildSettingsItem(
              context,
              'Orders',
              Icons.receipt,
              () => Navigator.pushNamed(context, AppRouter.orderPage),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, UserModel user) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildProfileImage(context, user),
                mediumSpacing,
                _buildUserInfo(context, user),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context, UserModel user) {
    return Stack(
      children: [
        CircleAvatar(
          radius: MediaQuery.of(context).size.width * 0.20,
          backgroundImage:
              user.profileImageUrl != null
                  ? NetworkImage(user.profileImageUrl!)
                  : null,
          child:
              user.profileImageUrl == null
                  ? Icon(
                    Icons.person,
                    size: MediaQuery.of(context).size.width * 020,
                    color: Theme.of(context).colorScheme.onSurface,
                  )
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
    );
  }

  Widget _buildUserInfo(BuildContext context, UserModel user) {
    return Column(
      children: [
        Text(
          user.name,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 16),
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
