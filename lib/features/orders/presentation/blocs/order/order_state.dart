import 'package:equatable/equatable.dart';
import 'package:sole_space_user1/features/orders/model/order_model.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<Order> orders;
  final String selectedFilter;

  const OrderLoaded(this.orders, {this.selectedFilter = 'all'});

  @override
  List<Object?> get props => [orders, selectedFilter];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}
