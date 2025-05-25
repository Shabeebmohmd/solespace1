import 'package:flutter/material.dart';
import 'package:sole_space_user1/features/checkout/data/model/address_model.dart';
import 'package:sole_space_user1/features/checkout/presentation/widgets/address/address_list_card.dart';

class AddressListItem extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool?>? onSelect;

  const AddressListItem({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: ListTile(
        leading: Checkbox(value: address.isSelected, onChanged: onSelect),
        title: Text(
          address.fullName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(address.address),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
            IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
