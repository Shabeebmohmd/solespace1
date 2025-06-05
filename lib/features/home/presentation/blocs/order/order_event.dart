import 'package:equatable/equatable.dart';
import 'package:sole_space_user1/features/home/models/order_model.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrderEvent {}

class CreateOrder extends OrderEvent {
  final Order order;

  const CreateOrder(this.order);

  @override
  List<Object?> get props => [order];
}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final String status;

  const UpdateOrderStatus({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}
