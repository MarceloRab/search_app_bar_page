import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_state_manager/get_state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/seacher_base_controll.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/filters_type.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';

class SearcherPagePaginationFutureController<T> extends SeacherBase {
  final RxBool _isModSearch = false.obs;

  @override
  bool get isModSearch => _isModSearch.value;

  @override
  set isModSearch(bool value) => _isModSearch.value = value;

  @override
  final rxSearch = ''.obs;

  final RxBool _bancoInit = false.obs;

  @override
  set bancoInit(bool value) => _bancoInit.value = value;

  @override
  bool get bancoInit => _bancoInit.value;

  bool finishPage = false;

  /*final Rx<AsyncSnapshotScrollPage<T>> _snapshotScroolPage =
      AsyncSnapshotScrollPage<T>(
              snapshot:
                  AsyncSnapshot<List<T>>.withData(ConnectionState.none, null))
          .obs;*/

  final Rx<AsyncSnapshotScrollPage<T>> _snapshotScroolPage =
      AsyncSnapshotScrollPage<T>.nothing().obs;

  AsyncSnapshotScrollPage<T> get snapshotScroolPage =>
      _snapshotScroolPage.value;

  set snapshotScroolPage(AsyncSnapshotScrollPage<T> value) =>
      _snapshotScroolPage.value = value;

  final FiltersTypes filtersType;
  Filter<String> _filters;
  StringFilter<T> stringFilter;

  final Compare<T> compareSort;

  int page = 1;
  int pageSearch = 1;

  int numPageItems = 0;

  Future<List<T>> functionFuturePageItems(FutureFetchPageItems<T> func) =>
      func(page, rxSearch.value);

  StringFilter<T> get _defaultFilter => (T value) => value as String;

  Map<String, ListSearchBuild<T>> mapsSearch = {};

  /*String _query = '';

  bool progide = false;*/

  /*void queryProgride(String newQuery) {
    progide = newQuery.length - _query.length > 0;
    _query = newQuery;
  }

  void restartQuery() {
    _query = '';
    progide = false;
  }*/

  SearcherPagePaginationFutureController({
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

  ListSearchBuild<T> haveSearchQueryPage(String query, {bool restart = false}) {
    //queryProgride(query);
    pageSearch = 1;
    var listSearch = <T>[];

    // subdivisao da listSearch
    if (query.length > 1) {
      ListSearchBuild<T> listAnterior;

      final queryStringAnterior =
          query.replaceRange(query.length - 1, query.length, '');
      if (mapsSearch.containsKey(queryStringAnterior)) {
        listAnterior = mapsSearch[queryStringAnterior];

        listSearch = listAnterior.listSearch
            .where((element) => _filters(stringFilter(element), query))
            .toList();
      }

      // tem cache da query?
      if (mapsSearch.containsKey(query)) {
        if (mapsSearch[query].isListSearchFull) {
          pageSearch =
              (mapsSearch[query].listSearch.length / numPageItems).ceil();
          if (pageSearch == 0) {
            pageSearch = 1;
          }
          return mapsSearch[query];
        }

        if (listAnterior != null) {
          if (listSearch.length > mapsSearch[query].listSearch.length) {
            pageSearch = (listSearch.length / numPageItems).ceil();
            if (pageSearch == 0) {
              pageSearch = 1;
            }
            mapsSearch[query] = ListSearchBuild<T>(
                listSearch: listSearch,
                // se a anterior esta full a atual tb.
                isListSearchFull: listAnterior.isListSearchFull);
          }

          if (listAnterior.isListSearchFull) {
            return mapsSearch[query];
          }
        } else {
          listSearch.clear();
          listSearch = listFull
              .where((element) => _filters(stringFilter(element), query))
              .toList();

          pageSearch = (listSearch.length / numPageItems).ceil();
          if (pageSearch == 0) {
            pageSearch = 1;
          }

          mapsSearch[query] = ListSearchBuild<T>(
              listSearch: listSearch,
              // se a anterior esta full a atual tb.
              isListSearchFull: finishPage);

          if (finishPage) {
            return mapsSearch[query];
          }
        }
        // sem cache da query
      } else {
        listSearch.clear();
        listSearch = listFull
            .where((element) => _filters(stringFilter(element), query))
            .toList();
        if (listAnterior != null) {
          if (listAnterior.listSearch.length > listSearch.length) {
            pageSearch = (listAnterior.listSearch.length / numPageItems).ceil();
            if (pageSearch == 0) {
              pageSearch = 1;
            }
            mapsSearch[query] = ListSearchBuild<T>(
                listSearch: listAnterior.listSearch
                    .where((element) => _filters(stringFilter(element), query))
                    .toList(),
                // se a anterior esta full a atual tb.
                isListSearchFull: listAnterior.isListSearchFull);
          } else {
            pageSearch = (listSearch.length / numPageItems).ceil();
            if (pageSearch == 0) {
              pageSearch = 1;
            }

            mapsSearch[query] = ListSearchBuild<T>(
                listSearch: listSearch,
                // se a anterior esta full a atual tb.
                isListSearchFull: finishPage);

            if (finishPage) {
              return mapsSearch[query];
            }
          }
        } else {
          pageSearch = (listSearch.length / numPageItems).ceil();
          if (pageSearch == 0) {
            pageSearch = 1;
          }

          mapsSearch[query] = ListSearchBuild<T>(
              listSearch: listSearch,
              // se a anterior esta full a atual tb.
              isListSearchFull: finishPage);

          if (finishPage) {
            return mapsSearch[query];
          }
        }
      }
      // pesquisa de uma letra
    } else {
      if (mapsSearch.containsKey(query)) {
        if (restart) {
          listSearch = listFull
              .where((element) => _filters(stringFilter(element), query))
              .toList();

          mapsSearch[query] = ListSearchBuild<T>(
              listSearch: listSearch, isListSearchFull: finishPage);
        }

        pageSearch =
            (mapsSearch[query].listSearch.length / numPageItems).ceil();
        if (pageSearch == 0) {
          pageSearch = 1;
        }
        if (mapsSearch[query].isListSearchFull) {
          return mapsSearch[query];
        }
      } else {
        listSearch = listFull
            .where((element) => _filters(stringFilter(element), query))
            .toList();

        pageSearch = (listSearch.length / numPageItems).ceil();
        if (pageSearch == 0) {
          pageSearch = 1;
        }
        mapsSearch[query] = ListSearchBuild<T>(
            listSearch: listSearch, isListSearchFull: finishPage);

        /*print('listSearch.query => '
            '${mapsSearch[
        query].listSearch.length.toString()}');

        print('searche.page => ${pageSearch.toString()}');*/
      }
    }

    return mapsSearch[query];
  }

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
    // para aparecer a lupa
    if (bancoInit) {
      listFull.addAll(listData);
      sortCompareList(listFull);
    } else {
      initialChangeList = listData;
    }
  }

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
  }
}

