import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/utils/snack_bar_utils.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/core/widgets/custom_button.dart';
import 'package:sole_space_user1/features/home/models/cart_model.dart';
import 'package:sole_space_user1/features/home/models/product_model.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/cart/cart_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product/product_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product_detail/product_details_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/widgets/product/product_image_section.dart';
import 'package:sole_space_user1/features/home/presentation/widgets/product/product_info_section.dart';
import 'package:sole_space_user1/features/home/presentation/widgets/product/product_selection_section.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final currentIndexNotifier = ValueNotifier<int>(0);

    return BlocProvider(
      create: (context) => ProductDetailsBloc(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(product.name),
          actions: [_buildFavoriteIcon(context)],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImageSection(
                imageUrls: product.imageUrls,
                currentIndexNotifier: currentIndexNotifier,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductInfoSection(product: product),
                    extraMediumSpacing,
                    ProductSelectionSection(product: product),
                    extraMediumSpacing,
                    _buildAddToCartButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteIcon(BuildContext context) {
    return BlocSelector<ProductBloc, ProductState, bool>(
      selector:
          (state) =>
              state is ProductLoaded && state.favorites.contains(product),
      builder: (context, isFavorited) {
        return IconButton(
          icon: Icon(
            isFavorited ? Icons.favorite : Icons.favorite_border,
            color: isFavorited ? Colors.red : Colors.white,
            size: 30,
          ),
          onPressed: () {
            context.read<ProductBloc>().add(ToggleFavorite(product: product));
            if (isFavorited) {
              SnackbarUtils.showSnackbar(
                context: context,
                message: 'Item removed from favorites',
              );
            }
          },
        );
      },
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, productDetailsState) {
        return BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            return CustomButton(
              onPressed: () {
                if (productDetailsState.selectedSize != null) {
                  final cartItem = CartItem(
                    productId: product.id!,
                    imageUrl: product.imageUrls.first,
                    name: product.name,
                    price: product.discountPrice ?? product.price!,
                    quantity: productDetailsState.quantity,
                    size: productDetailsState.selectedSize!,
                  );
                  context.read<CartBloc>().add(AddToCart(cartItem));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart')),
                  );
                }
              },
              text: 'Add to Cart',
              isLoading: cartState is CartLoading,
            );
          },
        );
      },
    );
  }
}
