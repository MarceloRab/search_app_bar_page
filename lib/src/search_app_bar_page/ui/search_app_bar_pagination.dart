import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_state_manager/get_state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/connecty_controller.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/filters_type.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';

import '../controller/searcher_page_pagination_future_controller.dart';
import 'core/search_app_bar/search_app_bar.dart';

class SearchAppBarPagination<T> extends StatefulWidget {
  /// Parameters do SearchAppBar

  final Widget searchAppBartitle;
  final bool searchAppBarcenterTitle;
  final IconThemeData searchAppBariconTheme;
  final Color searchAppBarbackgroundColor;
  final Color searchAppBarModeSearchBackgroundColor;
  final Color searchAppBarElementsColor;

  /// [searchAppBarIconConnectyOffAppBarColor] You can change the color of
  /// [iconConnectyOffAppBar]. By default = Colors.redAccent.
  final Color searchAppBarIconConnectyOffAppBarColor;
  final String searchAppBarhintText;
  final bool searchAppBarflattenOnSearch;
  final TextCapitalization searchAppBarcapitalization;
  final List<Widget> searchAppBaractions;
  final double searchAppBarelevation;
  final TextInputType searchAppBarKeyboardType;

  /// [magnifyinGlassColor] Changes the color of the magnifying glass.
  /// Keeps IconTheme color by default.
  final Color magnifyinGlassColor;

  ///[iconConnectyOffAppBar] Appears when the connection status is off.
  ///There is already a default icon. If you don't want to present a choice
  ///[hideDefaultConnectyIconOffAppBar] = true; If you want to have a
  ///custom icon, do [hideDefaultConnectyIconOffAppBar] = true; and set the
  ///[iconConnectyOffAppBar]`.
  final bool hideDefaultConnectyIconOffAppBar;

  /// [iconConnectyOffAppBar] Displayed on the AppBar when the internet
  /// connection is switched off.
  /// It is always the closest to the center.
  final Widget iconConnectyOffAppBar;

  /// Parametros para o Scaffold

  ///  [widgetOffConnectyWaiting] Apenas mostra algo quando esta sem conexao
  ///  e ainda nao tem o primeiro valor da stream. Se a conexao voltar
  ///  passa a mostrar o [widgetWaiting] até apresentar o primeiro dado
  final Widget widgetWaiting;
  final Widget widgetOffConnectyWaiting;

  /// [widgetEndScrollPage] shown when the end of the page arrives and
  /// awaits the Future of the data on the next page
  final Widget widgetEndScrollPage;

  /// [widgetErrorBuilder] Widget built by the Object error returned by the
  /// [futureFetchPageItems] error.
  final WidgetsErrorBuilder widgetErrorBuilder;

  /// [widgetNothingFound] when searching for something you don't find data.
  final Widget widgetNothingFound;

  /// [searchePageFloaActionButton] , [searchePageFloaActionButton] ,
  /// [searchePageFloatingActionButtonLocation] ,
  /// [searchePageFloatingActionButtonAnimator]  ...
  /// ...
  /// are passed on to the Scaffold.
  final Widget searchePageFloaActionButton;
  final FloatingActionButtonLocation searchePageFloatingActionButtonLocation;
  final FloatingActionButtonAnimator searchePageFloatingActionButtonAnimator;
  final List<Widget> searchePagePersistentFooterButtons;
  final Widget searchePageDrawer;
  final Widget searchePageEndDrawer;
  final Widget searchePageBottomNavigationBar;
  final Widget searchePageBottomSheet;
  final Color searchPageBackgroundColor;
  final bool resizeToAvoidBottomPadding;
  final bool resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color drawerScrimColor;
  final double drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;

  /// [initialData] List to be filtered by Search.
  /// These widgets will not be displayed. [widgetOffConnectyWaiting] and
  /// [widgetWaiting]
  final List<T> initialData;

