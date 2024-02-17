import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_base_control.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/filters_type.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/infra/search_stream_page_base.dart';

class SearcherPageStreamController<T> extends SearcherBase<T>
    with StreamSearcherBase<T> {
  final RxBool _isModSearch = false.obs;

  @override
  bool get isModSearch => _isModSearch.value;

  @override
  set isModSearch(bool value) => _isModSearch.value = value;

  @override
  final rxSearch = ''.obs;
  @override
  bool? sortCompare = true;

  FiltersTypes? filtersType;
  late Filter<String?> _filters;
  StringFilter<T>? stringFilter;
  SortList<T>? sortFunction;
  Filter<T>? filter;

  //Compare<T> compareSort;
  bool haveInitialData = false;

  //Worker _worker;

  final Rx<AsyncSnapshot<List<T>>> _rxSnapshot =
      AsyncSnapshot<List<T>>.waiting().obs;

  //AsyncSnapshot<List<T>>.withData(ConnectionState.none, null).obs;

  AsyncSnapshot<List<T>> get snapshot => _rxSnapshot.value;

  set snapshot(AsyncSnapshot<List<T>> value) => _rxSnapshot.value = value;

  //StringFilter<T> get _defaultFilter => (T value) => value as String;

  SearcherPageStreamController({
    //@required this.listStream,
    this.stringFilter,
    this.sortCompare,
    this.filter,
    this.sortFunction,
    this.filtersType = FiltersTypes.contains,
  }) {
    if (stringFilter == null) {
      if (T == String) {
        //stringFilter = _defaultFilter;
        stringFilter = (T value) => value as String;
      } else {
        if (filter == null) {
          throw Exception(
              'If you dont want to filter by a String, it is necessary '
              'to add the filtering function.');
        }
        /*else if (sortFunction == null) {
          throw Exception(
              'You choose to sort your list. Need to add the order function.');
        }*/
        /*throw Exception(
            'You need to construct your object s return String in the '
            'stringFilter function. If there is no return String, your '
            'list object must be a String.');*/
      }
    }

    if (stringFilter != null && filter != null) {
      throw Exception(
          'You need to choose between one of the filtering mechanisms.');
    }
    /*if (stringFilter == null) {
      if (T == String) {
        //stringFilter = _defaultFilter;
        stringFilter = (T value) => value as String;
      } else {
        throw Exception(
            'You need to construct your object s return String in the '
            'stringFilter function. If there is no return String, your '
            'list object must be a String.');
      }
    }*/
  }

  var listFull = <T>[];

  /*set initialChangeList(List<T> list) {
    if (!bancoInitValue) {
      bancoInitValue = true;
      if (bancoInit.canUpdate) {
        bancoInit.close();
      }
    }

    listFull = list;
    sortCompareList(listFull);
    //onSearchList(list);
    rxSearch('');
  }*/

  void onInitFilter() {
    if (stringFilter != null || T == String) {
      if (filtersType.toString() == FiltersTypes.startsWith.toString()) {
        _filters = Filters.startsWith;
      } else if (filtersType.toString() == FiltersTypes.equals.toString()) {
        _filters = Filters.equals;
      } else {
        _filters = Filters.contains;
      }
    }
  }

  List<T> refreshSeachList2(String? value) {
    var list = <T>[];

    if (stringFilter != null || T == String) {
      list = listFull
          .where((element) => _filters(stringFilter!(element), value))
          .toList();
    } else {
      if (value!.isEmpty)
        list = listFull;
      else
        list = listFull.where((element) => filter!(element, value)).toList();
    }
    sortCompareList(list);

    return list;
  }

  /*List<T> refreshSeachList2(String? value) {
    final list = listFull
        .where((element) => _filters(stringFilter!(element), value))
        .toList();
    sortCompareList(list);

    return list;
  }*/

  @override
  void sortCompareList(List<T> list) {
    if (sortFunction != null) {
      list.sort(sortFunction);
    } else if (sortCompare!) {
      if (stringFilter != null || T == String) {
        list.sort((a, b) => stringFilter!(a)!.compareTo(stringFilter!(b)!));
      }
    }
  }

  /* @override
  void sortCompareList(List<T> list) {
    */ /*if (compareSort != null) {
      list.sort(compareSort);
    }*/ /*

    if (sortCompare!) {
      list.sort((a, b) => stringFilter!(a)!.compareTo(stringFilter!(b)!));
    }
  }*/

  FutureOr onClose() {
    _isModSearch.close();
    rxSearch.close();
    _rxSnapshot.close();
    bancoInit.close();
  }

  @override
  void initial(List<T> data) =>
      snapshot = AsyncSnapshot<List<T>>.withData(ConnectionState.none, data);

  @override
  void afterData(List<T> data) => snapshot =
      snapshot = AsyncSnapshot<List<T>>.withData(ConnectionState.active, data);

  @override
  void afterDisconnected() => snapshot = snapshot.inState(ConnectionState.none);

  @override
  void afterDone() => snapshot = snapshot.inState(ConnectionState.done);

  @override
  void afterError(Object error) => snapshot =
      AsyncSnapshot<List<T>>.withError(ConnectionState.active, error);

  @override
  void afterConnected() => snapshot = snapshot.inState(ConnectionState.waiting);
}
