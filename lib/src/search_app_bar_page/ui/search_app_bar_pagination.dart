import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/seacher_widget_page_base.dart';

import '../../../search_app_bar_page.dart';
import '../controller/searcher_page_pagination_controller.dart';

class SearchAppBarPagination<T> extends StatefulWidget
    implements SearcherScaffoldBase {
  /// Parameters do SearchAppBar

  final Widget? searchAppBartitle;
  final bool searchAppBarcenterTitle;
  final IconThemeData? searchAppBarIconTheme;
  final Color? searchAppBarbackgroundColor;
  final Color? searchAppBarModeSearchBackgroundColor;
  final Color? searchAppBarElementsColor;

  /// [searchAppBarIconConnectyOffAppBarColor] You can change the color of
  /// [iconConnectyOffAppBar]. By default = Colors.redAccent.
  final Color searchAppBarIconConnectyOffAppBarColor;
  final String? searchAppBarhintText;
  final bool searchAppBarFlattenOnSearch;
  final TextCapitalization searchAppBarCapitalization;
  final List<Widget> searchAppBarActions;
  final double searchAppBarElevation;
  final TextInputType? searchAppBarKeyboardType;

  /// [magnifyinGlassColor] Changes the color of the magnifying glass.
  /// Keeps IconTheme color by default.
  final Color? magnifyinGlassColor;

  /// [widgetEndScrollPage] shown when the end of the page arrives and
  /// awaits the Future of the data on the next page
  final Widget? widgetEndScrollPage;

  /// [widgetErrorBuilder] Widget built by the Object error returned by the
  /// [futureFetchPageItems] error.
  final WidgetsErrorBuilder? widgetErrorBuilder;

  /// [widgetNothingFound] when searching for something you don't find data.
  final Widget? widgetNothingFound;

  /// [searchePageFloaActionButton] , [searchePageFloaActionButton] ,
  /// [searchPageFloatingActionButtonLocation] ,
  /// [searchPageFloatingActionButtonAnimator]  ...
  /// ...
  /// are passed on to the Scaffold.
  @override
  final Widget? searchPageFloatingActionButton;
  @override
  final FloatingActionButtonLocation? searchPageFloatingActionButtonLocation;
  @override
  final FloatingActionButtonAnimator? searchPageFloatingActionButtonAnimator;
  @override
  final List<Widget>? searchPagePersistentFooterButtons;
  @override
  final Widget? searchPageDrawer;
  @override
  final Widget? searchPageEndDrawer;
  @override
  final Widget? searchPageBottomNavigationBar;
  @override
  final Widget? searchPageBottomSheet;
  @override
  final Color? searchPageBackgroundColor;
  @override
  final String? restorationId;
  @override
  final bool? resizeToAvoidBottomInset;
  @override
  final bool primary;
  @override
  final DragStartBehavior drawerDragStartBehavior;
  @override
  final bool extendBody;
  @override
  final bool extendBodyBehindAppBar;
  @override
  final Color? drawerScrimColor;
  @override
  final double? drawerEdgeDragWidth;
  @override
  final bool drawerEnableOpenDragGesture;
  @override
  final bool endDrawerEnableOpenDragGesture;

  /// [initialData] List to be filtered by Search.
  /// These widgets will not be displayed. [widgetOffConnectyWaiting] and
  /// Start showing [widgetWaiting] until it shows the first data
  final Widget? widgetWaiting;
  final List<T>? initialData;

  ///[futureFetchPageItems] Return the list in parts or parts by query String
  ///filtered. We make the necessary changes on the device side to update the
  ///page to be requested. Eg: If numItemsPage = 6 and you receive 05 or 11
  ///or send empty, = >>> it means that the data is over.
  final FutureFetchPageItems<T> futureFetchPageItems;

  /// [numItemsPage] Automatically calculated when receiving the first data.
  /// If it has [initialData] it cannot be null.
  final int? numItemsPage;

  /// [filtersType] These are the filters that the Controller uses to
  /// filter the list. Divide the filters into three types:
  /// startsWith, equals, contains. Default = FiltersTypes.contains;
  final FiltersTypes? filtersType;

  /// [paginationItemBuilder] Returns Widget from the object (<T>).
  /// This comes from the List <T> index.
  /// typedef WidgetsPaginationItemBuilder<T> = Widget Function(
  ///BuildContext context, int index, T objectIndex);
  /// final WidgetsPaginationItemBuilder<T> paginationItemBuilder;
  final WidgetsPaginationItemBuilder<T> paginationItemBuilder;

  /// [stringFilter] Required if you type.
  ///If not, it is understood that the type will be String.
  /// ex.: stringFilter: (Person person) => person.name,
  /// The list will be filtered by the person.name contains (default) a query.
  final StringFilter<T>? stringFilter;

  ///[sortCompare] Your list will be ordered by the same function
  ///[stringFilter]. True by default.
  final bool sortCompare;

  //final bool cache;

  ///  [rxBoolAuth] Insert your RxBool here that changes with the auth
  /// status to have reactivity.
  final RxBoolAuth? rxBoolAuth;

  const SearchAppBarPagination({
    super.key,
    required this.futureFetchPageItems,
    required this.paginationItemBuilder,
    this.sortCompare = true,
    this.numItemsPage,
    this.widgetEndScrollPage,
    this.initialData,
    this.filtersType,
    this.stringFilter,
    //this.cache = false,
    this.rxBoolAuth,
    this.searchAppBartitle,
    this.searchAppBarcenterTitle = false,
    this.searchAppBarIconTheme,
    this.searchAppBarbackgroundColor,
    this.searchAppBarModeSearchBackgroundColor,
    this.searchAppBarElementsColor,
    this.searchAppBarIconConnectyOffAppBarColor = Colors.redAccent,
    this.searchAppBarhintText,
    this.searchAppBarFlattenOnSearch = false,
    this.searchAppBarCapitalization = TextCapitalization.none,
    this.searchAppBarActions = const <Widget>[],
    this.searchAppBarElevation = 4.0,
    this.searchAppBarKeyboardType,
    this.magnifyinGlassColor,
    this.widgetErrorBuilder,
    this.widgetNothingFound,
    this.searchPageFloatingActionButton,
    this.searchPageFloatingActionButtonLocation,
    this.searchPageFloatingActionButtonAnimator,
    this.searchPagePersistentFooterButtons,
    this.searchPageDrawer,
    this.searchPageEndDrawer,
    this.searchPageBottomNavigationBar,
    this.searchPageBottomSheet,
    this.searchPageBackgroundColor,
    this.restorationId,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.widgetWaiting,
  });

  @override
  _SearchAppBarPaginationState<T> createState() =>
      _SearchAppBarPaginationState<T>();
}

