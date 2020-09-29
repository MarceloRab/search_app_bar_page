import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

typedef Filter<T> = bool Function(T test, String query);

typedef StringFilter<T> = String Function(T test);

typedef Compare<T> = int Function(T a, T b);

typedef FunctionList<T> = Widget Function(
    BuildContext context, List<T> list, bool isModSearch);

class Filters {
  static Filter<String> startsWith = (test, query) {
    final realTest = _prepareString(test);
    final realQuery = _prepareString(query);
    return realTest.startsWith(realQuery);
  };

  static Filter<String> equals = (test, query) {
    final realTest = _prepareString(test);
    final realQuery = _prepareString(query);
    return realTest == realQuery;
  };

  static Filter<String> contains = (test, query) {
    final realTest = _prepareString(test);
    final realQuery = _prepareString(query);
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
