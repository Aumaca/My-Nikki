import 'package:latlong2/latlong.dart';

class Localization {
  final double? x;
  final double? y;

  Localization({
    required this.x,
    required this.y,
  });

  factory Localization.fromJson(Map<String, dynamic> json) {
    return Localization(
      x: json['x'] ? (json['x'] as num).toDouble() : null,
      y: json['y'] ? (json['y'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }
}

class EntryModel {
  final String id;
  final String content;
  final String mood;
  final DateTime date;
  final LatLng? localization;
  final List<String> tags;
  final List<String> media;
  final DateTime createdAt;

  EntryModel({
    required this.id,
    required this.content,
    required this.mood,
    required this.date,
    required this.tags,
    required this.media,
    required this.createdAt,
    this.localization,
  });

  factory EntryModel.fromJson(Map<String, dynamic> json) {
    EntryModel entryTemp = EntryModel(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      mood: json['mood'] ?? '',
      date: DateTime.parse(json['date']),
      localization: json['localization'] != null &&
              json['localization']['x'] != null &&
              json['localization']['y'] != null
          ? LatLng(json['localization']['x'], json['localization']['y'])
          : null,
      tags: List<String>.from(json['tags']),
      media: List<String>.from(json['media']),
      createdAt: DateTime.parse(json['createdAt']),
    );

    return entryTemp;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'mood': mood,
      'date': date.toIso8601String(),
      'localization': localization?.toJson(),
      'tags': tags,
      'media': media,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
