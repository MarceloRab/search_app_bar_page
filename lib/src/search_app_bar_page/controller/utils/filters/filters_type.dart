enum FiltersTypes { startsWith, equals, contains }

typedef StringFilter<T> = String? Function(T test);
typedef FunctionRefresh<T> = Future<List<T>> Function();
typedef WhereFilter<T> = bool Function(T test, String? query);
