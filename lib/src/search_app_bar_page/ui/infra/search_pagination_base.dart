mixin SearcherPaginnationBase<T> {
  void inState();

  void waiting();

  void withData(List<T> data);

  void withError(Object error);

  void togleLoadingSearchScroll();

  void togleLoadinglistFullScroll();
}