  ///[futureFetchPageItems] Return the list in parts or parts by query String
  ///filtered. We make the necessary changes on the device side to update the
  ///page to be requested. Eg: If numItemsPage = 6 and you receive 05 or 11
  ///or send empty, = >>> it means that the data is over.
  final FutureFetchPageItems<T> futureFetchPageItems;

  /// [numItemsPage] Automatically calculated when receiving the first data.
  /// If it has [initialData] it cannot be null.
  final int numItemsPage;

  /// [filtersType] These are the filters that the Controller uses to
  /// filter the list. Divide the filters into three types:
  /// startsWith, equals, contains. Default = FiltersTypes.contains;
  final FiltersTypes filtersType;

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
  final StringFilter<T> stringFilter;

  ///[compareSort] If you want your list to be sorted, pass the function on.
  /// Example: (Person a, Person b) => a.name.compareTo(b.name),
  /// This list will be ordered by the object name parameter.
  final Compare<T> compareSort;

  final bool cache;

  const SearchAppBarPagination({
    Key key,
    @required this.futureFetchPageItems,
    @required this.paginationItemBuilder,
    this.cache = false,
    this.searchAppBartitle,
    this.searchAppBarcenterTitle = false,
    this.searchAppBariconTheme,
    this.searchAppBarbackgroundColor,
    this.searchAppBarModeSearchBackgroundColor,
    this.searchAppBarElementsColor,
    this.searchAppBarIconConnectyOffAppBarColor = Colors.redAccent,
    this.searchAppBarhintText,
    this.searchAppBarflattenOnSearch = false,
    this.searchAppBarcapitalization = TextCapitalization.none,
    this.searchAppBaractions = const <Widget>[],
    this.searchAppBarelevation = 4.0,
    this.hideDefaultConnectyIconOffAppBar = false,
    this.iconConnectyOffAppBar,
    this.searchAppBarKeyboardType,
    this.magnifyinGlassColor,
    this.widgetWaiting,
    this.widgetOffConnectyWaiting,
    this.widgetErrorBuilder,
    this.widgetNothingFound,
    this.searchePageFloaActionButton,
    this.searchePageFloatingActionButtonLocation,
    this.searchePageFloatingActionButtonAnimator,
    this.searchePagePersistentFooterButtons,
    this.searchePageDrawer,
    this.searchePageEndDrawer,
    this.searchePageBottomNavigationBar,
    this.searchePageBottomSheet,
    this.searchPageBackgroundColor,
    this.resizeToAvoidBottomPadding,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.initialData,
    this.filtersType,
    this.stringFilter,
    this.compareSort,
    this.numItemsPage,
    this.widgetEndScrollPage,
  }) : /*assert(numItemsPage != null && numItemsPage < 15,
            'The minimum value for the number of elements is 15.'),
        assert(
            initialData != null && numItemsPage == null,
            'It is necessary to pass the number of items per page so that '
            'can calculate the home pag'),*/
        super(key: key);

  @override
  _SearchAppBarPaginationState<T> createState() =>
      _SearchAppBarPaginationState<T>();
}

class _SearchAppBarPaginationState<T> extends State<SearchAppBarPagination<T>> {
  Object _activeListFullCallbackIdentity;

  SearchCallBack _activeListSearchCallbackIdentity;

  ConnectController _connectyController;
  StreamSubscription _subscriptionConnecty;

  bool _haveInitialData;
  bool downConnectyWithoutData = false;

  Widget _widgetConnecty;

  ScrollController _scrollController;

  Worker _worker;

  Widget _widgetWaiting;

  Widget _widgetNothingFound;
  Widget _widgetEndScrollPage;

  SearcherPagePaginationFutureController<T> _controller;

