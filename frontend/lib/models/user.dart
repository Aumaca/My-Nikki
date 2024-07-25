class UserModel {
  final String id;
  final String email;
  final String name;
  final String photoURL;
  final String photoFile;
  final List<String> entries;
  final String country;
  final String createdAt;
  final String isComplete;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.photoURL,
    required this.photoFile,
    required this.entries,
    required this.country,
    required this.createdAt,
    required this.isComplete,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      photoURL: json['photoURL'] ?? '',
      photoFile: json['photoFile'] ?? '',
      entries: List<String>.from(json['entries'] ?? []),
      country: json['country'] ?? '',
      createdAt: json['createdAt'] ?? '',
      isComplete: json['isComplete'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoURL': photoURL,
      'photoFile': photoFile,
      'entries': entries,
      'country': country,
      'createdAt': createdAt,
      'isComplete': isComplete,
    };
  }
}
