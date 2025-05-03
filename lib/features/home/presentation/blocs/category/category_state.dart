part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> data;
  const CategoryLoaded({required this.data});
  @override
  List<Object> get props => [data];
}

class CategoryError extends CategoryState {
  final String message;
  const CategoryError({required this.message});
  @override
  List<Object> get props => [message];
}