class _SearchAppBarPaginationState<T> extends State<SearchAppBarPagination<T>> {
  final String className = '_ _SearchAppBarPaginationState ___ ...  ';
  Object? _activeListFullCallbackIdentity;

  SearchCallBack? _activeListSearchCallbackIdentity;

  StreamSubscription? _subscriptionConnecty;

  bool _haveInitialData = false;

  late ScrollController _scrollController;

  Worker? _worker;

  Widget? _widgetWaiting;

  Widget? _widgetNothingFound;
  Widget? _widgetEndScrollPage;

  late SearcherPagePaginationController<T> _controller;

  @override
  void initState() {
    if (widget.numItemsPage != null && widget.numItemsPage! < 15) {
      throw Exception('The minimum value for the number of elements is 15.');
    }

    if (widget.initialData != null && widget.numItemsPage == null) {
      throw Exception(
          'It is necessary to add the number of items per page so that '
          'can calculate the home page');
    }
    super.initState();

    /*_controller = Get.put(SearcherPagePaginationController<T>(
        stringFilter: widget.stringFilter,
        //compareSort: widget.compareSort,
        sortCompare: widget.sortCompare,
        filtersType: widget.filtersType)
      ..onInitFilter());*/

    _controller = SearcherPagePaginationController<T>(
        stringFilter: widget.stringFilter,
        //compareSort: widget.compareSort,
        sortCompare: widget.sortCompare,
        filtersType: widget.filtersType)
      ..onInitFilter();

    _scrollController = ScrollController();
    _scrollController.addListener(pagesListener);

    if (widget.numItemsPage != null) {
      _controller.numItemsPage = widget.numItemsPage;
    }
    _haveInitialData = widget.initialData != null;

    if (_haveInitialData) {
      if (_controller.numItemsPage != 0) {
        _controller.page =
            (widget.initialData!.length / widget.numItemsPage!).ceil();
      }

      _controller.listFull.addAll(widget.initialData!);
      _controller.sortCompareList(_controller.listFull);
      _controller.withData(widget.initialData);
    }

    _subscribreSearhQuery();
    _buildWidgetsDefault();
    _firstFuturePageSubscribe();

    buildDeafultWidgets();
  }

