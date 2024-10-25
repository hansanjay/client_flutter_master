import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ConnectivityViewModel extends GetxController {

  final Connectivity _connectivity = Connectivity();

  bool? _isOnline;
  bool? get isOnline => _isOnline;

  startMonitoring() async {
    await initConnectivity();
    _connectivity.onConnectivityChanged.listen(
          (
          ConnectivityResult result,
          ) async {
        if (result == ConnectivityResult.none) {
          _isOnline = false;
          update();
        } else {
          await _updateConnectionStatus().then(
                (bool isConnected) {
              _isOnline = isConnected;
              update();
            },
          );
        }
      },
    );
  }

  Future<void> initConnectivity() async {
    try {
      var status = await _connectivity.checkConnectivity();

      if (status == ConnectivityResult.none) {
        _isOnline = false;
        update();
      } else {
        _isOnline = true;
        update();
      }
    } on PlatformException catch (e) {
      log("PlatformException: " + e.toString());
    }
  }

  Future<bool> _updateConnectionStatus() async {
    bool? isConnected;
    try {
      final List<InternetAddress> result =
      await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
    return isConnected!;
  }
}