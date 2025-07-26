import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkService {
  bool get isConnected;
  Stream<bool> get connectivityStream;
  Future<bool> checkConnectivity();
}

@LazySingleton(as: NetworkService)
class NetworkServiceImpl implements NetworkService {
  final Connectivity _connectivity;
  bool _isConnected = true;
  late StreamController<bool> _connectivityController;

  NetworkServiceImpl(this._connectivity) {
    _connectivityController = StreamController<bool>.broadcast();
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  bool get isConnected => _isConnected;

  @override
  Stream<bool> get connectivityStream => _connectivityController.stream;

  @override
  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    final isConnected = result != ConnectivityResult.none;
    _updateConnectionStatus(result);
    return isConnected;
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (_) {
      _isConnected = false;
      _connectivityController.add(false);
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final wasConnected = _isConnected;
    _isConnected = result != ConnectivityResult.none;

    if (wasConnected != _isConnected) {
      _connectivityController.add(_isConnected);
    }
  }

  void dispose() {
    _connectivityController.close();
  }
}
