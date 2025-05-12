part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class FetchCategory extends CategoryEvent {}

class SearchCategory extends CategoryEvent {
  final String query;
  const SearchCategory({required this.query});

  @override
  List<Object> get props => [query];
}
