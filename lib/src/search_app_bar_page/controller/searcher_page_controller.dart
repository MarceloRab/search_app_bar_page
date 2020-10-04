import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get_state_manager/get_state_manager.dart';
import 'package:meta/meta.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/seacher_base_controll.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/filters/filters_type.dart';
//import 'package:search_app_bar_page/src/search_app_bar_page/filters/filters_type.dart';

import '../filters/functions_filters.dart';

class SearcherPageController<T> extends SeacherBase {
  final RxBool _isModSearch = false.obs;

  @override
  bool get isModSearch => _isModSearch.value;

  @override
  set isModSearch(bool value) => _isModSearch.value = value;

  @override
  // ignore: overridden_fields
  final RxString rxSearch = ''.obs;

  final listSearch = <T>[].obs;
  final List<T> listFull;

  Function(Iterable<T>) get onSearchList => listSearch.assignAll;

  final FiltersTypes filtersType;
  Filter<String> _filters;
  StringFilter<T> stringFilter;
  final Compare<T> compareSort;

  Worker _worker;

  final RxBool _bancoInit = true.obs;

  @override
  set bancoInit(bool value) => _bancoInit.value = value;

  @override
  bool get bancoInit => _bancoInit.value;

  StringFilter<T> get _defaultFilter => (T value) => value as String;

  SearcherPageController({
    @required this.listFull,
    this.stringFilter,
    this.compareSort,
    this.filtersType = FiltersTypes.contains,
  }) {
    if (stringFilter == null) {
      if (T == String) {
        stringFilter = _defaultFilter;
      } else {
        throw Exception(
            'Voce precisa tipar sua página ou deverá ser tipada como String');
      }
    }
    _bancoInit.close();
    sortCompareList(listFull);
    onSearchList(listFull);
  }

  void onInit() {
    if (filtersType.toString() == FiltersTypes.startsWith.toString()) {
      _filters = Filters.startsWith;
    } else if (filtersType.toString() == FiltersTypes.equals.toString()) {
      _filters = Filters.equals;
    } else {
      _filters = Filters.contains;
    }
  }

  void onReady() {
    _worker = ever(rxSearch, (String value) {
      refreshSeachList(value);
    });
  }

  void refreshSeachList(String value) {
    final list = listFull
        .where((element) => _filters(stringFilter(element), value))
        .toList();

    //sortCompareList(list);
    onSearchList(list);
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
    listSearch.close();
  }
}
