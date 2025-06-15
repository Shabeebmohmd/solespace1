import 'package:sole_space_user1/features/orders/model/order_model.dart';

List<Order> filterOrders(List<Order> orders, String selectedFilter) {
  if (selectedFilter == 'all') {
    return orders;
  }
  return orders
      .where(
        (order) => order.status.toLowerCase() == selectedFilter.toLowerCase(),
      )
      .toList();
}

final filters = ['all', 'pending', 'shipped', 'delivered', 'cancelled'];
