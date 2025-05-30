import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/core/widgets/dismissible_keyboard.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:sole_space_user1/features/auth/presentation/blocs/auth/auth_event.dart';
import 'package:sole_space_user1/features/home/presentation/widgets/home/brand_section.dart';
import 'package:sole_space_user1/features/home/presentation/widgets/home/category_list.dart';
import 'package:sole_space_user1/features/home/presentation/widgets/home/home_search_bar.dart';
import 'package:sole_space_user1/features/home/presentation/widgets/home/our_product_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DismissibleKeyboard(
      child: Scaffold(
        appBar: CustomAppBar(
          title: const Text('SoleSpace'),
          showBackButton: false,
          // leading: BlocBuilder<ThemeBloc, ThemeState>(
          //   builder: (context, state) {
          //     final isDarkMode =
          //         state is ThemeInitial && state.themeMode == ThemeMode.dark;
          //     return IconButton(
          //       icon: Icon(
          //         isDarkMode ? Icons.dark_mode : Icons.light_mode,
          //         color: isDarkMode ? Colors.white : Colors.yellow,
          //       ),
          //       onPressed: () {
          //         context.read<ThemeBloc>().add(ToggleTheme(!isDarkMode));
          //       },
          //     );
          //   },
          // ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                showCustomAlertDialog(
                  context: context,
                  title: 'Log out',
                  content: 'Are you sure you want to log out?',
                  onConfirm: () => context.read<AuthBloc>().add(SignOut()),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              const HomeSearchBar(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    refresh(context);
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        CategoryList(),
                        BrandSection(),
                        OurProductsSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
