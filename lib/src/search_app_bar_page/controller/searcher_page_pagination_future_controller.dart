import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_state_manager/get_state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/seacher_base_controll.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/filters_type.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/infra/search_pagination_base.dart';

typedef CallBack = void Function();

typedef CallBackListData<T> = void Function(List<T> listData);

class SearcherPagePaginationFutureController<T> extends SeacherBase
    with SearcherPaginnationBase<T> {
  final RxBool _isModSearch = false.obs;

  @override
  bool get isModSearch => _isModSearch.value;

  bool get isSearchModePage => rxSearch.value.isNotEmpty;

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

  final Rx<AsyncSnapshotScrollPage<T>> _snapshotScroolPage =
      AsyncSnapshotScrollPage<T>.nothing().obs;

  AsyncSnapshotScrollPage<T> get snapshotScroolPage =>
      _snapshotScroolPage.value;

  set snapshotScroolPage(AsyncSnapshotScrollPage<T> value) =>
      _snapshotScroolPage.value = value;

  FiltersTypes filtersType;
  Filter<String> _filters;
  StringFilter<T> stringFilter;

  Compare<T> compareSort;

  int page = 1;
  int pageSearch = 1;

  int numItemsPage = 0;

  Future<List<T>> functionFuturePageItems(FutureFetchPageItems<T> func) =>
      func(page, rxSearch.value);

  StringFilter<T> get _defaultFilter => (T value) => value as String;

  Map<String, ListSearchBuild<T>> mapsSearch = {};

  SearcherPagePaginationFutureController({
    this.stringFilter,
    this.compareSort,
    this.filtersType = FiltersTypes.contains,
    this.cache = false,
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

  final bool cache;

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
              (mapsSearch[query].listSearch.length / numItemsPage).ceil();
          if (pageSearch == 0) {
            pageSearch = 1;
          }

          return mapsSearch[query];
        }

        if (listAnterior != null) {
          if (listSearch.length > mapsSearch[query].listSearch.length) {
            pageSearch = (listSearch.length / numItemsPage).ceil();
            if (pageSearch == 0) {
              pageSearch = 1;
            }
            mapsSearch[query] = ListSearchBuild<T>(
                listSearch: listSearch,
                // se a anterior esta full a atual tb.
                isListSearchFull: listAnterior.isListSearchFull);
            mapsSearch[query].listSearch =
                sortCompareListSearch(mapsSearch[query].listSearch);
          }

          if (listAnterior.isListSearchFull) {
            return mapsSearch[query];
          }
        } else {
          listSearch.clear();
          listSearch = listFull
              .where((element) => _filters(stringFilter(element), query))
              .toList();

          pageSearch = (listSearch.length / numItemsPage).ceil();
          if (pageSearch == 0) {
            pageSearch = 1;
          }

          mapsSearch[query] = ListSearchBuild<T>(
              listSearch: listSearch,
              // se a anterior esta full a atual tb.
              isListSearchFull: finishPage);
          mapsSearch[query].listSearch =
              sortCompareListSearch(mapsSearch[query].listSearch);

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
            pageSearch = (listAnterior.listSearch.length / numItemsPage).ceil();
            if (pageSearch == 0) {
              pageSearch = 1;
            }
            mapsSearch[query] = ListSearchBuild<T>(
                listSearch: listAnterior.listSearch
                    .where((element) => _filters(stringFilter(element), query))
                    .toList(),
                // se a anterior esta full a atual tb.
                isListSearchFull: listAnterior.isListSearchFull);

            mapsSearch[query].listSearch =
                sortCompareListSearch(mapsSearch[query].listSearch);
          } else {
            pageSearch = (listSearch.length / numItemsPage).ceil();
            if (pageSearch == 0) {
              pageSearch = 1;
            }

            mapsSearch[query] = ListSearchBuild<T>(
                listSearch: listSearch,
                // se a anterior esta full a atual tb.
                isListSearchFull: finishPage);

            mapsSearch[query].listSearch =
                sortCompareListSearch(mapsSearch[query].listSearch);

            if (finishPage) {
              return mapsSearch[query];
            }
          }
        } else {
          pageSearch = (listSearch.length / numItemsPage).ceil();
          if (pageSearch == 0) {
            pageSearch = 1;
          }

          mapsSearch[query] = ListSearchBuild<T>(
              listSearch: listSearch,
              // se a anterior esta full a atual tb.
              isListSearchFull: finishPage);

          mapsSearch[query].listSearch =
              sortCompareListSearch(mapsSearch[query].listSearch);

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

          mapsSearch[query].listSearch =
              sortCompareListSearch(mapsSearch[query].listSearch);
        }

        pageSearch =
            (mapsSearch[query].listSearch.length / numItemsPage).ceil();
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

        pageSearch = (listSearch.length / numItemsPage).ceil();
        if (pageSearch == 0) {
          pageSearch = 1;
        }
        mapsSearch[query] = ListSearchBuild<T>(
            listSearch: listSearch, isListSearchFull: finishPage);

        mapsSearch[query].listSearch =
            sortCompareListSearch(mapsSearch[query].listSearch);

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

  void onInitFilter() {
    if (filtersType.toString() == FiltersTypes.startsWith.toString()) {
      _filters = Filters.startsWith;
    } else if (filtersType.toString() == FiltersTypes.equals.toString()) {
      _filters = Filters.equals;
    } else {
      _filters = Filters.contains;
    }
  }

  void wrapListFull(List<T> listData) {
    // para aparecer a lupa no AppBar
    if (!bancoInit) {
      bancoInit = true;
      _bancoInit.close();
    }

    listFull.addAll(listData);
    sortCompareList(listFull);

    //TODO: montar cache
  }

  void refazFutureListFull() {
    if (snapshotScroolPage.loadinglistFullScroll) {
      page--;
    }
  }

  void refazFutureSearchQuery(String searchQuery) {
    //_oneMorePage = false;

    if (pageSearch > 1 && snapshotScroolPage.loadingSearchScroll) {
      if ((mapsSearch[searchQuery].listSearch.length ~/ numItemsPage) == 0) {
        page--;
      }
    }
  }

  void handleListEmpty() {
    if (listFull.isNotEmpty) {
      if (!isSearchModePage) {
        withData(listFull);
        // snapshotScroolPage = snapshotScroolPage.withData(listFull);
      }
    } else
      withError(Exception('It cannot return null. 😢'));
    //snapshotScroolPage =
    //snapshotScroolPage.withError(Exception('It cannot return null. 😢'));
  }

  void handleListDataSearchList({@required List<T> listData}) {
    if (listData == null) {
      return;
    }

    if (listData.isEmpty) {
      return;
    }

    if (listData.length - numItemsPage < 0) {}
  }

  void handleListDataFullList({@required List<T> listData}) {
    //print('length  ${listData.length.toString()} ');
    if (listData == null) {
      refazFutureListFull();

      handleListEmpty();

      return;
    }

    if (listData.isEmpty) {
      if (numItemsPage == 0) {
        withError(Exception('First return cannot have zero elements. 😢'));
        return;
      }

      finishPage = true;

      if (!isSearchModePage) {
        togleLoadinglistFullScroll();
      }

      return;
    }

    if (listData.length < 15 && numItemsPage == 0) {
      withError(Exception(
          'First return cannot be a list of less than 15 elements. 😢'));
      return;
    }

    if (listData.length - numItemsPage < 0) {
      wrapListFull(listData);

      finishPage = true;

      if (!isSearchModePage) {
        withData(listFull);
      }
      return;
    }

    if (numItemsPage == 0) {
      numItemsPage = listData.length;
    }

    wrapListFull(listData);

    if (!isSearchModePage) {
      withData(listFull);
    }
  }

  void sortCompareList(List<T> list) {
    if (compareSort != null) {
      list.sort(compareSort);
    }
  }

  List<T> sortCompareListSearch(List<T> list) {
    if (compareSort != null) {
      list.sort(compareSort);
    }

    return list;
  }

  FutureOr onClose() {
    _snapshotScroolPage.close();
    // _worker?.dispose();
    _isModSearch.close();
    rxSearch.close();
  }

  @override
  void inState() =>
      snapshotScroolPage = snapshotScroolPage.inState(ConnectionState.none);

  @override
  void waiting() => snapshotScroolPage = AsyncSnapshotScrollPage<T>.waiting();

  @override
  void withData(List<T> data) =>
      snapshotScroolPage = snapshotScroolPage.withData(data);

  @override
  void withError(Object error) =>
      snapshotScroolPage = snapshotScroolPage.withError(error);

  @override
  void togleLoadingSearchScroll() => snapshotScroolPage =
      snapshotScroolPage.togleLoadingSearchScroll(ConnectionState.none);

  @override
  void togleLoadinglistFullScroll() => snapshotScroolPage =
      snapshotScroolPage.togleLoadinglistFullScroll(ConnectionState.done);
}

@immutable
class AsyncSnapshotScrollPage<T> {
  final AsyncSnapshot<List<T>> snapshot;

  final bool loadinglistFullScroll;
  final bool loadingSearchScroll;

  const AsyncSnapshotScrollPage._(this.snapshot,
      {this.loadinglistFullScroll = false, this.loadingSearchScroll = false})
      // para demais ter corpo também
      : assert(snapshot != null);

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
}

class ListSearchBuild<T> {
  List<T> listSearch;
  bool isListSearchFull;

  ListSearchBuild({this.listSearch, this.isListSearchFull = false});
}
