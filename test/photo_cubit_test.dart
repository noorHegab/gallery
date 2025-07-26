import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery/data/repositories/photo_repository.dart';
import 'package:gallery/domain/entities/photo.dart';
import 'package:gallery/domain/usecases/get_photos_usecase.dart';
import 'package:gallery/presentation/cubit/photo_cubit.dart';
import 'package:gallery/presentation/cubit/photo_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'photo_cubit_test.mocks.dart';

@GenerateMocks([GetPhotosUseCase, PhotoRepository])
void main() {
  late PhotoCubit photoCubit;
  late MockGetPhotosUseCase mockGetPhotosUseCase;
  late MockPhotoRepository mockPhotoRepository;

  setUp(() {
    mockGetPhotosUseCase = MockGetPhotosUseCase();
    mockPhotoRepository = MockPhotoRepository();
    photoCubit = PhotoCubit(mockGetPhotosUseCase, mockPhotoRepository);
  });

  tearDown(() {
    photoCubit.close();
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

  group('PhotoCubit', () {
    test('initial state is PhotoInitial', () {
      expect(photoCubit.state, equals(const PhotoInitial()));
    });

    blocTest<PhotoCubit, PhotoState>(
      'emits [PhotoLoading, PhotoLoaded] when loadPhotos is successful',
      build: () {
        when(mockPhotoRepository.isConnected).thenReturn(true);
        when(mockPhotoRepository.connectivityStream)
            .thenAnswer((_) => Stream.value(true));
        when(mockGetPhotosUseCase(page: 1, limit: 20))
            .thenAnswer((_) async => testPhotos);
        return photoCubit;
      },
      act: (cubit) => cubit.loadPhotos(),
      expect: () => [
        const PhotoLoading(photos: [], isOnline: true),
        PhotoLoaded(
          photos: testPhotos,
          isOnline: true,
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<PhotoCubit, PhotoState>(
      'emits [PhotoLoading, PhotoError] when loadPhotos fails',
      build: () {
        when(mockPhotoRepository.isConnected).thenReturn(true);
        when(mockPhotoRepository.connectivityStream)
            .thenAnswer((_) => Stream.value(true));
        when(mockGetPhotosUseCase(page: 1, limit: 20))
            .thenThrow(Exception('Network error'));
        return photoCubit;
      },
      act: (cubit) => cubit.loadPhotos(),
      expect: () => [
        const PhotoLoading(photos: [], isOnline: true),
        const PhotoError(
          message: 'Exception: Network error',
          photos: [],
          isOnline: true,
        ),
      ],
    );

    blocTest<PhotoCubit, PhotoState>(
      'emits PhotoLoaded with additional photos when loadMorePhotos is successful',
      build: () {
        when(mockPhotoRepository.isConnected).thenReturn(true);
        when(mockPhotoRepository.connectivityStream)
            .thenAnswer((_) => Stream.value(true));
        when(mockGetPhotosUseCase(page: 1, limit: 20))
            .thenAnswer((_) async => [testPhotos.first]);
        when(mockGetPhotosUseCase(page: 2, limit: 20))
            .thenAnswer((_) async => [testPhotos.last]);
        return photoCubit;
      },
      act: (cubit) async {
        await cubit.loadPhotos();
        await cubit.loadMorePhotos();
      },
      expect: () => [
        const PhotoLoading(photos: [], isOnline: true),
        PhotoLoaded(
          photos: [testPhotos.first],
          isOnline: true,
          hasReachedMax: false,
        ),
        PhotoLoaded(
          photos: testPhotos,
          isOnline: true,
          hasReachedMax: false,
        ),
      ],
    );
  });
}
