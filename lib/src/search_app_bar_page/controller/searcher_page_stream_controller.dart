import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_state_manager/get_state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/seacher_base_controll.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/filters_type.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/infra/search_stream_page_base.dart';

class SearcherPageStreamController<T> extends SeacherBase
    with StreamSearcherBase<T> {
  final RxBool _isModSearch = false.obs;

  @override
  bool get isModSearch => _isModSearch.value;

  @override
  set isModSearch(bool value) => _isModSearch.value = value;

  @override
  // ignore: overridden_fields
  final rxSearch = ''.obs;

  //final RxList<T> listSearch = <T>[].obs;

  //Function(Iterable<T>) get onSearchList => listSearch.assignAll;

  FiltersTypes filtersType;
  Filter<String> _filters;
  StringFilter<T> stringFilter;

  Compare<T> compareSort;
  bool haveInitialData = false;

  Worker _worker;

  final Rx<AsyncSnapshot<List<T>>> _rxSnapshot =
      AsyncSnapshot<List<T>>.waiting().obs;

  //AsyncSnapshot<List<T>>.withData(ConnectionState.none, null).obs;

  AsyncSnapshot<List<T>> get snapshot => _rxSnapshot.value;

  set snapshot(AsyncSnapshot<List<T>> value) => _rxSnapshot.value = value;

  StringFilter<T> get _defaultFilter => (T value) => value as String;

  SearcherPageStreamController({
    //@required this.listStream,
    this.stringFilter,
    this.compareSort,
    this.filtersType = FiltersTypes.contains,
  }) {
    if (stringFilter == null) {
      if (T == String) {
        stringFilter = _defaultFilter;
      } else {
        throw Exception(
            'You need to type your page or it must be typed as String');
      }
    }
  }

  var listFull = <T>[];

  set initialChangeList(List<T> list) {
    if (!bancoInit) {
      bancoInit = true;
      _bancoInit.close();
    }

    listFull = list;
    sortCompareList(listFull);
    //onSearchList(list);
    rxSearch('');
  }

  final RxBool _bancoInit = false.obs;

  @override
  set bancoInit(bool value) => _bancoInit.value = value;

  @override
  bool get bancoInit => _bancoInit.value;

  void onInitFilter() {
    if (filtersType.toString() == FiltersTypes.startsWith.toString()) {
      _filters = Filters.startsWith;
    } else if (filtersType.toString() == FiltersTypes.equals.toString()) {
      _filters = Filters.equals;
    } else {
      _filters = Filters.contains;
    }
  }

  void bancoInitClose() {
    _bancoInit.close();
  }

  List<T> refreshSeachList2(String value) {
    final list = listFull
        .where((element) => _filters(stringFilter(element), value))
        .toList();
    sortCompareList(list);

    return list;
  }

  void sortCompareList(List<T> list) {
    if (compareSort != null) {
      list.sort(compareSort);
    }
  }

  FutureOr onClose() {
    _worker?.dispose();
    _isModSearch.close();
    rxSearch.close();
    //listSearch.close();
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
