import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/features/orders/presentation/blocs/order/order_bloc.dart';
import 'package:sole_space_user1/features/orders/presentation/blocs/order/order_event.dart';
import 'package:sole_space_user1/features/orders/presentation/blocs/order/order_state.dart';
import 'package:sole_space_user1/features/orders/utils/order_utils.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is! OrderLoaded) return const SizedBox();

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
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.onSurface
                                  : null,
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
