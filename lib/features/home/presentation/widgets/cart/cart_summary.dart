import 'package:flutter/material.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/widgets/custom_button.dart';

class CartSummary extends StatelessWidget {
  final double total;
  final double subTotal;
  final double shipping;

  const CartSummary({
    super.key,
    required this.total,
    required this.subTotal,
    required this.shipping,
  });

  @override
  Widget build(BuildContext context) {
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
                const Text("Subtotal:"),
                Text("\$${subTotal.toStringAsFixed(2)}"),
              ],
            ),
            mediumSpacing,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Shipping:"),
                Text(' \$${shipping.toStringAsFixed(2)}'),
              ],
            ),
            mediumSpacing,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
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
}
