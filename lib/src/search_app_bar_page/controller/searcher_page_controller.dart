import 'dart:async';

import 'package:get/state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_base_control.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/filters_type.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';

class SearcherPageController<T> extends SearcherBase<T> {
  final RxBool _isModSearch = false.obs;

  @override
  bool get isModSearch => _isModSearch.value;

  @override
  set isModSearch(bool value) => _isModSearch.value = value;

  @override
  final RxString rxSearch = ''.obs;

  @override
  bool? sortCompare = true;

  @override
  set bancoInitValue(bool value) => bancoInit.value = value;

  @override
  bool get bancoInitValue => bancoInit.value;

  @override
  final RxBool bancoInit = true.obs;

  final listSearch = <T>[].obs;

  /// [listFull] More complete initial list to be filtered
  final List<T> listFull;

  Function(Iterable<T>) get onSearchList => listSearch.assignAll;

  FiltersTypes? filtersType;
  late Filter<String?> _filters;
  StringFilter<T>? stringFilter;
  SortList<T>? sortFunction;
  Filter<T>? filter;

  //Compare<T> compareSort;

  Worker? _worker;

  //StringFilter<T> get _defaultFilter => (T value) => value as String;

  SearcherPageController({
    required this.listFull,
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
          throw Exception('If you dont want to filter by a String, it is necessary '
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
      throw Exception('You need to choose between one of the filtering mechanisms.');
    }

    //bancoInit.close();
    /*if (bancoInit.canUpdate) {
      bancoInit.close();
    }*/
    sortCompareList(listFull);
    onSearchList(listFull);
  }

  void initFilters() {
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

  void onReady() {
    _worker = ever(rxSearch, (String? value) {
      refreshSearchList(value);
    });
  }

  void refreshSearchList(String? value) {
    var list = <T>[];

    if (stringFilter != null || T == String) {
      list = listFull
          .where(
            (element) => _filters(stringFilter!(element), value),
          )
          .toList();
    } else {
      if (value!.isEmpty)
        list = listFull;
      else
        list = listFull.where((element) => filter!(element, value)).toList();
    }
    /*final list = listFull
        .where((element) => _filters(stringFilter!(element), value))
        .toList();*/

    //sortCompareList(list);
    onSearchList(list);
  }

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

  FutureOr onClose() {
    _worker?.dispose();
    _isModSearch.close();
    rxSearch.close();
    listSearch.close();
    bancoInit.close();
  }
}
