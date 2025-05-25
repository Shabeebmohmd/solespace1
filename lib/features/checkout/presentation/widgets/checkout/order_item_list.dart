import 'package:flutter/material.dart';
import 'package:sole_space_user1/features/home/models/cart_model.dart';

class OrderItemList extends StatelessWidget {
  final List<CartItem> items;

  const OrderItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(height: 10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _OrderItemTile(item: item);
      },
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  final CartItem item;

  const _OrderItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          item.imageUrl.isNotEmpty
              ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  item.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(Icons.error),
                ),
              )
              : const Icon(Icons.image_not_supported),
      title: Text(item.name),
      subtitle: Text('Price: \$${item.price.toStringAsFixed(2)}'),
      trailing: Text('Qty: ${item.quantity}'),
    );
  }
}
