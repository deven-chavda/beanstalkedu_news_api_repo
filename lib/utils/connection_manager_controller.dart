import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'Utils.dart';

// This Controller listen the network state update and update the widget which is listening

class ConnectionManagerController extends GetxController {
  //0 = No Internet, 1 = WIFI Connected ,2 = Mobile Data Connected.
  var connectionType = 0.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;
  var isConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    getConnectivityType();
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(_updateState);
  }

  Future<void> getConnectivityType() async {
    late ConnectivityResult connectivityResult;
    try {
      connectivityResult = await (_connectivity.checkConnectivity());
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return _updateState(connectivityResult);
  }

  _updateState(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        connectionType.value = 1;
        isConnected.value = true;
        break;
      case ConnectivityResult.mobile:
        connectionType.value = 2;
        isConnected.value = true;
        break;
      case ConnectivityResult.none:
        connectionType.value = 0;
        isConnected.value = false;
        break;
      default:
        Utils().showSnackBar('Error', 'Failed to get connection type');
        isConnected.value = false;
        break;
    }
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
  }
}
