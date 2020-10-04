import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_state_manager/get_state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/seacher_base_controll.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/filters/filters_type.dart';
//import 'package:search_app_bar_page/src/search_app_bar_page/filters/filters_type.dart';

import '../filters/functions_filters.dart';

class SearcherPagePaginationFutureController<T> extends SeacherBase {
  final RxBool _isModSearch = false.obs;

  @override
  bool get isModSearch => _isModSearch.value;

  @override
  set isModSearch(bool value) => _isModSearch.value = value;

  /*final Rx<AsyncSnapshot<List<T>>> _snapshot =
      AsyncSnapshot<List<T>>.withData(ConnectionState.done, null).obs;

  AsyncSnapshot<List<T>> get snapshot => _snapshot.value;

  set snapshot(AsyncSnapshot<List<T>> value) => _snapshot.value = value;*/

  final Rx<AsyncSnapshotScrollPage<T>> _snapshotScroolPage =
      AsyncSnapshotScrollPage<T>(
              snapshot:
                  AsyncSnapshot<List<T>>.withData(ConnectionState.none, null))
          .obs;

  AsyncSnapshotScrollPage<T> get snapshotScroolPage =>
      _snapshotScroolPage.value;

  set snapshotScroolPage(AsyncSnapshotScrollPage<T> value) =>
      _snapshotScroolPage.value = value;

  @override
  // ignore: overridden_fields
  final rxSearch = ''.obs;

  //List<T> listSearch = <T>[];

  //final RxList<T> listSearch = <T>[].obs;

  //Function(Iterable<T>) get onSearchList => listSearch.assignAll;
  /* Function(Iterable<T>) get onSearchList {
    listSearch.clear();
    return listSearch.addAll;
  }
*/
  final FiltersTypes filtersType;
  Filter<String> _filters;
  StringFilter<T> stringFilter;

  final Compare<T> compareSort;

  //bool haveInitialData = false;

  //final RxBool _endPage = false.obs;

  //bool get endPage => _isModSearch.value;

  //bool pageFinish = false;
  //bool pageSearchFinish = false;

  /*set endPage(bool value) => _isModSearch.value = value;

  final RxBool _endSearchPage = false.obs;

  bool get endSearchPage => _isModSearch.value;*/

  //set endSearchPage(bool value) => _isModSearch.value = value;

  //Worker _worker;

  //bool loadingScroll = false;

  int page = 1;
  int pageSearch = 1;

  int numPageItems = 0;

  Future<List<T>> functionFuturePageItems(FutureFetchPageItems<T> func) =>
      func(page, rxSearch.value);

  StringFilter<T> get _defaultFilter => (T value) => value as String;

  Map<String, ListSearchBuild<T>> mapsSearch = {};

  String _query = '';

  bool progide = false;

  void queryProgride(String newQuery) {
    progide = newQuery.length - _query.length > 0;
    _query = newQuery;
  }

  void restartQuery() {
    _query = '';
    progide = false;
  }

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

  //var listFullSearchQuery = <T>[];

  ListSearchBuild<T> haveSearchQueryPage(String query) {
    queryProgride(query);
    pageSearch = 1;
    var listSearchBuild = <T>[];

    if (query.length > 1) {
      // Pega da anterior que já esta completa

      if (mapsSearch.containsKey(
          query.replaceRange(query.length - 1, query.length, ''))) {
        final listAnterior =
            mapsSearch[query.replaceRange(query.length - 1, query.length, '')];

        listSearchBuild = listAnterior.listSearch
            .where((element) => _filters(stringFilter(element), query))
            //query.replaceRange(query.length - 1, query.length, '')))
            .toList();

        if (mapsSearch.containsKey(query)) {
          pageSearch = (listSearchBuild.length / numPageItems).ceil();
          if (pageSearch == 0) {
            pageSearch = 1;
          }
          if (mapsSearch[query].isListSearchFull) {
            return mapsSearch[query];
          }
        }

        mapsSearch[query] = ListSearchBuild<T>(
            listSearch: listSearchBuild,
            // se a anterior esta full a atual tb.
            isListSearchFull: listAnterior.isListSearchFull);
      } else {
        listSearchBuild = listFull
            .where((element) => _filters(stringFilter(element), query))
            //query.replaceRange(query.length - 1, query.length, '')))
            .toList();

        mapsSearch[query] = ListSearchBuild<T>(
            listSearch: listSearchBuild,
            // se a anterior esta full a atual tb.
            isListSearchFull: snapshotScroolPage.finishPage);
      }

      pageSearch = (listSearchBuild.length / numPageItems).ceil();
      if (pageSearch == 0) {
        pageSearch = 1;
      }

      if (mapsSearch[query].isListSearchFull) {
        return mapsSearch[query];
      }
    } else {
      if (mapsSearch.containsKey(query)) {
        pageSearch =
            (mapsSearch[query].listSearch.length / numPageItems).ceil();
        if (pageSearch == 0) {
          pageSearch = 1;
        }
        if (mapsSearch[query].isListSearchFull) {
          return mapsSearch[query];
        }
      }

      listSearchBuild = listFull
          .where((element) => _filters(stringFilter(element), query))
          .toList();

      if (snapshotScroolPage.finishPage) {
        //mapsSearch.clear();
        pageSearch = (listSearchBuild.length / numPageItems).ceil();
        if (pageSearch == 0) {
          pageSearch = 1;
        }
        snapshotScroolPage.finishSearchPage = true;
        debugPrint(' SearcherPagePaginationFutureController '
            'PAGE SEARCH DEPOIS== $pageSearch');
        debugPrint('SearcherPagePaginationFutureController - finalizou '
            'pagian search chamadas api'
            ' ${snapshotScroolPage.finishSearchPage}');

        //finaliza a listSearch da query inicial
        mapsSearch[query] = ListSearchBuild<T>(
            listSearch: listSearchBuild, isListSearchFull: true);
        return mapsSearch[query];
      } else {
        // Primeira adicao da key com query incial

        snapshotScroolPage.finishSearchPage = false;
        if (!mapsSearch.containsKey(query)) {
          mapsSearch[query] = ListSearchBuild<T>(listSearch: listSearchBuild);
        } else {
          pageSearch =
              (mapsSearch[query].listSearch.length / numPageItems).ceil();
          if (pageSearch == 0) {
            pageSearch = 1;
          }
        }
      }
    }

    return mapsSearch[query];
  }