  void _firstFuturePageSubscribe({bool scroollEndPage = false}) {
    final Object callbackIdentity = Object();
    _activeListFullCallbackIdentity = callbackIdentity;

    widget.futureFetchPageItems(_controller.page, '').then<void>(
        (List<T>? data) {
      if (_activeListFullCallbackIdentity == callbackIdentity) {
        _controller.handleListDataFullList(
            listData: data,
            scroollEndPage: scroollEndPage,
            newPageFuture: () {
              _firstFuturePageSubscribe(scroollEndPage: true);
            });
      }
    }, onError: (Object error) {
      if (_activeListFullCallbackIdentity == callbackIdentity) {
        _controller.oneMoreListFullPage = false;
        _controller.refazFutureListFull();

        _controller.withError(error);
      }
    });

    if (!scroollEndPage) {
      _controller.waiting();
    }
  }

  void _futureSearchPageQuery(String? query, {bool scroollEndPage = false}) {
    if (_activeListSearchCallbackIdentity != null) {
      _unsubscribeSearhCallBack();
    }
    final SearchCallBack callbackSearchIdentity = SearchCallBack(query);
    _activeListSearchCallbackIdentity = callbackSearchIdentity;
    if (!scroollEndPage) {
      _controller.waiting();
    }

    widget.futureFetchPageItems(_controller.pageSearch, query).then((data) {
      if (_activeListSearchCallbackIdentity == callbackSearchIdentity) {
        _controller.handleListDataSearchList(
            listData: data,
            query: callbackSearchIdentity.query,
            newSearchPageFuture: () {
              //Nova pagina pela pagina anterior incompleta
              _futureSearchPageQuery(query, scroollEndPage: true);
            });
      }
    }, onError: (Object error) {
      if (_activeListSearchCallbackIdentity == callbackSearchIdentity) {
        _controller.oneMoreSearchPage = false;
        _controller.refazFutureSearchQuery(callbackSearchIdentity.query);

        _controller.withError(error);
      }
    });
  }

