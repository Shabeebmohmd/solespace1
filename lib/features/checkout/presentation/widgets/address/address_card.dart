import 'package:flutter/material.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/features/checkout/data/model/address_model.dart';

class CustomAddressCard extends StatelessWidget {
  final AddressModel? address;
  final VoidCallback onChangePressed;

  const CustomAddressCard({
    super.key,
    this.address,
    required this.onChangePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                address != null
                    ? TextButton(
                      onPressed: onChangePressed,
                      child: const Text(
                        'CHANGE',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                    : TextButton(
                      onPressed: onChangePressed,
                      child: const Text(
                        'Add address',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              ],
            ),
            Divider(),
            smallSpacing,
            if (address != null) ...[
              Text(
                address!.fullName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              mediumSpacing,
              Text(address!.address, style: const TextStyle(fontSize: 16)),
              Text(
                '${address!.city}, ${address!.state} ${address!.postalCode}',
                style: const TextStyle(fontSize: 16),
              ),
              mediumSpacing,
              Text(address!.phoneNumber, style: const TextStyle(fontSize: 16)),
            ] else ...[
              const Text(
                'No address available. Please add an address to proceed.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
