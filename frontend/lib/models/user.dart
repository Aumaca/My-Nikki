import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:my_nikki/models/entry.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String photoURL;
  final String photoFile;
  final List<EntryModel> entries;
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
    Map<String, dynamic> userData = json['user'];

    UserModel temp = UserModel(
      id: userData['_id'] ?? '',
      email: userData['email'] ?? '',
      name: userData['name'] ?? '',
      photoURL: userData['photoURL'] ?? '',
      photoFile: userData['photoFile'] ?? '',
      entries: (userData['entries'] as List<dynamic>?)
              ?.map(
                  (entry) => EntryModel.fromJson(entry as Map<String, dynamic>))
              .toList() ??
          [],
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
      'photoFile': photoFile,
      'entries': entries.map((entry) => entry.toJson()).toList(),
      'country': country,
      'createdAt': createdAt,
      'isComplete': isComplete,
    };
  }
}
