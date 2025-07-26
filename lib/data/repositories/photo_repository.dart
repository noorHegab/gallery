import '../../domain/entities/photo.dart';

abstract class PhotoRepository {
  Future<List<Photo>> getPhotos({int page = 1, int limit = 20});
  Stream<bool> get connectivityStream;
  bool get isConnected;
}
