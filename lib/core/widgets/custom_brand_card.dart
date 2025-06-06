import 'package:flutter/material.dart';
import 'package:sole_space_user1/features/home/models/brand_model.dart';

class BrandCard extends StatelessWidget {
  final Brand brand;

  const BrandCard({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).height * 0.18,
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child:
                  brand.imageUrl.isNotEmpty
                      ? Image.network(brand.imageUrl, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported, size: 50),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                brand.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
