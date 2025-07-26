import 'package:injectable/injectable.dart';

import '../../data/repositories/photo_repository.dart';
import '../entities/photo.dart';

@injectable
class GetPhotosUseCase {
  final PhotoRepository _repository;

  GetPhotosUseCase(this._repository);

  Future<List<Photo>> call({int page = 1, int limit = 20}) async {
    return await _repository.getPhotos(page: page, limit: limit);
  }
}
