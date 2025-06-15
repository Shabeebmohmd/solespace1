import 'package:flutter/material.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/features/orders/model/order_model.dart';
import 'package:sole_space_user1/features/orders/presentation/widgets/order_details_card.dart';

class OrderDetailsPage extends StatelessWidget {
  final Order order;
  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text('Order details')),
      body: SingleChildScrollView(child: OrderDetailsCard(order: order)),
    );
  }
}
