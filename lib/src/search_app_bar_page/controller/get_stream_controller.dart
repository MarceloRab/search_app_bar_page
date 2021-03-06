import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetStreamController<T> implements StreamSearcherBase<T> {
  final Rx<AsyncSnapshot<T>> _rxSnapshot = AsyncSnapshot<T>.waiting().obs;

  AsyncSnapshot<T> get snapshot => _rxSnapshot.value;

  set snapshot(AsyncSnapshot<T> value) => _rxSnapshot.value = value;

  @override
  void initial(T data) =>
      snapshot = AsyncSnapshot<T>.withData(ConnectionState.none, data);

  @override
  void afterData(T data) => snapshot =
      snapshot = AsyncSnapshot<T>.withData(ConnectionState.active, data);

  @override
  void afterDisconnected() => snapshot = snapshot.inState(ConnectionState.none);

  @override
  void afterDone() => snapshot = snapshot.inState(ConnectionState.done);

  @override
  void afterError(Object error) =>
      snapshot = AsyncSnapshot<T>.withError(ConnectionState.active, error);

  @override
  void afterConnected() => snapshot = snapshot.inState(ConnectionState.waiting);

  void onClose() {
    _rxSnapshot.close();
  }
}

mixin StreamSearcherBase<T> {
  void initial(T data);

  void afterConnected();

  void afterData(T data);

  void afterError(Object error);

  void afterDone();

  void afterDisconnected();
}