  void pagesListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 3 &&
        _scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
      if (_controller.rxSearch.value.isNotEmpty) {
        //if (_activeListSearchCallbackIdentity != null) {
        if (!_controller
            .mapsSearch[_controller.rxSearch.value]!.isListSearchFull) {
          if (!_controller.snapshotScroolPage.loadingSearchScroll) {
            final listBuilder =
                _controller.haveSearchQueryPage(_controller.rxSearch.value);

            if (listBuilder.isListSearchFull) {
              _controller.withData(listBuilder.listSearch);
            } else {
              debugPrint('listFullSearchQuery '
                  '${listBuilder.listSearch.toString()}');

              if (listBuilder.listSearch.length -
                      (_controller.pageSearch * _controller.numItemsPage!) ==
                  0) {
                _controller.pageSearch++;
              } else {
                _controller.oneMoreSearchPage = true;
              }
              _controller.togleLoadingSearchScroll(true);

              _futureSearchPageQuery(_controller.rxSearch.value,
                  scroollEndPage: true);
            }
          }
        }
      } else {
        //if (_activeListFullCallbackIdentity != null) {
        if (!_controller.finishPage) {
          if (!_controller.snapshotScroolPage.loadinglistFullScroll) {
            /*print('$className TESTE -LISTFULL length - '
                '${'${_controller.listFull.length.toString()} '}');

            print('$className TESTE - PAGE- '
                '${'${_controller.page.toString()} '}');*/
            if (_controller.listFull.length -
                    (_controller.page * _controller.numItemsPage!) ==
                0) {
              _controller.page++;
            } else {
              _controller.oneMoreListFullPage = true;
            }

            if (_activeListFullCallbackIdentity != null) {
              _unsubscribeListFullCallBack();
            }
            _controller.togleLoadinglistFullScroll();

            // nao recebe pagina quebrada atá acabar os dados
            _firstFuturePageSubscribe(scroollEndPage: true);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SearchAppBar(
            controller: _controller,
            title: widget.searchAppBartitle,
            centerTitle: widget.searchAppBarcenterTitle,
            elevation: widget.searchAppBarElevation,
            iconTheme: widget.searchAppBarIconTheme,
            backgroundColor: widget.searchAppBarbackgroundColor,
            searchBackgroundColor: widget.searchAppBarModeSearchBackgroundColor,
            searchElementsColor: widget.searchAppBarElementsColor,
            hintText: widget.searchAppBarhintText,
            flattenOnSearch: widget.searchAppBarFlattenOnSearch,
            capitalization: widget.searchAppBarCapitalization,
            actions: widget.searchAppBarActions,
            keyboardType: widget.searchAppBarKeyboardType,
            magnifyGlassColor: widget.magnifyinGlassColor),
        body: buildBody(),
        floatingActionButton: widget.searchPageFloatingActionButton,
        floatingActionButtonLocation:
            widget.searchPageFloatingActionButtonLocation,
        floatingActionButtonAnimator:
            widget.searchPageFloatingActionButtonAnimator,
        persistentFooterButtons: widget.searchPagePersistentFooterButtons,
        drawer: widget.searchPageDrawer,
        endDrawer: widget.searchPageEndDrawer,
        bottomNavigationBar: widget.searchPageBottomNavigationBar,
        bottomSheet: widget.searchPageBottomSheet,
        backgroundColor: widget.searchPageBackgroundColor,
        restorationId: widget.restorationId,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        primary: widget.primary,
        drawerDragStartBehavior: widget.drawerDragStartBehavior,
        extendBody: widget.extendBody,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        drawerScrimColor: widget.drawerScrimColor,
        drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture);
  }

  Widget? buildBody() {
    return Obx(() {
      if (widget.rxBoolAuth?.auth.value == false) {
        return widget.rxBoolAuth!.authFalseWidget();
      }
      if (_controller.snapshotScroolPage.snapshot.connectionState ==
          ConnectionState.waiting) {
        return _widgetWaiting!;
      }

      if (_controller.snapshotScroolPage.snapshot.hasError) {
        return buildWidgetError(_controller.snapshotScroolPage.snapshot.error);
      }

      if (_controller.data.isEmpty) {
        return _widgetNothingFound!;
      }
      return ListView.builder(
        controller: _scrollController,
        itemCount: (_controller.snapshotScroolPage.loadingSearchScroll ||
                _controller.snapshotScroolPage.loadinglistFullScroll)
            ? _controller.data.length + 1
            : _controller.data.length,
        itemBuilder: (ctx, index) {
          if (index == _controller.data.length) {
            return _widgetEndScrollPage!;
          }

          return widget.paginationItemBuilder(
              context, index, _controller.data[index]);
        },
      );
    });
  }

  void _subscribreSearhQuery() {
    _worker = debounce<String>(_controller.rxSearch, (String query) {
      if (query.isNotEmpty) {
        if (_controller.snapshotScroolPage.loadingSearchScroll) {
          _controller.togleLoadingSearchScroll(false);
        }
        _controller.oneMoreSearchPage = false;
        initBuildSearchList(query);
      } else {
        _controller.withData(_controller.listFull);
        //_controller.snapshotScroolPage =
        // _controller.snapshotScroolPage.withData(_controller.listFull);
      }
    }, time: const Duration(milliseconds: 350));
  }

  void initBuildSearchList(String query, {bool restart = false}) {
    final listBuilder =
        _controller.haveSearchQueryPage(query, restart: restart);

    if (listBuilder.listSearch.isNotEmpty) {
      if (listBuilder.isListSearchFull) {
        _controller.withData(listBuilder.listSearch);
      } else {
        if (listBuilder.listSearch.length < _controller.numItemsPage!) {
          _controller.mapsSearch[query]!.listSearch.clear();
          _futureSearchPageQuery(query);
        } else {
          _controller.withData(listBuilder.listSearch);
        }
      }
    } else if (listBuilder.listSearch.isEmpty && listBuilder.isListSearchFull) {
      _controller.withData(listBuilder.listSearch);
    } else {
      _futureSearchPageQuery(query);
    }
  }

  @override
  void didUpdateWidget(covariant SearchAppBarPagination<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    _controller.stringFilter = widget.stringFilter;
    //_controller.compareSort = widget.compareSort;
    _controller.sortCompare = widget.sortCompare;
    _controller.filtersType = widget.filtersType;
    _controller.onInitFilter();

    if (oldWidget.initialData != widget.initialData) {
      if (widget.initialData != null && widget.numItemsPage == null) {
        throw Exception(
            'It is necessary to add the number of items per page so that '
            'can calculate the home page.');
      } else {
        _haveInitialData = widget.initialData != null;

        if (_haveInitialData) {
          if (widget.initialData!.length > _controller.listFull.length) {
            _unsubscribeListFullCallBack();

            _controller.page =
                (widget.initialData!.length / widget.numItemsPage!).ceil();

            if (_controller.page == 0) _controller.page = 1;

            _controller.listFull.clear();
            _controller.listFull.addAll(widget.initialData!);
            _controller.sortCompareList(_controller.listFull);

            if (_controller.rxSearch.value.isEmpty) {
              _controller.withData(_controller.listFull);
            } else {
              _controller.oneMoreSearchPage = false;

              initBuildSearchList(_controller.rxSearch.value,
                  //refaz a listSearch pois temos uma nova listFull
                  restart: true);
            }
          }
        }
      }
    }

    if (_controller.listFull.isEmpty) {
      if (oldWidget.futureFetchPageItems != widget.futureFetchPageItems) {
        if (_activeListFullCallbackIdentity != null) {
          _unsubscribeListFullCallBack();

          _controller.inState();
        }

        _firstFuturePageSubscribe();
      }
    }
  }

  @override
  void dispose() {
    _unsubscribeListFullCallBack();
    _unsubscribeSearhCallBack();
    _controller.onClose();
    _scrollController.removeListener(pagesListener);
    _scrollController.dispose();
    if (_worker?.disposed == true) {
      _worker?.dispose();
    }

    _subscriptionConnecty?.cancel();

    super.dispose();
  }

  void _unsubscribeListFullCallBack() {
    _activeListFullCallbackIdentity = null;
  }

  void _unsubscribeSearhCallBack() {
    _activeListSearchCallbackIdentity = null;
  }

  void buildDeafultWidgets() {
    if (widget.widgetNothingFound == null) {
      _widgetNothingFound = const Center(
          child: Text(
        'NOTHING FOUND',
        style: TextStyle(fontSize: 14),
      ));
    } else {
      _widgetNothingFound = widget.widgetNothingFound;
    }

    if (widget.widgetEndScrollPage == null) {
      _widgetEndScrollPage = Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 20, top: 10),
          width: 30,
          height: 30,
          child: const CircularProgressIndicator(),
        ),
      );
    } else {
      _widgetEndScrollPage = widget.widgetEndScrollPage;
    }
  }

  Widget buildWidgetError(Object? error) {
    if (widget.widgetErrorBuilder == null) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'We found an error.\n'
                  'Error: $error',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ]);
    } else {
      return widget.widgetErrorBuilder!(error);
    }

    //return _widgetError;
  }

  void _buildWidgetsDefault() {
    if (widget.widgetWaiting == null) {
      _widgetWaiting = const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    } else {
      _widgetWaiting = widget.widgetWaiting;
    }
  }
}

class SearchCallBack {
  final String? query;

  SearchCallBack(this.query);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchCallBack && other.query == query;
  }

  @override
  int get hashCode => query.hashCode;
}
