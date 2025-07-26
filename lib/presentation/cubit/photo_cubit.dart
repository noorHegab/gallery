import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/photo_repository.dart';
import '../../domain/entities/photo.dart';
import '../../domain/usecases/get_photos_usecase.dart';
import 'photo_state.dart';

@injectable
class PhotoCubit extends Cubit<PhotoState> {
  final GetPhotosUseCase _getPhotosUseCase;
  final PhotoRepository _photoRepository;

  StreamSubscription? _connectivitySubscription;
  int _currentPage = 1;
  bool _hasReachedMax = false;
  List<Photo> _photos = [];

  PhotoCubit(
    this._getPhotosUseCase,
    this._photoRepository,
  ) : super(PhotoInitial()) {
    _listenToConnectivity();
  }

  void _listenToConnectivity() {
    _connectivitySubscription =
        _photoRepository.connectivityStream.listen((isConnected) {
      emit(state.copyWith(isOnline: isConnected));
    });
  }

  Future<void> loadPhotos() async {
    if (state is PhotoLoading) return;

    emit(PhotoLoading(
      photos: _photos,
      isOnline: _photoRepository.isConnected,
    ));

    try {
      final photos = await _getPhotosUseCase(page: 1, limit: 20);
      _photos = photos;
      _currentPage = 1;
      _hasReachedMax = photos.length < 20;

      emit(PhotoLoaded(
        photos: _photos,
        isOnline: _photoRepository.isConnected,
        hasReachedMax: _hasReachedMax,
      ));
    } catch (e) {
      emit(PhotoError(
        message: e.toString(),
        photos: _photos,
        isOnline: _photoRepository.isConnected,
      ));
    }
  }

  Future<void> loadMorePhotos() async {
    if (_hasReachedMax || state is PhotoLoading) return;

    try {
      final newPhotos = await _getPhotosUseCase(
        page: _currentPage + 1,
        limit: 20,
      );

      if (newPhotos.isEmpty) {
        _hasReachedMax = true;
      } else {
        _photos.addAll(newPhotos);
        _currentPage++;
      }

      emit(PhotoLoaded(
        photos: _photos,
        isOnline: _photoRepository.isConnected,
        hasReachedMax: _hasReachedMax,
      ));
    } catch (e) {
      emit(PhotoError(
        message: e.toString(),
        photos: _photos,
        isOnline: _photoRepository.isConnected,
      ));
    }
  }

  Future<void> refreshPhotos() async {
    _currentPage = 1;
    _hasReachedMax = false;
    _photos.clear();
    await loadPhotos();
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
