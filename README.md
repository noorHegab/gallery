# Photo Gallery App

A Flutter application that displays a photo gallery using **Pexels API** with Clean Architecture principles, offline support, and dark/light theme switching.

## Features

- 📱 **Photo Gallery**: Display high-quality photos from Pexels API
- 🏗️ **Clean Architecture**: Organized in data, domain, and presentation layers
- 🎯 **State Management**: Using Cubit (Flutter Bloc)
- 💾 **Offline Support**: Cache photos with Hive for offline viewing
- 🖼️ **Image Caching**: Cached network images for better performance
- 🌐 **Network Status**: Visual indicator showing online/offline status
- 🌙 **Theme Support**: Dark and light mode with persistence
- 🔄 **Pagination**: Infinite scrolling for loading more photos
- 🧪 **Unit Tests**: Comprehensive test coverage for business logic
- 📸 **Photographer Credits**: Display photographer information with each photo

## API Setup

This app uses the **Pexels API** to fetch high-quality photos. To set up:

1. **Get a Free API Key**:
    - Visit [Pexels API](https://www.pexels.com/api/)
    - Sign up for a free account
    - Generate your API key

2. **Configure API Key**:
    - Open `lib/core/config/env_config.dart`
    - Replace `YOUR_PEXELS_API_KEY_HERE` with your actual API key:
   ```dart
   static const String pexelsApiKey = 'your-actual-api-key-here';
   ```

3. **API Limits**:
    - Free tier: 200 requests per hour, 20,000 requests per month
    - Rate limits are handled gracefully in the app

## Architecture

The application follows Clean Architecture principles with three main layers:

### 1. Presentation Layer (`lib/presentation/`)
- **Screens**: UI screens (PhotoListScreen)
- **Widgets**: Reusable UI components (PhotoGridItem, NetworkStatusBanner)
- **Cubit**: State management for UI logic (PhotoCubit, ThemeCubit)

### 2. Domain Layer (`lib/domain/`)
- **Entities**: Core business objects (Photo)
- **Repositories**: Abstract interfaces (PhotoRepository)
- **Use Cases**: Business logic (GetPhotosUseCase)

### 3. Data Layer (`lib/data/`)
- **Models**: Data transfer objects (PhotoModel, PexelsResponseModel)
- **Data Sources**:
    - Remote: Pexels API service using Retrofit
    - Local: Hive database for caching
- **Repositories**: Implementation of domain repositories

### Data Flow

```
UI -> Cubit -> UseCase -> Repository -> DataSource (Remote/Local) -> Pexels API/Cache
```

## Dependencies

### Core Dependencies
- `flutter_bloc: ^8.1.3` - State management with Cubit
- `injectable: ^2.3.2` & `get_it: ^7.6.4` - Dependency injection
- `retrofit: ^4.0.3` & `dio: ^5.3.2` - HTTP client
- `json_serializable: ^6.7.1` - JSON serialization
- `hive: ^2.2.3` & `hive_flutter: ^1.1.0` - Local storage/caching
- `cached_network_image: ^3.3.0` - Image caching
- `connectivity_plus: ^5.0.1` - Network connectivity monitoring
- `shared_preferences: ^2.2.2` - Theme persistence

### Development Dependencies
- `build_runner: ^2.4.7` - Code generation
- `retrofit_generator: ^8.0.4` - Retrofit code generation
- `injectable_generator: ^2.4.1` - DI code generation
- `hive_generator: ^2.0.1` - Hive adapters generation
- `mockito: ^5.4.2` & `bloc_test: ^9.1.4` - Testing

## Setup Instructions

### 1. Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)

### 2. Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd photo_gallery_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. **Configure Pexels API Key**:
    - Get your free API key from [Pexels API](https://www.pexels.com/api/)
    - Open `lib/core/config/env_config.dart`
    - Replace `YOUR_PEXELS_API_KEY_HERE` with your actual API key

4. Generate required code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Running the App

```bash
flutter run
```

### 4. Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Project Structure

```
lib/
├── core/
│   ├── config/                 # Configuration
│   │   └── env_config.dart
│   ├── di/                     # Dependency Injection
│   │   ├── injection.dart
│   │   └── injection.config.dart
│   └── theme/                  # App Themes
│       └── app_theme.dart
├── data/
│   ├── datasources/            # Data Sources
│   │   ├── api_service.dart
│   │   ├── local_data_source.dart
│   │   ├── remote_data_source.dart
│   │   └── network_service.dart
│   ├── models/                 # Data Models
│   │   ├── photo_model.dart
│   │   └── pexels_response_model.dart
│   └── repositories/           # Repository Implementations
│       └── photo_repository_impl.dart
├── domain/
│   ├── entities/               # Business Entities
│   │   └── photo.dart
│   ├── repositories/           # Repository Interfaces
│   │   └── photo_repository.dart
│   └── usecases/               # Business Logic
│       └── get_photos_usecase.dart
├── presentation/
│   ├── cubit/                  # State Management
│   │   ├── photo_cubit.dart
│   │   ├── photo_state.dart
│   │   └── theme_cubit.dart
│   ├── screens/                # UI Screens
│   │   └── photo_list_screen.dart
        └── splash_screen.dart
│   └── widgets/                # Reusable Widgets
│       ├── photo_grid_item.dart
│       └── network_status_banner.dart
└── main.dart                   # App Entry Point
```

## Screenshots

### Light Mode (Online)
The main photo gallery screen displaying high-quality photos fetched from Pexels API in light theme mode. Shows a grid layout with photo thumbnails, titles, and photographer credits, along with a green "Online" status banner at the top.

### Dark Mode (Online)
The same photo gallery screen but in dark theme mode. The interface adapts to dark colors while maintaining the same functionality and layout, showcasing beautiful Pexels photography.

### Light Mode (Offline/Cached)
Shows the app in offline mode with an orange "Offline - Showing cached photos" banner. Previously loaded Pexels photos are still displayed from the local cache.

### Dark Mode (Offline/Cached)
The offline state in dark theme, demonstrating that cached Pexels photos remain accessible even without internet connectivity.

### Loading State
Displays a centered circular progress indicator while photos are being fetched from the Pexels API.

### Error State
Shows an error screen with an error icon, error message, and a "Retry" button when Pexels API calls fail and no cached data is available.

### Photo Display
Each photo card shows:
- High-quality thumbnail from Pexels
- Photo title/description (if available)
- Photographer name with camera icon
- Smooth loading animations

### Network Status Indicators
- **Online**: Green banner with wifi icon showing "Online"
- **Offline**: Orange banner with wifi-off icon showing "Offline - Showing cached photos"

## Key Features Implementation

### Clean Architecture
The app strictly follows Clean Architecture principles:
- **Separation of Concerns**: Each layer has distinct responsibilities
- **Dependency Rule**: Dependencies point inward (Presentation -> Domain <- Data)
- **Testability**: Business logic is isolated and easily testable

### State Management with Cubit
- `PhotoCubit`: Manages photo loading, pagination, and error states
- `ThemeCubit`: Handles theme switching and persistence
- Reactive UI updates based on state changes

### Offline Support
- **Data Caching**: Photos are cached locally using Hive database
- **Image Caching**: Images are cached using `cached_network_image`
- **Graceful Fallback**: App shows cached data when offline
- **Network Monitoring**: Real-time connectivity status updates

### Repository Pattern
- Abstract repository interfaces in domain layer
- Concrete implementations in data layer
- Handles data source switching (remote vs local)
- Error handling and fallback mechanisms

### Dependency Injection
- Uses `injectable` and `get_it` for DI
- Automatic code generation for dependency registration
- Singleton and factory patterns for different service types

### Theme Management
- Material 3 design system
- Persistent theme selection using SharedPreferences
- Smooth theme transitions
- Consistent styling across light and dark modes

## Testing

The app includes comprehensive unit tests covering:

### 1. Cubit Tests (`test/presentation/cubit/`)
- State transitions testing
- Error handling verification
- Loading and success scenarios
- Network connectivity state changes

### 2. Use Case Tests (`test/domain/usecases/`)
- Business logic validation
- Repository interaction testing
- Error propagation testing

### 3. Repository Tests (`test/data/repositories/`)
- Data source coordination testing
- Caching logic verification
- Network availability handling
- Error fallback scenarios

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/presentation/cubit/photo_cubit_test.dart

# Run with coverage report
flutter test --coverage
lcov --summary coverage/lcov.info
```

## Error Handling

The app implements robust error handling:
- **Network Errors**: Fallback to cached data
- **API Failures**: User-friendly error messages with retry options
- **Cache Errors**: Graceful degradation
- **Loading States**: Clear visual feedback during operations

## Performance Optimizations

- **Image Caching**: Reduces network calls and improves loading speed
- **Pagination**: Loads photos incrementally to reduce initial load time
- **Lazy Loading**: Images load on demand as user scrolls
- **Memory Management**: Proper disposal of controllers and streams

## Future Enhancements

Potential improvements for the app:
- Photo detail view with full-size images
- Search and filter functionality
- User favorites/bookmarks
- Photo sharing capabilities
- Better error retry mechanisms
- Progressive image loading
- Accessibility improvements

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

