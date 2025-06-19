import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/core/widgets/custom_product_card.dart';
import 'package:sole_space_user1/features/home/models/brand_model.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product/product_bloc.dart';

class BrandBasedProductListPage extends StatelessWidget {
  const BrandBasedProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Brand? brand = ModalRoute.of(context)?.settings.arguments as Brand?;

    if (brand?.id == null) {
      return Scaffold(
        appBar: CustomAppBar(title: Text(brand!.name)),
        body: const Center(child: Text('No brand selected')),
      );
    }

    context.read<ProductBloc>().add(FetchProductsByBrand(brandId: brand!.id));

    return Scaffold(
      appBar: CustomAppBar(title: Text(brand.name)),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            if (state.data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No products found',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We couldn\'t find any products for this brand',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                // Adjust crossAxisCount based on width
                int crossAxisCount = 2;
                double width = constraints.maxWidth;
                if (width >= 1200) {
                  crossAxisCount = 5;
                } else if (width >= 900) {
                  crossAxisCount = 4;
                } else if (width >= 600) {
                  crossAxisCount = 3;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
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
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
