import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/core/utils/snack_bar_utils.dart';
import 'package:sole_space_user1/features/home/models/product_model.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product/product_bloc.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final currentIndexNotifier = ValueNotifier<int>(0);
    return GestureDetector(
      onTap:
          () => Navigator.pushNamed(
            context,
            AppRouter.productDetails,
            arguments: product,
          ),
      child: Card(
        elevation: 2,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child:
                      product.imageUrls.isNotEmpty
                          ? Stack(
                            children: [
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: double.infinity,
                                  viewportFraction: 1.0,
                                  enableInfiniteScroll: false,
                                  autoPlay: false,
                                  onPageChanged:
                                      (index, reason) =>
                                          currentIndexNotifier.value = index,
                                ),
                                items:
                                    product.imageUrls.map((imageUrl) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          );
                                        },
                                      );
                                    }).toList(),
                              ),
                              _buildIndicators(currentIndexNotifier),
                            ],
                          )
                          : const Icon(Icons.image_not_supported, size: 50),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${product.price!.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 4,
              right: 4,
              child: BlocSelector<ProductBloc, ProductState, bool>(
                selector:
                    (state) =>
                        state is ProductLoaded &&
                        state.favorites.contains(product),
                builder: (context, isFavorited) {
                  return IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      context.read<ProductBloc>().add(
                        ToggleFavorite(product: product),
                      );
                      if (isFavorited) {
                        SnackbarUtils.showSnackbar(
                          context: context,
                          message: 'Item removed from favorites',
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicators(ValueNotifier<int> currentIndexNotifier) {
    return ValueListenableBuilder<int>(
      valueListenable: currentIndexNotifier,
      builder: (context, currentIndex, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              product.imageUrls.asMap().entries.map((entry) {
                final index = entry.key;
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        currentIndex == index
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}
