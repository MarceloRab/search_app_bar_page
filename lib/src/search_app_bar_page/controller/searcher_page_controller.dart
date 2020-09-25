import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get_state_manager/get_state_manager.dart';
import 'package:meta/meta.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/seacher_base_controll.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/filters/filters_type.dart';

import '../filters/filter.dart';

class SearcherPageController<T> extends SeacherBase {
  final RxBool _isModSearch = false.obs;

  bool get isModSearch => _isModSearch.value;

  set isModSearch(bool value) => _isModSearch.value = value;

  final rxSearch = ''.obs;

  final listSearch = <T>[].obs;
  final List<T> listFull;

  Function(Iterable<T>) get onSearchFilter => listSearch.assignAll;

  final FiltersTypes filtersType;
  Filter<String> _filters;
  StringFilter<T> stringFilter;
  final Compare<T> compareSort;

  Worker _worker;

  final RxBool _bancoInit = true.obs;

  set bancoInit(bool value) => _bancoInit.value = value;

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
        throw (Exception(
            'Voce precisa tipar sua página ou será uam lista String por padrao'));
      }
    }
    _bancoInit.close();
    onSearchFilter(listFull);
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
    _worker = ever(rxSearch, (value) {
      refreshSeachList(value);
    });
  }

  void refreshSeachList(String value) {
    final list = listFull
        .where((element) => _filters(stringFilter(element), value))
        .toList();

    sortCompareList(list);
    onSearchFilter(list);
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
