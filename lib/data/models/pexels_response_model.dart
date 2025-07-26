import 'package:json_annotation/json_annotation.dart';

import 'photo_model.dart';

part 'pexels_response_model.g.dart';

@JsonSerializable()
class PexelsResponseModel {
  final int page;
  @JsonKey(name: 'per_page')
  final int perPage;
  final List<PhotoModel> photos;
  @JsonKey(name: 'total_results')
  final int totalResults;
  @JsonKey(name: 'next_page')
  final String? nextPage;

  PexelsResponseModel({
    required this.page,
    required this.perPage,
    required this.photos,
    required this.totalResults,
    this.nextPage,
  });

  factory PexelsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PexelsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PexelsResponseModelToJson(this);
}
