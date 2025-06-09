import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/features/orders/data/order_repository.dart';
import 'package:sole_space_user1/features/orders/presentation/blocs/order/order_event.dart';
import 'package:sole_space_user1/features/orders/presentation/blocs/order/order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;

  OrderBloc(this._orderRepository) : super(OrderInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<CreateOrder>(_onCreateOrder);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<FilterOrders>(_onFilterOrders);
  }

  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    try {
      emit(OrderLoading());
      final orders = await _orderRepository.getUserOrders();
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      await _orderRepository.createOrder(event.order);
      final orders = await _orderRepository.getUserOrders();
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      await _orderRepository.updateOrderStatus(event.orderId, event.status);
      final orders = await _orderRepository.getUserOrders();
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  void _onFilterOrders(FilterOrders event, Emitter<OrderState> emit) {
    if (state is OrderLoaded) {
      final currentState = state as OrderLoaded;
      emit(OrderLoaded(currentState.orders, selectedFilter: event.filter));
    }
  }
}
