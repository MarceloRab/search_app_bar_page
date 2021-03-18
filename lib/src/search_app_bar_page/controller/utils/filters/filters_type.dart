enum FiltersTypes { startsWith, equals, contains }
typedef StringFilter<T> = String? Function(T test);
typedef FuncionRefresh<T> = Future<List<T>> Function();
