import 'package:equatable/equatable.dart';

class Photo extends Equatable {
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;
  final String photographer;
  final String photographerUrl;

  const Photo({
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
    required this.photographer,
    required this.photographerUrl,
  });

  @override
  List<Object?> get props =>
      [id, title, url, thumbnailUrl, photographer, photographerUrl];
}
