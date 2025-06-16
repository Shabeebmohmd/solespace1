part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProducts extends ProductEvent {}

class FetchProductsByBrand extends ProductEvent {
  final String brandId;

  const FetchProductsByBrand({required this.brandId});

  @override
  List<Object> get props => [brandId];
}

class FetchProductsByCategory extends ProductEvent {
  final String categoryId;

  const FetchProductsByCategory({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class ToggleFavorite extends ProductEvent {
  final Product product;

  const ToggleFavorite({required this.product});

  @override
  List<Object> get props => [product];
}

class SearchProduct extends ProductEvent {
  final String query;
  const SearchProduct({required this.query});

  @override
  List<Object> get props => [query];
}

class FilterProducts extends ProductEvent {
  final List<String> brandIds;
  final List<String> categoryIds;
  final double? minPrice;
  final double? maxPrice;
  final String? color;
  final List<String> sizes;

  const FilterProducts({
    this.brandIds = const [],
    this.categoryIds = const [],
    this.minPrice,
    this.maxPrice,
    this.color,
    this.sizes = const [],
  });

  @override
  List<Object> get props => [
    brandIds,
    categoryIds,
    minPrice ?? 0.0,
    maxPrice ?? 0.0,
    color ?? '',
    sizes,
  ];
}
