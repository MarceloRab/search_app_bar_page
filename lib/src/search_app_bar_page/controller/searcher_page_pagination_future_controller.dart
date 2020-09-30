import 'dart:async';

import 'package:get_state_manager/get_state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/seacher_base_controll.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/filters/filters_type.dart';

import '../filters/functions_filters.dart';

class SearcherPagePaginationFutureController<T> extends SeacherBase {
  final RxBool _isModSearch = false.obs;

  @override
  bool get isModSearch => _isModSearch.value;

  @override
  set isModSearch(bool value) => _isModSearch.value = value;

  @override
  // ignore: overridden_fields
  final rxSearch = ''.obs;

  final RxList<T> listSearch = <T>[].obs;

  Function(Iterable<T>) get onSearchList => listSearch.assignAll;

  final FiltersTypes filtersType;
  Filter<String> _filters;
  StringFilter<T> stringFilter;

  final Compare<T> compareSort;
  bool haveInitialData = false;

  Worker _worker;

  int page = 0;
  int pageSearch = 0;

  int numPageItems = 0;

  //int numPageItemsCurrent = 0;

  //bool haveMore = false;

  //final Stream<List<T>> listStream;

  //StreamSubscription _streamSubscription;

  StringFilter<T> get _defaultFilter => (T value) => value as String;

  SearcherPagePaginationFutureController({
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
            'Voce precisa tipar sua página ou deverá ser tipada como String');
      }
    }
  }

  var listFull = <T>[];
  //var listFullSearch = <T>[];
  final RxList<T> listSearchFilter = <T>[].obs;

  set initialChangeList(List<T> list) {
    if (!bancoInit) {
      bancoInit = true;
      _bancoInit.close();
    }

    listFull.addAll(list);
    onSearchList(listFull);
    rxSearch('');
  }

  final RxBool _bancoInit = false.obs;

  @override
  set bancoInit(bool value) => _bancoInit.value = value;

  @override
  bool get bancoInit => _bancoInit.value;

  void onInit() {
    if (filtersType.toString() == FiltersTypes.startsWith.toString()) {
      _filters = Filters.startsWith;
    } else if (filtersType.toString() == FiltersTypes.equals.toString()) {
      _filters = Filters.equals;
    } else {
      _filters = Filters.contains;
    }
  }

  void wrabListSearch(List<T> listData) {
    if (bancoInit) {
      // Fica negativo dentro do StreamBuilder
      // Após apresentar o primeiro Obx(())
      listFull = listData;
      if (rxSearch.value.isNotEmpty) {
        refreshSeachFullList(rxSearch.value);
      } else {
        sortCompareList(listData);
        onSearchList(listData);
      }
    } else {
      initialChangeList = listData;
    }
  }

  void subscribeWorker() {
    _worker = ever(rxSearch, (String value) {
      if (value.isEmpty) {
        pageSearch = 0;
        refreshSeachFullList(value);
      }

      // se nao vazia vide stream no initState da classe
      //_SearchAppBarPageFutureBuilderState
    });
  }

  void refreshSeachFullList(String value) {
    final list = listFull
        .where((element) => _filters(stringFilter(element), value))
        .toList();

    //numPageItemsCurrent = list.length;

    sortCompareList(list);
    onSearchList(list);
  }

  void refreshSeachList(String value) {
    final list = listSearchFilter
        .where((element) => _filters(stringFilter(element), value))
        .toList();

    //numPageItemsCurrent = list.length;

    sortCompareList(list);
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
    listSearchFilter.close();
  }
}
