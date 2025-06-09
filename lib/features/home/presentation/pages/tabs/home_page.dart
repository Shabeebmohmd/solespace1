import 'package:flutter/material.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/core/widgets/dismissible_keyboard.dart';
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
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
