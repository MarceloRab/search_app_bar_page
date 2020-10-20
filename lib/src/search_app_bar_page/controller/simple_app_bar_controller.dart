import 'dart:async';

import 'package:get_state_manager/get_state_manager.dart';
import 'package:meta/meta.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';

import 'seacher_base_controll.dart';
import 'utils/filters/functions_filters.dart';

class SimpleAppBarController<T> implements SeacherBase<T> {
  final listSearch = <T>[].obs;
  final List<T> listFull;

  Function(Iterable<T>) get onSearchList => listSearch.assignAll;

  FiltersTypes filtersType;
  Filter<String> _filters;

  set filter(FiltersTypes value) {
    if (filtersType == FiltersTypes.startsWith) {
      _filters = Filters.startsWith;
    } else if (filtersType.toString() == FiltersTypes.equals.toString()) {
      _filters = Filters.equals;
    } else {
      _filters = Filters.contains;
    }
  }

  StringFilter<T> stringFilter;

  final RxBool _isModSearch = false.obs;

  @override
  bool get isModSearch => _isModSearch.value;

  @override
  set isModSearch(bool value) => _isModSearch.value = value;

  @override
  bool compare;

  Worker _worker;

  final RxBool _bancoInit = true.obs;

  @override
  set bancoInit(bool value) => _bancoInit.value = value;

  @override
  bool get bancoInit => _bancoInit.value;

  @override
  final RxString rxSearch = ''.obs;

  SimpleAppBarController({
    @required this.listFull,
    this.stringFilter,
    this.compare,
    this.filtersType = FiltersTypes.contains,
  }) {
    if (stringFilter == null) {
      if (T == String) {
        //stringFilter = _defaultFilter;
        stringFilter = (T value) => value as String;
      } else {
        throw Exception(
            'You need to type your page or it must be typed as String');
      }
    }
    _bancoInit.close();
    sortCompareList(listFull);
    onSearchList(listFull);
    filter = filtersType;
    _onReady();
  }

  void _onReady() {
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

  @override
  void sortCompareList(List<T> list) {
    if (compare) {
      list.sort((a, b) => stringFilter(a).compareTo(stringFilter(b)));
    }
  }

  FutureOr onClose() {
    _worker?.dispose();
    _isModSearch.close();
    rxSearch.close();
    listSearch.close();
  }
}
