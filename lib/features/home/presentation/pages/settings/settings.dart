import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/theme/theme_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/pages/settings/privacy_policy_page.dart';
import 'package:sole_space_user1/features/home/presentation/pages/settings/terms_conditions_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsSection(context, 'Legal', [
            _buildSettingsItem(
              context,
              'Privacy Policy',
              Icons.privacy_tip_outlined,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyPage(),
                ),
              ),
            ),
            Divider(),
            _buildSettingsItem(
              context,
              'Terms & Conditions',
              Icons.description_outlined,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsConditionsPage(),
                ),
              ),
            ),
          ]),
          extraMediumSpacing,
          _buildSettingsSection(context, 'App Settings', [
            _buildThemeSettingsItem(context),
          ]),
        ],
      ),
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
            Icon(icon, size: 24),
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

  Widget _buildThemeSettingsItem(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDarkMode =
            state is ThemeInitial && state.themeMode == ThemeMode.dark;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, size: 24),
              const SizedBox(width: 16),
              Text('Dark Mode', style: Theme.of(context).textTheme.bodyLarge),
              const Spacer(),
              Switch(
                value: isDarkMode,
                onChanged: (value) {
                  context.read<ThemeBloc>().add(ToggleTheme(value));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
