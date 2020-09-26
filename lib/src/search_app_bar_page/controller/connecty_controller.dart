import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:get_state_manager/get_state_manager.dart';

class ConnectyController {
  //final StreamController<bool> _connecTyController =
  //StreamController.broadcast();
  //Sink get connectySink => _connecTyController.sink;

  //Stream<bool> get connectyStream => _connecTyController.stream;

  Connectivity connectivity;

  final RxBool _connecTyController = true.obs;

  bool get isConnected => _connecTyController.value;

  set isConnected(bool value) => _connecTyController.value = value;

  Stream<bool> get connectyStream => _connecTyController.stream;

  StreamSubscription _subscriptionConnecty;

  ConnectyController() {
    connectivity = Connectivity();
    initialiseTestInterGeral();
  }

  Future<void> initialiseTestInterGeral() async {
    _subscriptionConnecty = connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  Future<void> _checkStatus(ConnectivityResult result) async {
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
  }

  FutureOr<void> onClose() async {
    _connecTyController.close();
    _subscriptionConnecty?.cancel();
  }
}
