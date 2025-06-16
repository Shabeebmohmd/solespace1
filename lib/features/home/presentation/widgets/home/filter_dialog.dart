import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/widgets/custom_button.dart';
import 'package:sole_space_user1/features/home/models/brand_model.dart';
import 'package:sole_space_user1/features/home/models/category_model.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/brand/brand_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/category/category_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/product/product_bloc.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<String> selectedBrandIds = [];
  List<String> selectedCategoryIds = [];
  List<String> selectedSizes = [];
  String? selectedColor;
  RangeValues _priceRange = const RangeValues(
    0,
    5000,
  ); // Default range from 0 to 1000
  double rating = 0;

  @override
  void dispose() {
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      selectedBrandIds = [];
      selectedCategoryIds = [];
      selectedSizes = [];
      selectedColor = null;
      _priceRange = const RangeValues(0, 5000);
    });
    context.read<ProductBloc>().add(const FilterProducts());
    Navigator.pop(context);
  }

  void _applyFilters() {
    context.read<ProductBloc>().add(
      FilterProducts(
        brandIds: selectedBrandIds,
        categoryIds: selectedCategoryIds,
        minPrice: _priceRange.start,
        maxPrice: _priceRange.end,
        color: selectedColor,
        sizes: selectedSizes,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter Products',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Brand Filter
              BlocBuilder<BrandBloc, BrandState>(
                builder: (context, state) {
                  if (state is BrandLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Brands',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children:
                              state.data.map((Brand brand) {
                                return FilterChip(
                                  label: Text(brand.name),
                                  selected: selectedBrandIds.contains(brand.id),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedBrandIds.add(brand.id);
                                      } else {
                                        selectedBrandIds.remove(brand.id);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 16),
              // Category Filter
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children:
                              state.data.map((Category category) {
                                return FilterChip(
                                  label: Text(category.name),
                                  selected: selectedCategoryIds.contains(
                                    category.id,
                                  ),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedCategoryIds.add(category.id);
                                      } else {
                                        selectedCategoryIds.remove(category.id);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 16),
              // Price Range
              const Text(
                'Price Range',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              mediumSpacing,
              RangeSlider(
                values: _priceRange,
                min: 0,
                max: 5000,
                divisions: 100,
                labels: RangeLabels(
                  '\$${_priceRange.start.round()}',
                  '\$${_priceRange.end.round()}',
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _priceRange = values;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${_priceRange.start.round()}'),
                    Text('\$${_priceRange.end.round()}'),
                  ],
                ),
              ),
              mediumSpacing,
              const Text(
                'Size',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children:
                    ['6', '7', '8', '9', '10', '11', '12'].map((size) {
                      return FilterChip(
                        label: Text(size),
                        selected: selectedSizes.contains(size),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedSizes.add(size);
                            } else {
                              selectedSizes.remove(size);
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearFilters,
                      child: const Text('Clear Filters'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      onPressed: _applyFilters,
                      text: 'Apply Filters',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
