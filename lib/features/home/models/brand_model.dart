import 'dart:io';

class Brand {
  final String id;
  final String name;
  final String? description;
  final File imageUrl;

  Brand({
    required this.id,
    required this.name,
    this.description,
    required this.imageUrl,
  });

  factory Brand.fromFirestore(Map<String, dynamic> data, String id) {
    return Brand(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['logoImage'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
