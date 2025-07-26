import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/photo_cubit.dart';
import '../cubit/photo_state.dart';
import '../cubit/theme_cubit.dart';
import '../widgets/network_status_banner.dart';
import '../widgets/photo_grid_item.dart';

class PhotoListScreen extends StatefulWidget {
  const PhotoListScreen({super.key});

  @override
  State<PhotoListScreen> createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PhotoCubit>().loadPhotos();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PhotoCubit>().loadMorePhotos();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return IconButton(
                icon: Icon(
                  themeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const NetworkStatusBanner(),
          Expanded(
            child: BlocBuilder<PhotoCubit, PhotoState>(
              builder: (context, state) {
                if (state is PhotoInitial ||
                    (state is PhotoLoading && state.photos.isEmpty)) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is PhotoError && state.photos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading photos',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<PhotoCubit>().loadPhotos(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => context.read<PhotoCubit>().refreshPhotos(),
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: state.photos.length +
                        (state is PhotoLoaded && !state.hasReachedMax ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.photos.length) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final photo = state.photos[index];
                      return PhotoGridItem(photo: photo);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
