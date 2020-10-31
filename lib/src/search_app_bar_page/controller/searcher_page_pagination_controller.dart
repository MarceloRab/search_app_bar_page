import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_state_manager/get_state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/seacher_base_controll.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/filters_type.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/infra/search_pagination_base.dart';

typedef CallBack = void Function();

typedef CallBackListData<T> = void Function(List<T> listData);

class SearcherPagePaginationController<T> extends SeacherBase<T>
    with SearcherPaginnationBase<T> {
  final RxBool _isModSearch = false.obs;

  @override
  bool get isModSearch => _isModSearch.value;

  bool get isSearchModePage => rxSearch.value.isNotEmpty;

  @override
  set isModSearch(bool value) => _isModSearch.value = value;

  @override
  bool sortCompare = true;

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

  List<T> get data => snapshotScroolPage.snapshot.data;

  set snapshotScroolPage(AsyncSnapshotScrollPage<T> value) =>
      _snapshotScroolPage.value = value;

  FiltersTypes filtersType;
  Filter<String> _filters;
  StringFilter<T> stringFilter;

  //Compare<T> compareSort;

  int page = 1;
  int pageSearch = 1;

  int numItemsPage = 0;

  //Future<List<T>> functionFuturePageItems(FutureFetchPageItems<T> func) =>
  //func(page, rxSearch.value);

  //StringFilter<T> get _defaultFilter => (T value) => value as String;

  Map<String, ListSearchBuild<T>> mapsSearch = {};

  SearcherPagePaginationController({
    this.stringFilter,
    this.sortCompare,
    this.filtersType = FiltersTypes.contains,
    //this.cache = false,
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
  }

  var listFull = <T>[];

  //final bool cache;

  ListSearchBuild<T> buildPreviousList(String query) {
    ListSearchBuild<T> listAnterior = ListSearchBuild(listSearch: <T>[]);
    String queryStringAnterior =
        query.replaceRange(query.length - 1, query.length, '');
    if (mapsSearch.containsKey(queryStringAnterior)) {
      return mapsSearch[queryStringAnterior];
    }
    // while (!mapsSearch.containsKey(queryStringAnterior) ||
    while (queryStringAnterior.isNotEmpty) {
      queryStringAnterior = queryStringAnterior.replaceRange(
          queryStringAnterior.length - 1, queryStringAnterior.length, '');

      if (mapsSearch.containsKey(queryStringAnterior)) {
        listAnterior = mapsSearch[queryStringAnterior];

        break;
      }
    }
    //do {} while (queryStringAnterior.isEmpty ||

    return listAnterior;
  }

  ListSearchBuild<T> haveSearchQueryPage(String query, {bool restart = false}) {
    //queryProgride(query);
    pageSearch = 1;
    var listSearch = <T>[];

    // subdivisao da listSearch
    if (query.length > 1) {
      ListSearchBuild<T> buildListAnterior;

      //final queryStringAnterior =
      // query.replaceRange(query.length - 1, query.length, '');

      buildListAnterior = buildPreviousList(query);

      listSearch = buildListAnterior.listSearch
          .where((element) => _filters(stringFilter(element), query))
          .toList();

      // tem cache da query.
      if (mapsSearch.containsKey(query)) {
        if (mapsSearch[query].isListSearchFull) {
          pageSearch =
              (mapsSearch[query].listSearch.length / numItemsPage).ceil();
          if (pageSearch == 0) {
            pageSearch = 1;
          }

          return mapsSearch[query];
        }

        if (buildListAnterior.listSearch.isNotEmpty) {
          //Ja contem algo
          if (listSearch.length > mapsSearch[query].listSearch.length) {
            pageSearch = (listSearch.length / numItemsPage).ceil();
            if (pageSearch == 0) {
              pageSearch = 1;
            }
            mapsSearch[query] = ListSearchBuild<T>(
                listSearch: listSearch,
                // se a anterior esta full a atual tb.
                isListSearchFull: buildListAnterior.isListSearchFull);
            mapsSearch[query].listSearch =
                sortCompareListSearch(mapsSearch[query].listSearch);
          }

          if (buildListAnterior.isListSearchFull) {
            return mapsSearch[query];
          }
        } else {
          if (buildListAnterior.isListSearchFull) {
            mapsSearch[query] = ListSearchBuild<T>(
                listSearch: listSearch,
                // se a anterior esta full a atual tb.
                isListSearchFull: true);
            mapsSearch[query].listSearch =
                sortCompareListSearch(mapsSearch[query].listSearch);
            return mapsSearch[query];
          }
          listSearch.clear();
          listSearch = listFull
              .where((element) => _filters(stringFilter(element), query))
              .toList();

          if (listSearch.length > mapsSearch[query].listSearch.length) {
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
        // sem cache da query.
      } else {
        if (buildListAnterior.listSearch.isNotEmpty) {
          mapsSearch[query] = ListSearchBuild<T>(
              listSearch: listSearch,
              // se a anterior esta full a atual tb.
              isListSearchFull: buildListAnterior.isListSearchFull);
          mapsSearch[query].listSearch =
              sortCompareListSearch(mapsSearch[query].listSearch);

          pageSearch =
              (mapsSearch[query].listSearch.length / numItemsPage).ceil();
          if (pageSearch == 0) {
            pageSearch = 1;
          }
        } else {
          if (buildListAnterior.isListSearchFull) {
            mapsSearch[query] = ListSearchBuild<T>(
                listSearch: listSearch,
                // se a anterior esta full a atual tb.
                isListSearchFull: true);
            mapsSearch[query].listSearch =
                sortCompareListSearch(mapsSearch[query].listSearch);
            return mapsSearch[query];
          }
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

  set initialChangeList(List<T> list) {
    if (!bancoInit) {
      bancoInit = true;
      _bancoInit.close();
    }

    listFull.addAll(list);
    sortCompareList(listFull);
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

// Porque o resultado do Search pode ter uma quantidade de elementos quebrado
  // dentro de uma lista nao multipla
  bool oneMoreSearchPage = false;

  // Porque o initialData pode ter uma quantidade de elementos nao multiplo
  bool oneMoreListFullPage = false;

  void handleListDataSearchList(
      {@required List<T> listData,
      @required String query,
      @required VoidCallback newSearchPageFuture}) {
    if (listData == null) {
      oneMoreSearchPage = false;
      refazFutureSearchQuery(query);

      if (isSearchModePage) {
        withData(mapsSearch[query].listSearch);
      }

      //return;
    } else if (listData.isEmpty) {
      oneMoreSearchPage = false;

      mapsSearch[query].isListSearchFull = true;

      if (isSearchModePage) {
        withData(mapsSearch[query].listSearch);
        //return;
      }
    } else if (listData.length - numItemsPage < 0) {
      oneMoreSearchPage = false;

      final num = (pageSearch - 1) * numItemsPage;
      mapsSearch[query]
          .listSearch
          .removeRange(num, mapsSearch[query].listSearch.length);
      mapsSearch[query].listSearch.addAll(listData);

      mapsSearch[query].isListSearchFull = true;

      if (isSearchModePage) {
        withData(mapsSearch[query].listSearch);
      }

      //return;
    } else if (listData.length - numItemsPage > 0) {
      oneMoreSearchPage = false;
      withError(Exception(
          'It must return at most or number of elements on a page. 😢'));
    } else {
      if (oneMoreSearchPage) {
        final num = (pageSearch - 1) * numItemsPage;

        mapsSearch[query]
            .listSearch
            .removeRange(num, mapsSearch[query].listSearch.length);
        mapsSearch[query].listSearch.addAll(listData);
        oneMoreSearchPage = false;
        pageSearch++;
        newSearchPageFuture();
      } else {
        oneMoreSearchPage = false;
        mapsSearch[query].listSearch.addAll(listData);

        if (isSearchModePage) {
          withData(mapsSearch[query].listSearch);
        }
      }
    }

    //listData.length == _controller.numItemsPage =
    // == > vide metodo na view
  }

  void handleListDataFullList(
      {@required List<T> listData,
      @required bool scroollEndPage,
      @required VoidCallback newPageFuture}) {
    //print('length  ${listData.length.toString()} ');

    if (scroollEndPage) {
      togleLoadinglistFullScroll();
    }

    if (listData == null) {
      oneMoreListFullPage = false;
      refazFutureListFull();

      handleListEmpty();
    } else if (listData.isEmpty) {
      oneMoreListFullPage = false;

      if (numItemsPage == 0) {
        withError(Exception('First return cannot have zero elements. 😢'));
        //return;
      }
      finishPage = true;
    } else if (listData.length < 15 && numItemsPage == 0) {
      oneMoreListFullPage = false;

      withError(Exception(
          'First return cannot be a list of less than 15 elements. 😢'));
      //return;
    } else if (listData.length - numItemsPage < 0) {
      oneMoreListFullPage = false;

      wrapListFull(listData);

      finishPage = true;

      if (!isSearchModePage) {
        withData(listFull);
      }
    } else if (listData.length - numItemsPage > 0 && numItemsPage != 0) {
      oneMoreListFullPage = false;

      withError(Exception(
          'It must return at most or number of elements on a page. 😢'));
    } else {
      if (numItemsPage == 0) {
        numItemsPage = listData.length;
      }

      if (oneMoreListFullPage) {
        final num = (page - 1) * numItemsPage;

        listFull.removeRange(num, listFull.length);
        listFull.addAll(listData);
        page++;
        oneMoreListFullPage = false;
        newPageFuture();
      } else {
        wrapListFull(listData);

        if (!isSearchModePage) {
          withData(listFull);
        }
      }
    }
  }

  @override
  void sortCompareList(List<T> list) {
    /*if (compareSort != null) {
      list.sort(compareSort);
    }*/

    if (sortCompare) {
      list.sort((a, b) => stringFilter(a).compareTo(stringFilter(b)));
    }
  }

  List<T> sortCompareListSearch(List<T> list) {
    /*if (compareSort != null) {
      list.sort(compareSort);
    }
    */
    if (sortCompare) {
      list.sort((a, b) => stringFilter(a).compareTo(stringFilter(b)));
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
  void togleLoadingSearchScroll(bool value) =>
      snapshotScroolPage = snapshotScroolPage.togleLoadingSearchScroll(value);

  @override
  void togleLoadinglistFullScroll() =>
      snapshotScroolPage = snapshotScroolPage.togleLoadinglistFullScroll();
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

  AsyncSnapshotScrollPage<T> togleLoadingSearchScroll(bool value) =>
      AsyncSnapshotScrollPage<T>._(snapshot.inState(ConnectionState.none),
          loadingSearchScroll: value);

  AsyncSnapshotScrollPage<T> togleLoadinglistFullScroll() =>
      AsyncSnapshotScrollPage<T>._(snapshot.inState(ConnectionState.done),
          loadinglistFullScroll: !loadinglistFullScroll);
}

class ListSearchBuild<T> {
  List<T> listSearch;
  bool isListSearchFull;

  ListSearchBuild({this.listSearch, this.isListSearchFull = false});
}
