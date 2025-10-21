mixin StreamSearcherBase<T> {
  void initial(List<T> data);

  void afterConnected();

  void afterData(List<T> data);

  void afterError(Object error);

  void afterDone();

  void afterDisconnected();
}