@immutable
class AsyncSnapshotScrollPage<T> {
  final AsyncSnapshot<List<T>> snapshot;

  final bool loadinglistFullScroll;
  final bool loadingSearchScroll;

  /*AsyncSnapshot<List<T>> snapshot;

  bool loadingSearchScroll;
  bool loadinglistFullScroll;*/

  /*const AsyncSnapshotScrollPage._(
      {this.snapshot, this.loadingSearchScroll = false,
        this.loadinglistFullScroll = false,});*/

  /*const AsyncSnapshotScrollPage.loadingSearchScroll() : this._(snapshot: );*/

  /*const AsyncSnapshotScrollPage({
    this.snapshot,
    this.loadingSearchScroll = false,
    this.loadinglistFullScroll = false,
  });*/

  const AsyncSnapshotScrollPage._(this.snapshot,
      {this.loadinglistFullScroll = false, this.loadingSearchScroll = false})
      // para demais ter corpo também
      : assert(snapshot != null);

  // AsyncSnapshotScrollPage<T> waiting() =>
  //  AsyncSnapshotScrollPage<T>._(const AsyncSnapshot.waiting());

  const AsyncSnapshotScrollPage.waiting()
      : this._(const AsyncSnapshot.waiting());

  const AsyncSnapshotScrollPage.nothing()
      : this._(const AsyncSnapshot.nothing());

  AsyncSnapshotScrollPage<T> inState(ConnectionState state) =>
      AsyncSnapshotScrollPage<T>._(snapshot.inState(state));

  AsyncSnapshotScrollPage<T> withData(List<T> data) =>
      AsyncSnapshotScrollPage<T>._(
          AsyncSnapshot.withData(ConnectionState.done, data));

  AsyncSnapshotScrollPage<T> withError(Object error) =>
      AsyncSnapshotScrollPage<T>._(
          AsyncSnapshot.withError(ConnectionState.done, error));

  AsyncSnapshotScrollPage<T> togleLoadingSearchScroll(ConnectionState state) =>
      AsyncSnapshotScrollPage<T>._(snapshot.inState(state),
          loadingSearchScroll: !loadingSearchScroll);

  AsyncSnapshotScrollPage<T> togleLoadinglistFullScroll(
          ConnectionState state) =>
      AsyncSnapshotScrollPage<T>._(snapshot.inState(state),
          loadinglistFullScroll: !loadinglistFullScroll);

/*const AsyncSnapshotScrollPage.withData(List<T> data)
      : this._(const AsyncSnapshot.withData(ConnectionState.none, data), false,
            false);*/

/*AsyncSnapshotScrollPage<T> copyWith({
    AsyncSnapshot<List<T>> snapshot,
    bool loadingSearchScroll,
    bool loadinglistFullScroll,
  }) {
    return AsyncSnapshotScrollPage<T>(
      snapshot: snapshot ?? this.snapshot,
      loadingSearchScroll: loadingSearchScroll ?? this.loadingSearchScroll,
      loadinglistFullScroll:
      loadinglistFullScroll ?? this.loadinglistFullScroll,
    );
  }*/

}

class ListSearchBuild<T> {
  List<T> listSearch;
  bool isListSearchFull;

  ListSearchBuild({this.listSearch, this.isListSearchFull = false});
}
