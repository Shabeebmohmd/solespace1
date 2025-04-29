class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
  });

  // Convert a UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
    };
  }

  // Create a UserModel from a Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'],
    );
  }
}
