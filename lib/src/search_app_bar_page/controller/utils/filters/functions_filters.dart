import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

typedef Filter<T> = bool Function(T test, String? query);
typedef SortList<T> = int Function(T a, T b);

//typedef StringFilter<T> = String Function(T test);

//typedef Compare<T> = int Function(T a, T b);

//typedef WidgetsListBuilder<T> = Widget Function(
//BuildContext context, RxList<T> list, bool isModSearch);

typedef OnSubmitted<T> = Function(
    String query, List<T> listFiltered, int highLightIndex);

typedef OnEnter<T> = Function(List<T> listFull, int highLightIndex);

typedef WidgetsListBuilder<T> = Widget Function(
    BuildContext context, List<T> list, bool isModSearch, int highLightIndex);

typedef WidgetsErrorBuilder<T> = Widget Function(Object? error);

typedef WidgetsPaginationItemBuilder<T> = Widget Function(
    BuildContext context, int index, T objectIndex);

typedef FutureFetchPageItems<T> = Future<List<T>> Function(
    int page, String? query);

class Filters {
  static Filter<String?> startsWith = (test, query) {
    if (test == null) {
      return false;
    }
    final realTest = _prepareString(test);
    final realQuery = _prepareString(query!);
    return realTest.startsWith(realQuery);
  };

  static Filter<String?> equals = (test, query) {
    if (test == null) {
      return false;
    }
    final realTest = _prepareString(test);
    final realQuery = _prepareString(query!);
    return realTest == realQuery;
  };

  static Filter<String?> contains = (test, query) {
    if (test == null) {
      return false;
    }
    final realTest = _prepareString(test);
    final realQuery = _prepareString(query!);
    return realTest.contains(realQuery);
  };

  static String _prepareString(String string) =>
      removeDiacritics(string).toLowerCase();
}

/*
class Compares {
  static Compare<String> sortByString = (a, b) => a.compareTo(b);
  static Compare<num> sortByNum = (a, b) => a.compareTo(b);

//static Compare<int> sortByInt = (a, b) => a.compareTo(b);
//static Compare<double> sortBydDouble = ( a, b) => a.compareTo(b);
}
*/
