mixin SearcherPaginnationBase<T> {
  void inState();

  void waiting();

  void withData(List<T> data);

  void withError(Object error);

  void togleLoadingSearchScroll(bool value);

  void togleLoadinglistFullScroll();
}
