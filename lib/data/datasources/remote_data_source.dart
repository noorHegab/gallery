import 'package:injectable/injectable.dart';

import '../models/photo_model.dart';
import 'api_service.dart';

abstract class RemoteDataSource {
  Future<List<PhotoModel>> getPhotos({int page = 1, int limit = 20});
}

@LazySingleton(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final ApiService _apiService;

  RemoteDataSourceImpl(this._apiService);

  @override
  Future<List<PhotoModel>> getPhotos({int page = 1, int limit = 20}) async {
    final response = await _apiService.getCuratedPhotos(
      page: page,
      perPage: limit,
    );
    return response.photos;
  }
}
