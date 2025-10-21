typedef FutureFetchPageItems<T> = Future<List<T>> Function(
    int page, String query);

void runFuturePagination<T>(FutureFetchPageItems<T> futureFunction) {
  //futureFunction().then((value) => null);
}
