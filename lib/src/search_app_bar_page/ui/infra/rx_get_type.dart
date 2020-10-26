import 'package:flutter/material.dart';
import 'package:get_state_manager/get_state_manager.dart';

typedef AuthFalseWidget = Widget Function();

class RxBoolAuth {
  final RxBool auth;

  final AuthFalseWidget authFalseWidget;

  const RxBoolAuth._(this.auth, this.authFalseWidget)
      : assert(auth != null),
        assert(authFalseWidget != null);

  // assert(tag != null && tag.isNotEmpty);

  const RxBoolAuth.input(
      {@required RxBool rxBoolAuthm, @required AuthFalseWidget authFalseWidget})
      : this._(rxBoolAuthm, authFalseWidget);
}
