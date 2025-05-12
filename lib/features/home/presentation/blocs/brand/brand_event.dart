part of 'brand_bloc.dart';

sealed class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object> get props => [];
}

class FetchBrands extends BrandEvent {}

class SearchBrands extends BrandEvent {
  final String query;
  const SearchBrands({required this.query});

  @override
  List<Object> get props => [query];
}
