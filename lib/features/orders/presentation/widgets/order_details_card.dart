import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/features/orders/model/order_model.dart';
import 'package:sole_space_user1/features/orders/presentation/blocs/order/order_bloc.dart';
import 'package:sole_space_user1/features/orders/presentation/blocs/order/order_event.dart';
import 'package:sole_space_user1/features/orders/presentation/widgets/status_chip.dart';

class OrderDetailsCard extends StatelessWidget {
  final Order order;
  const OrderDetailsCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.id.substring(0, 8)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  StatusChip().buildStatusChip(order.status),
                ],
              ),
              smallSpacing,
              Text(
                order.items[0].name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              smallSpacing,
              Text(
                'Date: ${DateFormat('MMM dd, yyyy').format(order.createdAt)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              smallSpacing,
              Text(
                'Total: \$${order.total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              mediumSpacing,
              const Divider(),
              smallSpacing,
              Text(
                'Shipping Address:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              smallSpacing,
              Text(
                '${order.fullName}\n${order.address}\n${order.city}, ${order.state} ${order.postalCode}\n${order.phoneNumber}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              mediumSpacing,
              const Divider(),
              smallSpacing,
              Text('Items:', style: Theme.of(context).textTheme.titleSmall),
              smallSpacing,
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return ListTile(
                    leading:
                        item.imageUrl.isNotEmpty
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const Icon(Icons.error),
                              ),
                            )
                            : const Icon(Icons.image_not_supported),
                    title: Text(item.name),
                    subtitle: Text('Size: ${item.size}'),
                    trailing: Text(
                      'Qty: ${item.quantity}\n\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      textAlign: TextAlign.end,
                    ),
                  );
                },
              ),
              smallSpacing,
              if (order.trackingNumber != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tracking ID: ${order.trackingNumber}'),

                    Builder(
                      builder: (context) {
                        return order.status.toLowerCase() != 'cancelled' &&
                                order.status.toLowerCase() != 'delivered'
                            ? TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: Text(
                                          'Are you sure you want to cancel this item',
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  context.read<OrderBloc>().add(
                                                    UpdateOrderStatus(
                                                      orderId: order.id,
                                                      status: 'cancelled',
                                                    ),
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Ok'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                );
                              },
                              child: const Text('Cancel'),
                            )
                            : const SizedBox.shrink();
                      },
                    ),
                  ],
                )
              else
                SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
