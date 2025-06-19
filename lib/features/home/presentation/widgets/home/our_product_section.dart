import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/core/widgets/custom_product_card.dart';
import 'package:sole_space_user1/core/widgets/shimmer.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product/product_bloc.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb

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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double itemWidth;
                    double itemHeight;
                    final screenHeight = MediaQuery.of(context).size.height;

                    if (kIsWeb) {
                      itemWidth =
                          constraints.maxWidth *
                          0.25; // or a fixed value like 250
                      itemHeight =
                          screenHeight * 0.35; // 35% of screen height for web
                    } else {
                      itemWidth = MediaQuery.of(context).size.width * 0.4;
                      itemHeight =
                          screenHeight *
                          0.25; // 25% of screen height for mobile
                    }

                    return SizedBox(
                      height: itemHeight,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.data.length,
                        itemBuilder: (context, index) {
                          final product = state.data[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: SizedBox(
                              width: itemWidth,
                              child: ProductCard(product: product),
                            ),
                          );
                        },
                      ),
                    );
                  },
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
