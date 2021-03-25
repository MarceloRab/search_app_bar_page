import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

typedef AuthFalseWidget = Widget Function();

class RxBoolAuth {
  final RxBool auth;

  final AuthFalseWidget authFalseWidget;

  const RxBoolAuth._(this.auth, this.authFalseWidget);

  const RxBoolAuth.input(
      {required RxBool rxBoolAuthm, required AuthFalseWidget authFalseWidget})
      : this._(rxBoolAuthm, authFalseWidget);
}
