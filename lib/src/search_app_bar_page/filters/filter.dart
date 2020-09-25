import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

//enum ComparesTypes { string, number }

typedef bool Filter<T>(T test, String query);

typedef String StringFilter<T>(T test);

typedef int Compare<T>(T a, T b);

typedef bool Funcion(bool isModSearch);

typedef Widget FunctionList<T>(List<T> list, bool isModSearch);


class Filters {
  /// returns if [test] starts with the given [query],
  /// disregarding lower/upper case and diacritics.
  static Filter<String> startsWith = (test, query) {
    final realTest = _prepareString(test);
    final realQuery = _prepareString(query);
    return realTest.startsWith(realQuery);
  };

  /// returns if [test] is exactly the same as [query],
  /// disregarding lower/upper case and diacritics.
  static Filter<String> equals = (test, query) {
    final realTest = _prepareString(test);
    final realQuery = _prepareString(query);
    return realTest == realQuery;
  };

  /// returns if [test] contains the given [query],
  /// disregarding lower/upper case and diacritics.
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