  /*List<T> haveSearchQueryPage(String query) {
    final list = listFull
        .where((element) => _filters(stringFilter(element), query))
        .toList();

    final temPage = list.length >= numPageItems * pageSearch;

    if (temPage)
      return list;
    else
      return <T>[];
  }*/

  //final RxList<T> listSearchFilter = <T>[].obs;

  set initialChangeList(List<T> list) {
    if (!bancoInit) {
      bancoInit = true;
      _bancoInit.close();
    }

    listFull.addAll(list);
    sortCompareList(listFull);
    //onSearchList(listFull);
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
      //listFull = listData;
      listFull.addAll(listData);
      sortCompareList(listFull);
      /*if (rxSearch.value.isNotEmpty) {
        refreshSeachFullList(rxSearch.value);
      } else {
        //onSearchList(listData);
      }*/
    } else {
      initialChangeList = listData;
    }
  }

  /* void subscribeWorker() {
    _worker = ever(rxSearch, (String value) {
      if (value.isEmpty) {
        pageSearch = 1;
        //refreshSeachFullList(value);
      }

      // se nao vazia vide stream no initState da classe
      //_SearchAppBarPageFutureBuilderState
    });
  }*/

  /*void refreshSeachFullList(String value) {
    final list = listFull
        .where((element) => _filters(stringFilter(element), value))
        .toList();

    //onSearchList(list);
  }*/

  /* void refreshSeachList(String value) {
    final list = listFullSearchQuery
        .where((element) => _filters(stringFilter(element), value))
        .toList();

    //numPageItemsCurrent = list.length;

    sortCompareList(list);
    //onSearchList(list);
  }
*/
  void sortCompareList(List<T> list) {
    if (compareSort != null) {
      list.sort(compareSort);
    }
  }

  FutureOr onClose() {
    _snapshotScroolPage.close();
    // _worker?.dispose();
    _isModSearch.close();
    rxSearch.close();
    // listSearch.close();

    //_endSearchPage.close();
    //_endPage.close();
    //listSearchFilter.close();
  }
}

//AsyncSnapshot
class AsyncSnapshotScrollPage<T> {
  AsyncSnapshot<List<T>> snapshot;
  bool endPage;
  bool endSearchPage;
  bool finishPage;
  bool finishSearchPage;
  bool loadingScroll;

  AsyncSnapshotScrollPage(
      {this.snapshot,
      this.endPage = false,
      this.finishPage = false,
      this.finishSearchPage = false,
      this.loadingScroll = false,
      this.endSearchPage = false});

  AsyncSnapshotScrollPage<T> copyWith({
    AsyncSnapshot<List<T>> snapshot,
    bool endPage,
    bool endSearchPage,
    bool finishPage,
    bool finishSearchPage,
    bool loadingScroll,
  }) {
    return AsyncSnapshotScrollPage<T>(
      snapshot: snapshot ?? this.snapshot,
      endPage: endPage ?? this.endPage,
      endSearchPage: endSearchPage ?? this.endSearchPage,
      finishPage: finishPage ?? this.finishPage,
      finishSearchPage: finishSearchPage ?? this.finishSearchPage,
      loadingScroll: loadingScroll ?? this.loadingScroll,
    );
  }
}

class ListSearchBuild<T> {
  List<T> listSearch;
  bool isListSearchFull;

  ListSearchBuild({this.listSearch, this.isListSearchFull = false});
}
