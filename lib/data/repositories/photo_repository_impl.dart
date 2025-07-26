import 'package:gallery/data/repositories/photo_repository.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/photo.dart';
import '../datasources/local_data_source.dart';
import '../datasources/network_service.dart';
import '../datasources/remote_data_source.dart';

@LazySingleton(as: PhotoRepository)
class PhotoRepositoryImpl implements PhotoRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkService _networkService;

  PhotoRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkService,
  );

  @override
  Future<List<Photo>> getPhotos({int page = 1, int limit = 20}) async {
    try {
      if (_networkService.isConnected) {
        // Fetch from API
        final photoModels =
            await _remoteDataSource.getPhotos(page: page, limit: limit);
        final photos = photoModels.map((model) => model.toEntity()).toList();

        // Cache the data
        if (page == 1) {
          await _localDataSource.cachePhotos(photoModels);
        }

        return photos;
      } else {
        // Return cached data when offline
        final cachedModels = await _localDataSource.getCachedPhotos();
        return cachedModels.map((model) => model.toEntity()).toList();
      }
    } catch (e) {
      // If API fails, try to return cached data
      final cachedModels = await _localDataSource.getCachedPhotos();
      if (cachedModels.isNotEmpty) {
        return cachedModels.map((model) => model.toEntity()).toList();
      }
      rethrow;
    }
  }

  @override
  Stream<bool> get connectivityStream => _networkService.connectivityStream;

  @override
  bool get isConnected => _networkService.isConnected;
}
