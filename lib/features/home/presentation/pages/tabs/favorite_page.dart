import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/core/widgets/custom_product_card.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product/product_bloc.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Favorites'),
        showBackButton: false,
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoaded && state.favorites.isNotEmpty) {
            return LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 2;
                double width = constraints.maxWidth;
                if (width >= 1200) {
                  crossAxisCount = 5;
                } else if (width >= 900) {
                  crossAxisCount = 4;
                } else if (width >= 600) {
                  crossAxisCount = 3;
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: state.favorites.length,
                  itemBuilder: (context, index) {
                    final product = state.favorites[index];
                    return ProductCard(product: product);
                  },
                );
              },
            );
          } else if (state is ProductLoaded && state.favorites.isEmpty) {
            return const Center(child: Text('No favorites yet.'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
