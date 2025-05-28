import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/features/home/models/product_model.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product_detail/product_details_bloc.dart';

class ProductSelectionSection extends StatelessWidget {
  final Product product;

  const ProductSelectionSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Select Size'),
        const SizedBox(height: 8),
        _buildSizeSelection(context),
        const SizedBox(height: 24),
        _buildSectionTitle('Select Color'),
        const SizedBox(height: 8),
        _buildColorSelection(context),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  selectedColor: Theme.of(context).colorScheme.surfaceTint,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  visualDensity: VisualDensity.compact,
                  labelStyle: const TextStyle(fontSize: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
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
                  selectedColor: Theme.of(context).colorScheme.secondary,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  visualDensity: VisualDensity.compact,
                  labelStyle: const TextStyle(fontSize: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
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
