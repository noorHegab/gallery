import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/pexels_response_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: 'https://api.pexels.com/v1/')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/curated')
  Future<PexelsResponseModel> getCuratedPhotos({
    @Query('page') int page = 1,
    @Query('per_page') int perPage = 20,
  });

  @GET('/search')
  Future<PexelsResponseModel> searchPhotos({
    @Query('query') required String query,
    @Query('page') int page = 1,
    @Query('per_page') int perPage = 20,
  });
}
