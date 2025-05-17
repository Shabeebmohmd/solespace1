import 'package:flutter/material.dart';
import 'package:sole_space_user1/features/checkout/data/model/address_model.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;

  const AddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address.fullName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(address.state),
            Text('${address.city}, ${address.state} - ${address.postalCode}'),
            const SizedBox(height: 4),
            Text('Phone: ${address.phoneNumber}'),
          ],
        ),
      ),
    );
  }
}
