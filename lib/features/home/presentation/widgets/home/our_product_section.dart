import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/core/widgets/custom_product_card.dart';
import 'package:sole_space_user1/core/widgets/shimmer.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product/product_bloc.dart';

class OurProductsSection extends StatelessWidget {
  const OurProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return ShimmerLoaders.newArrivalsLoader();
        } else if (state is ProductLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.seeAllProducts);
                      },
                      child: const Text('See all'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.25,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      final product = state.data[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: SizedBox(
                          width:
                              MediaQuery.of(context).size.width *
                              0.4, // Responsive width for each item
                          child: ProductCard(product: product),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        } else if (state is ProductError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
