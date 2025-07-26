import 'package:flutter_test/flutter_test.dart';
import 'package:gallery/data/repositories/photo_repository.dart';
import 'package:gallery/domain/entities/photo.dart';
import 'package:gallery/domain/usecases/get_photos_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_photos_usecase_test.mocks.dart';

@GenerateMocks([PhotoRepository])
void main() {
  late GetPhotosUseCase useCase;
  late MockPhotoRepository mockRepository;

  setUp(() {
    mockRepository = MockPhotoRepository();
    useCase = GetPhotosUseCase(mockRepository);
  });

  const testPhotos = [
    Photo(
      id: 1,
      title: 'Beautiful Landscape',
      url: 'https://images.pexels.com/photos/1/photo1.jpg',
      thumbnailUrl: 'https://images.pexels.com/photos/1/photo1.jpg?h=350',
      photographer: 'John Doe',
      photographerUrl: 'https://www.pexels.com/@johndoe',
    ),
    Photo(
      id: 2,
      title: 'Ocean View',
      url: 'https://images.pexels.com/photos/2/photo2.jpg',
      thumbnailUrl: 'https://images.pexels.com/photos/2/photo2.jpg?h=350',
      photographer: 'Jane Smith',
      photographerUrl: 'https://www.pexels.com/@janesmith',
    ),
  ];

  group('GetPhotosUseCase', () {
    test('should get photos from repository', () async {
      // Arrange
      when(mockRepository.getPhotos(page: 1, limit: 20))
          .thenAnswer((_) async => testPhotos);

      // Act
      final result = await useCase(page: 1, limit: 20);

      // Assert
      expect(result, equals(testPhotos));
      verify(mockRepository.getPhotos(page: 1, limit: 20));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get photos with default parameters', () async {
      // Arrange
      when(mockRepository.getPhotos(page: 1, limit: 20))
          .thenAnswer((_) async => testPhotos);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(testPhotos));
      verify(mockRepository.getPhotos(page: 1, limit: 20));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when repository throws', () async {
      // Arrange
      when(mockRepository.getPhotos(page: 1, limit: 20))
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () async => await useCase(page: 1, limit: 20),
        throwsException,
      );
      verify(mockRepository.getPhotos(page: 1, limit: 20));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
