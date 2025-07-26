import 'package:equatable/equatable.dart';

import '../../domain/entities/photo.dart';

abstract class PhotoState extends Equatable {
  final List<Photo> photos;
  final bool isOnline;

  const PhotoState({
    required this.photos,
    required this.isOnline,
  });

  PhotoState copyWith({
    List<Photo>? photos,
    bool? isOnline,
  });

  @override
  List<Object?> get props => [photos, isOnline];
}

class PhotoInitial extends PhotoState {
  const PhotoInitial() : super(photos: const [], isOnline: true);

  @override
  PhotoState copyWith({List<Photo>? photos, bool? isOnline}) {
    return PhotoInitial();
  }
}

class PhotoLoading extends PhotoState {
  const PhotoLoading({
    required super.photos,
    required super.isOnline,
  });

  @override
  PhotoState copyWith({List<Photo>? photos, bool? isOnline}) {
    return PhotoLoading(
      photos: photos ?? this.photos,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

class PhotoLoaded extends PhotoState {
  final bool hasReachedMax;

  const PhotoLoaded({
    required super.photos,
    required super.isOnline,
    required this.hasReachedMax,
  });

  @override
  PhotoState copyWith(
      {List<Photo>? photos, bool? isOnline, bool? hasReachedMax}) {
    return PhotoLoaded(
      photos: photos ?? this.photos,
      isOnline: isOnline ?? this.isOnline,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [photos, isOnline, hasReachedMax];
}

class PhotoError extends PhotoState {
  final String message;

  const PhotoError({
    required this.message,
    required super.photos,
    required super.isOnline,
  });

  @override
  PhotoState copyWith({List<Photo>? photos, bool? isOnline, String? message}) {
    return PhotoError(
      message: message ?? this.message,
      photos: photos ?? this.photos,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  List<Object?> get props => [message, photos, isOnline];
}
