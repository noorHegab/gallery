import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/photo.dart';

part 'photo_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class PhotoModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String url;

  @HiveField(3)
  final String thumbnailUrl;

  @HiveField(4)
  final String photographer;

  @HiveField(5)
  @JsonKey(name: 'photographer_url')
  final String photographerUrl;

  PhotoModel({
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
    required this.photographer,
    required this.photographerUrl,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'] as int,
      title: json['alt'] as String? ?? 'Untitled',
      url: json['src']['original'] as String,
      thumbnailUrl: json['src']['medium'] as String,
      photographer: json['photographer'] as String,
      photographerUrl: json['photographer_url'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$PhotoModelToJson(this);

  Photo toEntity() {
    return Photo(
      id: id,
      title: title,
      url: url,
      thumbnailUrl: thumbnailUrl,
      photographer: photographer,
      photographerUrl: photographerUrl,
    );
  }

  factory PhotoModel.fromEntity(Photo photo) {
    return PhotoModel(
      id: photo.id,
      title: photo.title,
      url: photo.url,
      thumbnailUrl: photo.thumbnailUrl,
      photographer: photo.photographer,
      photographerUrl: photo.photographerUrl,
    );
  }
}
