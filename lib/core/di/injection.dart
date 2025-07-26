import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasources/api_service.dart';
import '../config/env_config.dart';
import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.baseUrl = EnvConfig.pexelsBaseUrl;

    // Add Pexels API key to headers
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = EnvConfig.pexelsApiKey;
          handler.next(options);
        },
        onError: (error, handler) {
          // Log API errors for debugging
          print('API Error: ${error.response?.statusCode} - ${error.message}');
          if (error.response?.statusCode == 401) {
            print(
                'Invalid API Key. Please check your Pexels API key in EnvConfig.');
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  @lazySingleton
  ApiService apiService(Dio dio) => ApiService(dio);

  @lazySingleton
  Connectivity get connectivity => Connectivity();
}
