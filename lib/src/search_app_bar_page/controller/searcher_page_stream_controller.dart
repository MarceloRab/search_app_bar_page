import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get_state_manager/get_state_manager.dart';
import 'package:meta/meta.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/seacher_base_controll.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/filters/filters_type.dart';

import '../filters/filter.dart';

class SearcherPageStreamController<T> extends SeacherBase {
  final RxBool _isModSearch = false.obs;

  bool get isModSearch => _isModSearch.value;

  set isModSearch(bool value) => _isModSearch.value = value;

  final rxSearch = ''.obs;

  final listSearch = <T>[].obs;

  Function(Iterable<T>) get onSearchFilter => listSearch.assignAll;

  final FiltersTypes filtersType;
  Filter<String> _filters;
  StringFilter<T> stringFilter;

  final Compare<T> compareSort;
  bool haveInitialData = false;

  Worker _worker;
  final Stream<List<T>> listStream;

  StreamSubscription _streamSubscription;

  StringFilter<T> get _defaultFilter => (T value) => value as String;

  SearcherPageStreamController({
    @required this.listStream,
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
  }

  var listFull = <T>[];

  set _initialChangeList(List<T> list) {
    if (!bancoInit) {
      bancoInit = true;
      _bancoInit.close();
    }

    listFull = list;
    onSearchFilter(list);
    rxSearch('');
  }

  final RxBool _bancoInit = false.obs;

  set bancoInit(bool value) => _bancoInit.value = value;

  bool get bancoInit => _bancoInit.value;

  void onInit() {
    if (filtersType.toString() == FiltersTypes.startsWith.toString()) {
      _filters = Filters.startsWith;
    } else if (filtersType.toString() == FiltersTypes.equals.toString()) {
      _filters = Filters.equals;
    } else {
      _filters = Filters.contains;
    }

    _streamSubscription = listStream.listen((listData) {
      if (bancoInit) {
        listFull = listData;
        if (rxSearch.value.isNotEmpty) {
          refreshSeachList(rxSearch.value);
        } else {
          sortCompareList(listData);
          onSearchFilter(listData);
        }
      } else {
        _initialChangeList = listData;
      }
    });
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
    _streamSubscription?.cancel();
    _worker?.dispose();
    _isModSearch.close();
    rxSearch.close();
    listSearch.close();
  }
}
