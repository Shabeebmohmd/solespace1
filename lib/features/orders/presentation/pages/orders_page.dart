import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/features/orders/presentation/blocs/order/order_bloc.dart';
import 'package:sole_space_user1/features/orders/presentation/blocs/order/order_event.dart';
import 'package:sole_space_user1/features/orders/presentation/blocs/order/order_state.dart';
import 'package:sole_space_user1/features/orders/presentation/widgets/order_card.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<OrderBloc>().add(LoadOrders());
            },
            icon: const Icon(Icons.replay_outlined, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(context),
          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is OrderLoaded) {
                  if (state.orders.isEmpty) {
                    return const Center(child: Text('No orders found'));
                  }

                  final filteredOrders =
                      state.selectedFilter == 'all'
                          ? state.orders
                          : state.orders
                              .where(
                                (order) =>
                                    order.status.toLowerCase() ==
                                    state.selectedFilter.toLowerCase(),
                              )
                              .toList();

                  if (filteredOrders.isEmpty) {
                    return Center(
                      child: Text('No ${state.selectedFilter} orders found'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return OrderCard(order: order);
                    },
                  );
                } else if (state is OrderError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is! OrderLoaded) return const SizedBox();

        final filters = [
          'all',
          'processing',
          'shipped',
          'delivered',
          'cancelled',
        ];

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children:
                filters.map((filter) {
                  final isSelected = state.selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        '${filter[0].toUpperCase()}${filter.substring(1)}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : null,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          context.read<OrderBloc>().add(FilterOrders(filter));
                        }
                      },
                      backgroundColor:
                          isSelected ? Theme.of(context).primaryColor : null,
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}
