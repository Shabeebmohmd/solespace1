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
  String? selectedBrandId;
  String? selectedCategoryId;
  String? selectedColor;
  String? selectedSize;
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      selectedBrandId = null;
      selectedCategoryId = null;
      selectedColor = null;
      selectedSize = null;
      minPriceController.clear();
      maxPriceController.clear();
    });
    context.read<ProductBloc>().add(const FilterProducts());
    Navigator.pop(context);
  }

  void _applyFilters() {
    final minPrice = double.tryParse(minPriceController.text);
    final maxPrice = double.tryParse(maxPriceController.text);

    context.read<ProductBloc>().add(
      FilterProducts(
        brandId: selectedBrandId,
        categoryId: selectedCategoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        color: selectedColor,
        size: selectedSize,
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
                          'Brand',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedBrandId,
                          hint: const Text('Select Brand'),
                          items:
                              state.data.map((Brand brand) {
                                return DropdownMenuItem(
                                  value: brand.id,
                                  child: Text(brand.name),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedBrandId = value;
                            });
                          },
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
                          'Category',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedCategoryId,
                          hint: const Text('Select Category'),
                          items:
                              state.data.map((Category category) {
                                return DropdownMenuItem(
                                  value: category.id,
                                  child: Text(category.name),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategoryId = value;
                            });
                          },
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
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: minPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Min Price',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: maxPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Max Price',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              mediumSpacing,
              // // Color Filter
              // const Text(
              //   'Color',
              //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 8),
              // Wrap(
              //   spacing: 8,
              //   children:
              //       ['Red', 'Blue', 'Black', 'White', 'Green'].map((color) {
              //         return ChoiceChip(
              //           label: Text(color),
              //           selected: selectedColor == color,
              //           onSelected: (selected) {
              //             setState(() {
              //               selectedColor = selected ? color : null;
              //             });
              //           },
              //         );
              //       }).toList(),
              // ),
              // const SizedBox(height: 16),
              // Size Filter
              const Text(
                'Size',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children:
                    ['6', '7', '8', '9', '10', '11', '12'].map((size) {
                      return ChoiceChip(
                        label: Text(size),
                        selected: selectedSize == size,
                        onSelected: (selected) {
                          setState(() {
                            selectedSize = selected ? size : null;
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
