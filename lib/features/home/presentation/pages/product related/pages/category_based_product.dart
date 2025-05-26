import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/core/widgets/custom_product_card.dart';
import 'package:sole_space_user1/features/home/models/category_model.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product/product_bloc.dart';

class CategoryBasedProductListPage extends StatelessWidget {
  const CategoryBasedProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Category? category =
        ModalRoute.of(context)?.settings.arguments as Category?;

    if (category?.id == null) {
      return Scaffold(
        appBar: CustomAppBar(title: Text(category!.name)),
        body: const Center(child: Text('No category selected')),
      );
    }

    context.read<ProductBloc>().add(
      FetchProductsByCategory(categoryId: category!.id),
    );
    return Scaffold(
      appBar: CustomAppBar(title: Text(category.name)),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  final product = state.data[index];
                  return ProductCard(product: product);
                },
              ),
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No products found'));
          }
        },
      ),
    );
  }
}
