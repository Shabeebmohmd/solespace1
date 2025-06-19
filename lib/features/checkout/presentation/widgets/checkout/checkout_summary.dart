import 'package:flutter/material.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/widgets/custom_button.dart';

class CheckoutSummary extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final bool isButtonEnabled;
  final VoidCallback onPlaceOrder;

  const CheckoutSummary({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.isButtonEnabled,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    final total = subtotal + shipping;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double containerWidth = maxWidth > 600 ? 400 : double.infinity;
        return Center(
          child: Container(
            width: containerWidth,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceBright,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _priceRow('Subtotal:', '\$${subtotal.toStringAsFixed(2)}'),
                  mediumSpacing,
                  _priceRow('Shipping:', '\$${shipping.toStringAsFixed(2)}'),
                  mediumSpacing,
                  _priceRow(
                    'Total:',
                    '\$${total.toStringAsFixed(2)}',
                    isBold: true,
                  ),
                  mediumSpacing,
                  CustomButton(
                    onPressed: isButtonEnabled ? onPlaceOrder : null,
                    text: 'Place order',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _priceRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
