import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/features/home/models/cart_model.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/cart/cart_bloc.dart';

class CartListItem extends StatelessWidget {
  final CartItem item;

  const CartListItem({super.key, required this.item});

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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price: \$${item.price.toStringAsFixed(2)}'),
          Text('Size: ${item.size}, Color: ${item.color}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle),
            onPressed: () {
              if (item.quantity > 1) {
                context.read<CartBloc>().add(
                  UpdateCartQuantity(
                    '${item.productId}_${item.size}_${item.color}',
                    item.quantity - 1,
                  ),
                );
              } else {
                context.read<CartBloc>().add(
                  RemoveFromCart(
                    '${item.productId}_${item.size}_${item.color}',
                  ),
                );
              }
            },
          ),
          Text('${item.quantity}'),
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            onPressed: () {
              context.read<CartBloc>().add(
                UpdateCartQuantity(
                  '${item.productId}_${item.size}_${item.color}',
                  item.quantity + 1,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<CartBloc>().add(
                RemoveFromCart('${item.productId}_${item.size}_${item.color}'),
              );
            },
          ),
        ],
      ),
    );
  }
}
