import 'dart:async';
//import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:get_state_manager/get_state_manager.dart';

class ConnectController {
  Connectivity connectivity;

  final RxBool _connectController = true.obs;

  bool get isConnected => _connectController.value;

  set isConnected(bool value) => _connectController.value = value;

  Stream<bool> get connectStream => _connectController.stream;

  StreamSubscription _subscriptionConnect;

  ConnectController() {
    connectivity = Connectivity();
    initialiseTestInterGeral();
  }

  Future<void> initialiseTestInterGeral() async {
    _subscriptionConnect = connectivity.onConnectivityChanged.listen((result) {
      //_checkStatus(result);
      _checkInternet();
    });
  }

  Future<void> _checkInternet() async {
    bool isOnline = false;
    final result = await connectivity.checkConnectivity();

    if (result == ConnectivityResult.none) {
      isOnline = false;
    } else if (result == ConnectivityResult.mobile) {
      isOnline = true;
    } else if (result == ConnectivityResult.wifi) {
      isOnline = true;
    }
    isConnected = isOnline;
  }

  /*Future<void> _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }

    isConnected = isOnline;
  }*/

  FutureOr<void> onClose() async {
    _connectController.close();
    _subscriptionConnect?.cancel();
  }
}
