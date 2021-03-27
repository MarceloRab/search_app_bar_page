import 'dart:async';

import 'package:get/state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/seacher_base_controll.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/filters_type.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';

class SearcherPageController<T> extends SeacherBase<T> {
  final RxBool _isModSearch = false.obs;

  @override
  bool get isModSearch => _isModSearch.value!;

  @override
  set isModSearch(bool value) => _isModSearch.value = value;

  @override
  final RxString rxSearch = ''.obs;

  @override
  bool? sortCompare = true;

  @override
  set bancoInitValue(bool value) => bancoInit.value = value;

  @override
  bool get bancoInitValue => bancoInit.value!;

  @override
  final RxBool bancoInit = true.obs;

  final listSearch = <T>[].obs;
  final List<T> listFull;

  Function(Iterable<T>) get onSearchList => listSearch.assignAll;

  FiltersTypes? filtersType;
  late Filter<String?> _filters;
  StringFilter<T>? stringFilter;

  //Compare<T> compareSort;

  Worker? _worker;

  //StringFilter<T> get _defaultFilter => (T value) => value as String;

  SearcherPageController({
    required this.listFull,
    this.stringFilter,
    this.sortCompare,
    this.filtersType = FiltersTypes.contains,
  }) {
    if (stringFilter == null) {
      if (T == String) {
        //stringFilter = _defaultFilter;
        stringFilter = (T value) => value as String;
      } else {
        throw Exception(
            'You need to construct your object s return String in the '
            'stringFilter function. If there is no return String, your '
            'list object must be a String.');
      }
    }

    //bancoInit.close();
    /*if (bancoInit.canUpdate) {
      bancoInit.close();
    }*/
    sortCompareList(listFull);
    onSearchList(listFull);
  }

  void initFilters() {
    if (filtersType.toString() == FiltersTypes.startsWith.toString()) {
      _filters = Filters.startsWith;
    } else if (filtersType.toString() == FiltersTypes.equals.toString()) {
      _filters = Filters.equals;
    } else {
      _filters = Filters.contains;
    }
  }

  void onReady() {
    _worker = ever(rxSearch, (String? value) {
      refreshSeachList(value);
    });
  }

  void refreshSeachList(String? value) {
    final list = listFull
        .where((element) => _filters(stringFilter!(element), value))
        .toList();

    //sortCompareList(list);
    onSearchList(list);
  }

  @override
  void sortCompareList(List<T> list) {
    /*if (compareSort != null) {
      list.sort(compareSort);
    }*/

    if (sortCompare!) {
      list.sort((a, b) => stringFilter!(a)!.compareTo(stringFilter!(b)!));
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
