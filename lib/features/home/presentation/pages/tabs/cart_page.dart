import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/core/widgets/custom_button.dart';
import 'package:sole_space_user1/features/home/models/cart_model.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/cart/cart_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  final double shipping = 49;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text('Cart'), showBackButton: false),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return Center(child: Text('Your cart is empty'));
            }
            // Calculate total using the function from CartBloc
            final total = context.read<CartBloc>().calculateTotal(
              state.cartItems,
              shipping,
            );
            final subTotal = context.read<CartBloc>().calculateSubTotal(
              state.cartItems,
            );
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(height: 40),
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = state.cartItems[index];
                      return _listTile(item, context);
                    },
                  ),
                ),

                // Display total price
                _checkOutContainer(context, total, subTotal),
              ],
            );
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          }
          return SizedBox();
        },
      ),
    );
  }

  Container _checkOutContainer(
    BuildContext context,
    double total,
    double subTotal,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Subtotal:"),
                Text("\$${subTotal.toStringAsFixed(2)}"),
              ],
            ),
            mediumSpacing,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Shipping:"),
                Text(' \$${shipping.toStringAsFixed(2)}'),
              ],
            ),
            mediumSpacing,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${total.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            mediumSpacing,
            CustomButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.checkOut);
              },
              text: 'Checkout',
            ),
          ],
        ),
      ),
    );
  }

  ListTile _listTile(CartItem item, BuildContext context) {
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
                      (context, error, stackTrace) => Icon(Icons.error),
                ),
              )
              : Icon(Icons.image_not_supported),
      title: Text(item.name),
      subtitle: Text('Price: \$${item.price.toStringAsFixed(2)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              if (item.quantity > 1) {
                context.read<CartBloc>().add(
                  UpdateCartQuantity(item.productId, item.quantity - 1),
                );
              } else {
                context.read<CartBloc>().add(RemoveFromCart(item.productId));
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
                UpdateCartQuantity(item.productId, item.quantity + 1),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              context.read<CartBloc>().add(RemoveFromCart(item.productId));
            },
          ),
        ],
      ),
    );
  }
}
