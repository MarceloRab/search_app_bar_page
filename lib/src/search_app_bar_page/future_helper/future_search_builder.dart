import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_state_manager/get_state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/connecty_controller.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_page_pagination_future_controller.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/filters/functions_filters.dart';

//import 'package:rxdart/rxdart.dart';

class SearchAppBarPageFutureBuilder<T> extends StatefulWidget {
  final FutureFetchPageItems<T> futureFetchPageItems;

  //final Future<List<T>> futureInitialList;

  final AsyncWidgetBuilder<List<T>> builder;

  final List<T> initialData;

  final SearcherPagePaginationFutureController<T> searcher;

  final WidgetsPaginationItemBuilder<T> paginationItemBuilder;

  final Widget widgetConnecty;

  final int numPageItems;

  const SearchAppBarPageFutureBuilder({
    Key key,
    @required this.futureFetchPageItems,
    this.builder,
    this.initialData,
    this.searcher,
    this.paginationItemBuilder,
    this.widgetConnecty,
    this.numPageItems,
    //@required this.futureInitialList
  }) : super(key: key);

  @override
  _SearchAppBarPageFutureBuilderState createState() =>
      _SearchAppBarPageFutureBuilderState();
}

class _SearchAppBarPageFutureBuilderState<T>
    extends State<SearchAppBarPageFutureBuilder<T>> {
  Object _activeCallbackIdentity;
  AsyncSnapshot<List<T>> _snapshot;
  ConnectyController _connectyController;
  StreamSubscription _subscriptionConnecty;

  //StreamSubscription _subscriptionSearch;

  bool _haveInitialData;
  bool downConnectyWithoutData = false;

  Widget _widgetConnecty;

  ScrollController _scrollController;

  Worker _worker;

  //bool haveMore = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(pagesListener);

    if (widget.numPageItems != null) {
      widget.searcher.numPageItems = widget.numPageItems;
    }
    _haveInitialData = widget.initialData != null;
    _snapshot = AsyncSnapshot<List<T>>.withData(
        ConnectionState.none, widget.initialData);
    if (_haveInitialData) {
      widget.searcher.listFull.addAll(widget.initialData);
      widget.searcher.onSearchList(widget.initialData);
    } else {
      _connectyController = ConnectyController();
      _subscribeConnecty();
    }

    _subscribeSearhQuery();
    _firstFuturePageSubscribe();

    if (widget.widgetConnecty == null) {
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
      _widgetConnecty = widget.widgetConnecty;
    }
  }

  void _futureSearchPageQuery(String query) {
    if (_activeCallbackIdentity != null) {
      _unsubscribe();
      _snapshot = _snapshot.inState(ConnectionState.none);
      //widget.searcher.wrabListSearch(widget.initialData);
    }
    final Object callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;

    setState(() {
      _snapshot = _snapshot.inState(ConnectionState.waiting);
    });
    widget.futureFetchPageItems(widget.searcher.pageSearch, query).then((data) {
      if (_activeCallbackIdentity == callbackIdentity) {
        _snapshot = AsyncSnapshot<List<T>>.withData(ConnectionState.done, data);
        widget.searcher.listSearchFilter.assignAll(data);

      }
    }, onError: (Object error) {
      if (_activeCallbackIdentity == callbackIdentity) {
        setState(() {
          _snapshot =
              AsyncSnapshot<List<T>>.withError(ConnectionState.done, error);
        });
      }
    });
  }

  void _firstFuturePageSubscribe() {
    final Object callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;
    widget.futureFetchPageItems(widget.searcher.page, '').then<void>(
        (List<T> data) {
      //widget.futureInitialList.then<void>((List<T> data) {
      if (widget.searcher.numPageItems == 0) {
        widget.searcher.numPageItems = data.length;
      }

      if (_activeCallbackIdentity == callbackIdentity) {
        downConnectyWithoutData = false;
        _unsubscribeConnecty();

        widget.searcher.wrabListSearch(data);
        setState(() {
          _snapshot =
              AsyncSnapshot<List<T>>.withData(ConnectionState.done, data);
        });
      }
    }, onError: (Object error) {
      if (_activeCallbackIdentity == callbackIdentity) {
        setState(() {
          _snapshot =
              AsyncSnapshot<List<T>>.withError(ConnectionState.done, error);
        });
      }
    });
    _snapshot = _snapshot.inState(ConnectionState.waiting);
  }

  void pagesListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 3) {
      //_paginationBloc.event.add(null);

      if (_activeCallbackIdentity != null) {
        if (widget.searcher.rxSearch.value.isNotEmpty) {
          widget
              .futureFetchPageItems(
                  widget.searcher.pageSearch, widget.searcher.rxSearch.value)
              .then((data) {
            widget.searcher.pageSearch++;
            widget.searcher.listSearchFilter.addAll(data);
            //widget.searcher.onSearchList(widget.searcher.listFull);
          });
        } else {
          widget.futureFetchPageItems(widget.searcher.page, '').then((data) {
            widget.searcher.page++;
            widget.searcher.listFull.addAll(data);
            widget.searcher.onSearchList(widget.searcher.listFull);
          });
        }
      }
    }
  }

  @override
  void didUpdateWidget(SearchAppBarPageFutureBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.futureFetchPageItems != widget.futureFetchPageItems) {
      if (_activeCallbackIdentity != null) {
        _unsubscribe();
        _snapshot = _snapshot.inState(ConnectionState.none);
        //widget.searcher.wrabListSearch(widget.initialData);
      }
      _firstFuturePageSubscribe();
    }

    if (oldWidget.initialData != widget.initialData) {
      _haveInitialData = widget.initialData != null;

      if (_haveInitialData) {
        downConnectyWithoutData = false;
        _unsubscribeConnecty();
        _snapshot = AsyncSnapshot<List<T>>.withData(
            ConnectionState.done, widget.initialData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (downConnectyWithoutData) {
      // Apenas anuncia quando nao tem a primeira data e esta sem conexao
      return _widgetConnecty;
    }

    if (_snapshot.connectionState == ConnectionState.waiting ||
        _snapshot.hasError) {


      return widget.builder(context, _snapshot);
    }
    //if (_snapshot.hasData) {
    //widget.searcher.haveInitialData = true;

    /// Para mostrar o botao de procurar no app bar a partir dai
    /// no método _buildAppBar - class SearchAppBar
    return Obx(() {
      return ListView.builder(
        controller: _scrollController,
        itemCount: widget.searcher.rxSearch.value.isEmpty
            ? widget.searcher.listSearch.length
            : widget.searcher.listSearchFilter.length,
        itemBuilder: (ctx, index) {
          return widget.paginationItemBuilder(context, index);
        },
      );
    });

    //return widget.builder(context, _snapshot);
  }



  void _subscribeSearhQuery() {
    _worker = debounce(widget.searcher.rxSearch, (String query) {
      if (query.isNotEmpty)
        _futureSearchPageQuery(query);
      else {
        widget.searcher.wrabListSearch(widget.searcher.listFull);
      }

    }, time: const Duration(milliseconds: 350));

    /*_subscriptionSearch = widget.searcher.rxSearch.stream
        .distinct()
        .debounceTime(const Duration(milliseconds: 350))
        .listen((query) {});*/
  }

  @override
  void dispose() {
    _unsubscribe();
    widget.searcher.onClose();
    _scrollController.removeListener(pagesListener);
    _scrollController.dispose();
    _unsubscribeConnecty();
    //_unsubscribeSearhQuery();
    _worker?.dispose();
    super.dispose();
  }

  void _subscribeConnecty() {
    _subscriptionConnecty =
        _connectyController.connectyStream.listen((bool isConnected) {
      if (!isConnected && (!_haveInitialData)) {
        //lançar _widgetConnecty
        setState(() {
          downConnectyWithoutData = true;
        });
      } else if (isConnected && (!_haveInitialData)) {
        setState(() {
          downConnectyWithoutData = false;
          _snapshot = _snapshot.inState(ConnectionState.waiting);
        });
      }
    });
  }

  void _unsubscribe() {
    _activeCallbackIdentity = null;
  }

  void _unsubscribeConnecty() {
    if (_subscriptionConnecty != null) {
      _subscriptionConnecty.cancel();
      _subscriptionConnecty = null;
      _connectyController.onClose();
    }
  }

/* void _unsubscribeSearhQuery() {
    if (_subscriptionSearch != null) {
      _subscriptionSearch.cancel();
      _subscriptionSearch = null;
    }
  }*/
}
