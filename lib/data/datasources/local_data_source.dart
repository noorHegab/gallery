import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../models/photo_model.dart';

abstract class LocalDataSource {
  Future<List<PhotoModel>> getCachedPhotos();
  Future<void> cachePhotos(List<PhotoModel> photos);
  Future<void> clearCache();
}

@LazySingleton(as: LocalDataSource)
class LocalDataSourceImpl implements LocalDataSource {
  static const String _photosBoxName = 'photos';

  @override
  Future<List<PhotoModel>> getCachedPhotos() async {
    final box = await Hive.openBox<PhotoModel>(_photosBoxName);
    return box.values.toList();
  }

  @override
  Future<void> cachePhotos(List<PhotoModel> photos) async {
    final box = await Hive.openBox<PhotoModel>(_photosBoxName);
    await box.clear();
    for (int i = 0; i < photos.length; i++) {
      await box.put(i, photos[i]);
    }
  }

  @override
  Future<void> clearCache() async {
    final box = await Hive.openBox<PhotoModel>(_photosBoxName);
    await box.clear();
  }
}
