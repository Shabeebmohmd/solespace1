import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/features/home/models/product_model.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product_detail/product_details_bloc.dart';

class ProductSelectionSection extends StatelessWidget {
  final Product product;

  const ProductSelectionSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Size',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildSizeSelection(context),
          const SizedBox(height: 24),
          const Text(
            'Select Color',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildColorSelection(context),
        ],
      ),
    );
  }

  Widget _buildSizeSelection(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        return Wrap(
          spacing: 8,
          children:
              product.sizes.map((size) {
                return ChoiceChip(
                  label: Text(size),
                  selected: state.selectedSize == size,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<ProductDetailsBloc>().add(SelectSize(size));
                    }
                  },
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildColorSelection(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        return Wrap(
          spacing: 8,
          children:
              product.colors.map((color) {
                return ChoiceChip(
                  label: Text(color),
                  selected: state.selectedColor == color,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<ProductDetailsBloc>().add(
                        SelectColor(color),
                      );
                    }
                  },
                );
              }).toList(),
        );
      },
    );
  }
}
