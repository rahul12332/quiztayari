import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetService with ChangeNotifier {
  static bool isInternetAvailable = true; // Global variable

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  InternetService() {
    _checkInternetInitially(); // Initial check
    _startMonitoring(); // Start listening in the background
  }

  Future<void> _checkInternetInitially() async {
    List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    _updateStatus(results);
  }

  void _startMonitoring() {
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      _updateStatus(results);
    });
  }

  void _updateStatus(List<ConnectivityResult> results) {
    bool newStatus = results.any((result) => result != ConnectivityResult.none);
    if (isInternetAvailable != newStatus) {
      isInternetAvailable = newStatus;
      notifyListeners(); // Notify UI when status changes
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
