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
  final String? brandId;
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? color;
  final String? size;

  const FilterProducts({
    this.brandId,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.color,
    this.size,
  });

  @override
  List<Object> get props => [
    brandId ?? '',
    categoryId ?? '',
    minPrice ?? 0.0,
    maxPrice ?? 0.0,
    color ?? '',
    size ?? '',
  ];
}
