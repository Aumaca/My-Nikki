import 'package:my_nikki/models/entry.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String photoURL;
  final List<EntryModel> entries;
  final List<dynamic> media;
  final String country;
  final String createdAt;
  final String isComplete;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.photoURL,
    required this.entries,
    required this.media,
    required this.country,
    required this.createdAt,
    required this.isComplete,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('user') || json['user'] == null) {
      throw Exception("User data is missing or null");
    }

    Map<String, dynamic> userData = json['user'];

    UserModel temp = UserModel(
      id: userData['_id'],
      email: userData['email'],
      name: userData['name'],
      photoURL: userData['photoURL'] ?? '',
      entries: (userData['entries'] as List<dynamic>?)
              ?.map(
                  (entry) => EntryModel.fromJson(entry as Map<String, dynamic>))
              .toList() ??
          [],
      media: userData['media'] ?? [],
      country: userData['country'] ?? '',
      createdAt: userData['createdAt'] ?? '',
      isComplete: userData['isComplete'] ?? '',
    );

    return temp;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoURL': photoURL,
      'entries': entries.map((entry) => entry.toJson()).toList(),
      'country': country,
      'createdAt': createdAt,
      'isComplete': isComplete,
    };
  }
}