  @override
  void initState() {
    if (widget.numItemsPage != null && widget.numItemsPage < 15) {
      throw Exception('The minimum value for the number of elements is 15.');
    }

    if (widget.initialData != null && widget.numItemsPage == null) {
      throw Exception(
          'It is necessary to pass the number of items per page so that '
          'can calculate the home page');
    }
    super.initState();

    _controller = SearcherPagePaginationFutureController<T>(
        stringFilter: widget.stringFilter,
        compareSort: widget.compareSort,
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
            (widget.initialData.length / widget.numItemsPage).ceil();
      }

      _controller.listFull.addAll(widget.initialData);
      _controller.sortCompareList(_controller.listFull);
      _controller.withData(widget.initialData);
    } else {
      _connectyController = ConnectController();
      _subscribeConnecty();
    }

    _subscribreSearhQuery();
    _firstFuturePageSubscribe();

    if (widget.widgetOffConnectyWaiting == null) {
      _widgetConnecty = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Check connection...',
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      );
    } else {
      _widgetConnecty = widget.widgetOffConnectyWaiting;
    }

    buildDeafultWidgets();
  }

  void _firstFuturePageSubscribe({bool scroollEndPage = false}) {
    final Object callbackIdentity = Object();
    _activeListFullCallbackIdentity = callbackIdentity;

    widget.futureFetchPageItems(_controller.page, '').then<void>(
        (List<T> data) {
      if (_activeListFullCallbackIdentity == callbackIdentity) {
        if (data != null) {
          if (downConnectyWithoutData) {
            downConnectyWithoutData = false;
            _unsubscribeConnecty();
          }
        }

        _controller.handleListDataFullList(
            listData: data, scroollEndPage: scroollEndPage);
      }
    }, onError: (Object error) {
      if (_activeListFullCallbackIdentity == callbackIdentity) {
        _controller.refazFutureListFull();

        _controller.withError(error);
      }
    });

    if (!scroollEndPage) {
      _controller.waiting();
    }
  }

  void _futureSearchPageQuery(String query, {bool scroollEndPage = false}) {
    if (_activeListSearchCallbackIdentity != null) {
      _unsubscribeSearhCallBack();
    }
    final SearchCallBack callbackIdentity = SearchCallBack(query);
    _activeListSearchCallbackIdentity = callbackIdentity;
    if (!scroollEndPage) {
      _controller.waiting();
    }

    widget.futureFetchPageItems(_controller.pageSearch, query).then((data) {
      if (_activeListSearchCallbackIdentity == callbackIdentity) {
        _controller.handleListDataSearchList(
            listData: data,
            query: callbackIdentity.query,
            newPageFuture: () {
              //Nova pagina pela pagina anterior incompleta
              _futureSearchPageQuery(query, scroollEndPage: true);
            });
      }
    }, onError: (Object error) {
      if (_activeListSearchCallbackIdentity == callbackIdentity) {
        _controller.refazFutureSearchQuery(callbackIdentity.query);

        _controller.withError(error);
      }
    });
  }

  void pagesListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 3 &&
        _scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
      if (_activeListFullCallbackIdentity != null) {
        if (_controller.rxSearch.value.isNotEmpty) {
          if (!_controller
              .mapsSearch[_controller.rxSearch.value].isListSearchFull) {
            if (!_controller.snapshotScroolPage.loadingSearchScroll) {
              final listBuilder =
                  _controller.haveSearchQueryPage(_controller.rxSearch.value);

              if (listBuilder.isListSearchFull) {
                _controller.withData(listBuilder.listSearch);
              } else {
                debugPrint('listFullSearchQuery '
                    // ignore: lines_longer_than_80_chars
                    '${listBuilder.listSearch.toString()}');

                if (listBuilder.listSearch.length -
                        (_controller.pageSearch * _controller.numItemsPage) ==
                    0) {
                  _controller.pageSearch++;
                } else {
                  _controller.oneMorePage = true;
                }
                _controller.togleLoadingSearchScroll(true);

                _futureSearchPageQuery(_controller.rxSearch.value,
                    scroollEndPage: true);
              }
            }
          }
        } else {
          if (!_controller.finishPage) {
            if (!_controller.snapshotScroolPage.loadinglistFullScroll) {
              if (_activeListFullCallbackIdentity != null) {
                _unsubscribeListFullCallBack();
              }
              _controller.togleLoadinglistFullScroll();

              _controller.page++;

              // nao recebe pagina quebrada atá acabar os dados
              _firstFuturePageSubscribe(scroollEndPage: true);
            }
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
            elevation: widget.searchAppBarelevation,
            iconTheme: widget.searchAppBariconTheme,
            backgroundColor: widget.searchAppBarbackgroundColor,
            searchBackgroundColor: widget.searchAppBarModeSearchBackgroundColor,
            iconConnectyOffAppBarColor:
                widget.searchAppBarIconConnectyOffAppBarColor,
            searchElementsColor: widget.searchAppBarElementsColor,
            hintText: widget.searchAppBarhintText,
            flattenOnSearch: widget.searchAppBarflattenOnSearch,
            capitalization: widget.searchAppBarcapitalization,
            actions: widget.searchAppBaractions,
            hideDefaultConnectyIconOffAppBar:
                widget.hideDefaultConnectyIconOffAppBar,
            iconConnectyOffAppBar: widget.iconConnectyOffAppBar,
            keyboardType: widget.searchAppBarKeyboardType,
            magnifyinGlassColor: widget.magnifyinGlassColor),
        body: buildBody(),
        floatingActionButton: widget.searchePageFloaActionButton,
        floatingActionButtonLocation:
            widget.searchePageFloatingActionButtonLocation,
        floatingActionButtonAnimator:
            widget.searchePageFloatingActionButtonAnimator,
        persistentFooterButtons: widget.searchePagePersistentFooterButtons,
        drawer: widget.searchePageDrawer,
        endDrawer: widget.searchePageEndDrawer,
        bottomNavigationBar: widget.searchePageBottomNavigationBar,
        bottomSheet: widget.searchePageBottomSheet,
        backgroundColor: widget.searchPageBackgroundColor,
        resizeToAvoidBottomPadding: widget.resizeToAvoidBottomPadding,
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

  Widget buildBody() {
    if (downConnectyWithoutData) {
      // Apenas anuncia quando nao tem a primeira data e esta sem conexao
      return _widgetConnecty;
    }

    return Obx(() {
      if (_controller.snapshotScroolPage.snapshot.connectionState ==
          ConnectionState.waiting) {
        return _widgetWaiting;
      }

      if (_controller.snapshotScroolPage.snapshot.hasError) {
        return buildwidgetError(_controller.snapshotScroolPage.snapshot.error);
      }

      if (_controller.snapshotScroolPage.snapshot.data.isEmpty) {
        return _widgetNothingFound;
      }
      return ListView.builder(
        controller: _scrollController,
        itemCount: (_controller.snapshotScroolPage.loadingSearchScroll ||
                _controller.snapshotScroolPage.loadinglistFullScroll)
            ? _controller.snapshotScroolPage.snapshot.data.length + 1
            : _controller.snapshotScroolPage.snapshot.data.length,
        itemBuilder: (ctx, index) {
          if (index == _controller.snapshotScroolPage.snapshot.data.length) {
            return _widgetEndScrollPage;
          }

          return widget.paginationItemBuilder(context, index,
              _controller.snapshotScroolPage.snapshot.data[index]);
        },
      );
    });
  }

  void _subscribreSearhQuery() {
    _worker = debounce(_controller.rxSearch, (String query) {
      if (query.isNotEmpty) {
        if (_controller.snapshotScroolPage.loadingSearchScroll) {
          _controller.togleLoadingSearchScroll(false);
        }
        _controller.oneMorePage = false;
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
        if (listBuilder.listSearch.length < _controller.numItemsPage) {
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
    _controller.compareSort = widget.compareSort;
    _controller.filtersType = widget.filtersType;
    _controller.onInitFilter();

    if (oldWidget.initialData != widget.initialData) {
      if (widget.initialData != null && widget.numItemsPage == null) {
        throw Exception(
            'Necessario passar o numero de itens por página para que '
            'possa calcular a pagina inicial');
      } else {
        _haveInitialData = widget.initialData != null;

        if (_haveInitialData) {
          if (downConnectyWithoutData) {
            downConnectyWithoutData = false;
            _unsubscribeConnecty();
          }
          if (widget.initialData.length > _controller.listFull.length) {
            _controller.page =
                (widget.initialData.length / widget.numItemsPage).ceil();

            _controller.listFull.clear();
            _controller.listFull.addAll(widget.initialData);
            _controller.sortCompareList(_controller.listFull);

            if (_controller.rxSearch.value.isEmpty) {
              _controller.withData(_controller.listFull);
            } else {
              _controller.oneMorePage = false;

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
    _unsubscribeConnecty();
    _worker?.dispose();
    super.dispose();
  }

  void _subscribeConnecty() {
    _subscriptionConnecty =
        _connectyController.connectStream.listen((bool isConnected) {
      if (!isConnected && (!_haveInitialData)) {
        setState(() {
          downConnectyWithoutData = true;
        });
      } else if (isConnected && (!_haveInitialData)) {
        _controller.waiting();
      }
    });
  }

  void _unsubscribeListFullCallBack() {
    _activeListFullCallbackIdentity = null;
  }

  void _unsubscribeSearhCallBack() {
    _activeListSearchCallbackIdentity = null;
  }

  void _unsubscribeConnecty() {
    if (_subscriptionConnecty != null) {
      _subscriptionConnecty.cancel();
      _subscriptionConnecty = null;
      _connectyController.onClose();
    }
  }

  void buildDeafultWidgets() {
    if (widget.widgetWaiting == null) {
      _widgetWaiting = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
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

  Widget buildwidgetError(Object error) {
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
      return widget.widgetErrorBuilder(error);
    }

    //return _widgetError;
  }
}

class SearchCallBack {
  final String query;

  SearchCallBack(this.query);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchCallBack && other.query == query;
  }

  @override
  int get hashCode => hashList([query]);
}

/*

class SearchAppBarPagination<T> extends StatefulWidget {
  /// Paramentros do SearchAppBar

  final Widget searchAppBartitle;
  final bool searchAppBarcenterTitle;
  final IconThemeData searchAppBariconTheme;
  final Color searchAppBarbackgroundColor;
  final Color searchAppBarModeSearchBackgroundColor;
  final Color searchAppBarElementsColor;

  /// [searchAppBarIconConnectyOffAppBarColor] You can change the color of
  /// [iconConnectyOffAppBar]. By default = Colors.redAccent.
  final Color searchAppBarIconConnectyOffAppBarColor;
  final String searchAppBarhintText;
  final bool searchAppBarflattenOnSearch;
  final TextCapitalization searchAppBarcapitalization;
  final List<Widget> searchAppBaractions;
  final double searchAppBarelevation;
  final TextInputType searchAppBarKeyboardType;

  /// [magnifyinGlassColor] Changes the color of the magnifying glass.
  /// Keeps IconTheme color by default.
  final Color magnifyinGlassColor;

  ///[iconConnectyOffAppBar] Appears when the connection status is off.
  ///There is already a default icon. If you don't want to present a choice
  ///[hideDefaultConnectyIconOffAppBar] = true; If you want to have a
  ///custom icon, do [hideDefaultConnectyIconOffAppBar] = true; and set the
  ///[iconConnectyOffAppBar]`.
  final bool hideDefaultConnectyIconOffAppBar;

  /// [iconConnectyOffAppBar] Displayed on the AppBar when the internet
  /// connection is switched off.
  /// It is always the closest to the center.
  final Widget iconConnectyOffAppBar;

  /// Parametros para o Scaffold

  ///  [widgetOffConnectyWaiting] Apenas mostra algo quando esta sem conexao
  ///  e ainda nao tem o primeiro valor da stream. Se a conexao voltar
  ///  passa a mostrar o [widgetWaiting] até apresentar o primeiro dado
  final Widget widgetWaiting;
  final Widget widgetOffConnectyWaiting;

  /// [widgetEndScrollPage] shown when the end of the page arrives and
  /// awaits the Future of the data on the next page
  final Widget widgetEndScrollPage;

  /// [widgetErrorBuilder] Widget built by the Object error returned by the
  /// [futureFetchPageItems] error.
  final WidgetsErrorBuilder widgetErrorBuilder;

  /// [widgetNothingFound] when searching for something you don't find data.
  final Widget widgetNothingFound;

  /// [searchePageFloaActionButton] , [searchePageFloaActionButton] ,
  /// [searchePageFloatingActionButtonLocation] ,
  /// [searchePageFloatingActionButtonAnimator]  ...
  /// ...
  /// are passed on to the Scaffold.
  final Widget searchePageFloaActionButton;
  final FloatingActionButtonLocation searchePageFloatingActionButtonLocation;
  final FloatingActionButtonAnimator searchePageFloatingActionButtonAnimator;
  final List<Widget> searchePagePersistentFooterButtons;
  final Widget searchePageDrawer;
  final Widget searchePageEndDrawer;
  final Widget searchePageBottomNavigationBar;
  final Widget searchePageBottomSheet;
  final Color searchPageBackgroundColor;
  final bool resizeToAvoidBottomPadding;
  final bool resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color drawerScrimColor;
  final double drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;

  /// [initialData] List to be filtered by Search.
  /// These widgets will not be displayed. [widgetOffConnectyWaiting] and
  /// [widgetWaiting]
  final List<T> initialData;

  ///[futureFetchPageItems] Return the list in parts or parts by query String
  ///filtered. We make the necessary changes on the device side to update the
  ///page to be requested. Eg: If numItemsPage = 6 and you receive 05 or 11
  ///or send empty, = >>> it means that the data is over.
  final FutureFetchPageItems<T> futureFetchPageItems;

  /// [numPageItems] Automatically calculated when receiving the first data.
  /// If it has [initialData] it cannot be null.
  final int numPageItems;

  /// [filtersType] These are the filters that the Controller uses to
  /// filter the list. Divide the filters into three types:
  /// startsWith, equals, contains. Default = FiltersTypes.contains;
  final FiltersTypes filtersType;

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
  final StringFilter<T> stringFilter;

  ///[compareSort] If you want your list to be sorted, pass the function on.
  /// Example: (Person a, Person b) => a.name.compareTo(b.name),
  /// This list will be ordered by the object name parameter.
  final Compare<T> compareSort;

  const SearchAppBarPagination({
    Key key,
    @required this.futureFetchPageItems,
    @required this.paginationItemBuilder,
    this.searchAppBartitle,
    this.searchAppBarcenterTitle = false,
    this.searchAppBariconTheme,
    this.searchAppBarbackgroundColor,
    this.searchAppBarModeSearchBackgroundColor,
    this.searchAppBarElementsColor,
    this.searchAppBarIconConnectyOffAppBarColor = Colors.redAccent,
    this.searchAppBarhintText,
    this.searchAppBarflattenOnSearch = false,
    this.searchAppBarcapitalization = TextCapitalization.none,
    this.searchAppBaractions = const <Widget>[],
    this.searchAppBarelevation = 4.0,
    this.hideDefaultConnectyIconOffAppBar = false,
    this.iconConnectyOffAppBar,
    this.searchAppBarKeyboardType,
    this.magnifyinGlassColor,
    this.widgetWaiting,
    this.widgetOffConnectyWaiting,
    this.widgetErrorBuilder,
    this.widgetNothingFound,
    this.searchePageFloaActionButton,
    this.searchePageFloatingActionButtonLocation,
    this.searchePageFloatingActionButtonAnimator,
    this.searchePagePersistentFooterButtons,
    this.searchePageDrawer,
    this.searchePageEndDrawer,
    this.searchePageBottomNavigationBar,
    this.searchePageBottomSheet,
    this.searchPageBackgroundColor,
    this.resizeToAvoidBottomPadding,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.initialData,
    this.filtersType,
    this.stringFilter,
    this.compareSort,
    this.numPageItems,
    this.widgetEndScrollPage,
  }) : super(key: key);

  @override
  _SearchAppBarPaginationState<T> createState() =>
      _SearchAppBarPaginationState<T>();
}

class _SearchAppBarPaginationState<T> extends State<SearchAppBarPagination<T>> {
  SearcherPagePaginationFutureController<T> _controller;

  //Future<List<T>> _future;

  @override
  void initState() {
    super.initState();

    if (widget.initialData != null && widget.numPageItems == null) {
      throw Exception('Necessario passar o numero de itens por página para que '
          'possa calcular a pagina inicial');
    }
    _controller = SearcherPagePaginationFutureController<T>(
        //listStream: widget._stream,
        stringFilter: widget.stringFilter,
        compareSort: widget.compareSort,
        filtersType: widget.filtersType)
      ..onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SearchAppBar(
            controller: _controller,
            title: widget.searchAppBartitle,
            centerTitle: widget.searchAppBarcenterTitle,
            elevation: widget.searchAppBarelevation,
            iconTheme: widget.searchAppBariconTheme,
            backgroundColor: widget.searchAppBarbackgroundColor,
            searchBackgroundColor: widget.searchAppBarModeSearchBackgroundColor,
            iconConnectyOffAppBarColor:
                widget.searchAppBarIconConnectyOffAppBarColor,
            searchElementsColor: widget.searchAppBarElementsColor,
            hintText: widget.searchAppBarhintText,
            flattenOnSearch: widget.searchAppBarflattenOnSearch,
            capitalization: widget.searchAppBarcapitalization,
            actions: widget.searchAppBaractions,
            hideDefaultConnectyIconOffAppBar:
                widget.hideDefaultConnectyIconOffAppBar,
            iconConnectyOffAppBar: widget.iconConnectyOffAppBar,
            keyboardType: widget.searchAppBarKeyboardType,
            magnifyinGlassColor: widget.magnifyinGlassColor),
        body: SearchAppBarPageFutureBuilder<T>(
          initialData: widget.initialData,
          futureFetchPageItems: widget.futureFetchPageItems,
          //futureInitialList: _future,
          numPageItems: widget.numPageItems,
          //searcher: _controller,
          paginationItemBuilder: widget.paginationItemBuilder,
         // widgetConnecty: widget.widgetOffConnectyWaiting,
          widgetErrorBuilder: widget.widgetErrorBuilder,
          widgetNothingFound: widget.widgetNothingFound,
          widgetWaiting: widget.widgetWaiting,
          widgetEndScrollPage: widget.widgetEndScrollPage,
        ),
        floatingActionButton: widget.searchePageFloaActionButton,
        floatingActionButtonLocation:
            widget.searchePageFloatingActionButtonLocation,
        floatingActionButtonAnimator:
            widget.searchePageFloatingActionButtonAnimator,
        persistentFooterButtons: widget.searchePagePersistentFooterButtons,
        drawer: widget.searchePageDrawer,
        endDrawer: widget.searchePageEndDrawer,
        bottomNavigationBar: widget.searchePageBottomNavigationBar,
        bottomSheet: widget.searchePageBottomSheet,
        backgroundColor: widget.searchPageBackgroundColor,
        resizeToAvoidBottomPadding: widget.resizeToAvoidBottomPadding,
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
}
*/
