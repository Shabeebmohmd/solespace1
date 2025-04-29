part of 'brand_bloc.dart';

sealed class BrandState extends Equatable {
  const BrandState();

  @override
  List<Object> get props => [];
}

class BrandInitial extends BrandState {}

class BrandLoading extends BrandState {}

class BrandLoaded extends BrandState {
  final List<Brand> data;
  const BrandLoaded({required this.data});
  @override
  List<Object> get props => [data];
}

class BrandError extends BrandState {
  final String message;
  const BrandError({required this.message});
  @override
  List<Object> get props => [message];
}
