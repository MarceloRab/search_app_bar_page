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

  //final AsyncWidgetBuilder<List<T>> builder;

  final List<T> initialData;

  final SearcherPagePaginationFutureController<T> searcher;

  final WidgetsPaginationItemBuilder<T> paginationItemBuilder;

  final Widget widgetConnecty;

  final int numPageItems;

  final Widget widgetError;
  final Widget widgetWaiting;

  const SearchAppBarPageFutureBuilder({
    Key key,
    @required this.futureFetchPageItems,
    //this.builder,
    this.initialData,
    this.searcher,
    this.paginationItemBuilder,
    this.widgetConnecty,
    this.numPageItems,
    this.widgetError,
    this.widgetWaiting,
    //@required this.futureInitialList
  }) : super(key: key);

  @override
  _SearchAppBarPageFutureBuilderState<T> createState() =>
      _SearchAppBarPageFutureBuilderState<T>();
}

class _SearchAppBarPageFutureBuilderState<T>
    extends State<SearchAppBarPageFutureBuilder<T>> {
  Object _activeCallbackIdentity;

  //AsyncSnapshot<List<T>> _snapshot;
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
    //_snapshot = AsyncSnapshot<List<T>>.withData(
    // ConnectionState.none, widget.initialData);

    if (_haveInitialData) {
      // widget.searcher.snapshot =
      //widget.searcher.snapshot.inState(ConnectionState.none);

      widget.searcher.listFull.addAll(widget.initialData);
      widget.searcher.snapshotScroolPage = AsyncSnapshotScrollPage<T>(
          snapshot: AsyncSnapshot<List<T>>.withData(
              ConnectionState.none, widget.initialData));
      /* widget.searcher.snapshot = AsyncSnapshot<List<T>>.withData(
          ConnectionState.none, widget.initialData);*/

      widget.searcher.onSearchList(widget.initialData);
    } else {
      _connectyController = ConnectyController();
      _subscribeConnecty();
    }

    _subscribreSearhQuery();
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

  void _futureSearchPageQuery(String query, {bool scroollEndPage = false}) {
    if (_activeCallbackIdentity != null) {
      _unsubscribe();

      widget.searcher.snapshotScroolPage = widget.searcher.snapshotScroolPage
          .copyWith(
              snapshot: widget.searcher.snapshotScroolPage.snapshot
                  .inState(ConnectionState.none));

      //widget.searcher.snapshotScroolPage = AsyncSnapshotScrollPage<T>(
      //snapshot: widget.searcher.snapshotScroolPage.snapshot
      //.inState(ConnectionState.none));
    }
    final Object callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;
    if (!scroollEndPage) {
      widget.searcher.snapshotScroolPage = widget.searcher.snapshotScroolPage
          .copyWith(
              snapshot: widget.searcher.snapshotScroolPage.snapshot
                  .inState(ConnectionState.waiting));
    }

    widget.futureFetchPageItems(widget.searcher.pageSearch, query).then((data) {
      if (_activeCallbackIdentity == callbackIdentity) {
        if (!scroollEndPage) {
          widget.searcher.listFullSearchQuery.clear();
        }
        //widget.searcher.endSearchPage = false;

        widget.searcher.listFullSearchQuery.addAll(data);
        widget.searcher.snapshotScroolPage = widget.searcher.snapshotScroolPage
            .copyWith(
                snapshot: AsyncSnapshot<List<T>>.withData(
                    ConnectionState.done, widget.searcher.listFullSearchQuery),
                endSearchPage: false);

        //widget.searcher.snapshot = AsyncSnapshot<List<T>>.withData(
        //ConnectionState.done, widget.searcher.listFullSearchQuery);
      } else {
        if (widget.searcher.pageSearch > 0) {
          widget.searcher.pageSearch--;
          // ignore: invariant_booleans
          if (widget.searcher.pageSearch == 0) {
            widget.searcher.pageSearch = 1;
          }
        }
      }
    }, onError: (Object error) {
      if (_activeCallbackIdentity == callbackIdentity) {
        widget.searcher.snapshotScroolPage = AsyncSnapshotScrollPage<T>(
            snapshot:
                AsyncSnapshot<List<T>>.withError(ConnectionState.done, error));

        //widget.searcher.snapshot =
        // AsyncSnapshot<List<T>>.withError(ConnectionState.done, error);
        /*setState(() {
          _snapshot =
              AsyncSnapshot<List<T>>.withError(ConnectionState.done, error);
        });*/
      }
    });
  }

  void _firstFuturePageSubscribe({bool scroollEndPage = false}) {
    final Object callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;

    widget.futureFetchPageItems(widget.searcher.page, '').then<void>(
        (List<T> data) {
      //widget.futureInitialList.then<void>((List<T> data) {
      if (widget.searcher.numPageItems == 0) {
        widget.searcher.numPageItems = data.length;
      }

      if (_activeCallbackIdentity == callbackIdentity) {
        if (scroollEndPage) {
          if (data.isEmpty) {
            widget.searcher.snapshotScroolPage = widget
                .searcher.snapshotScroolPage
                .copyWith(endPage: false, finishPage: true);
          }
        }

        if (downConnectyWithoutData) {
          downConnectyWithoutData = false;
          _unsubscribeConnecty();
        }

        //widget.searcher.endPage = false;
        widget.searcher.wrabListSearch(data);

        widget.searcher.snapshotScroolPage = widget.searcher.snapshotScroolPage
            .copyWith(
                snapshot: AsyncSnapshot<List<T>>.withData(
                    ConnectionState.done, widget.searcher.listFull),
                endPage: false);

        //widget.searcher.snapshot = AsyncSnapshot<List<T>>.withData(
        // ConnectionState.done, widget.searcher.listFull);

      } else {
        if (widget.searcher.page > 0) {
          widget.searcher.page--;
          // ignore: invariant_booleans
          if (widget.searcher.page == 0) {
            widget.searcher.page = 1;
          }
        }
      }
    }, onError: (Object error) {
      if (_activeCallbackIdentity == callbackIdentity) {
        widget.searcher.snapshotScroolPage = AsyncSnapshotScrollPage<T>(
            snapshot:
                AsyncSnapshot<List<T>>.withError(ConnectionState.done, error));
        //widget.searcher.snapshot =
        // AsyncSnapshot<List<T>>.withError(ConnectionState.done, error);
        /*setState(() {
          _snapshot =
              AsyncSnapshot<List<T>>.withError(ConnectionState.done, error);
        });*/
      }
    });

    if (!scroollEndPage) {
      widget.searcher.snapshotScroolPage = widget.searcher.snapshotScroolPage
          .copyWith(
              snapshot: widget.searcher.snapshotScroolPage.snapshot
                  .inState(ConnectionState.waiting));
    }

    //widget.searcher.snapshot =
    // widget.searcher.snapshot.inState(ConnectionState.waiting);
    //_snapshot = _snapshot.inState(ConnectionState.waiting);
  }

  void pagesListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 3) {
      //_paginationBloc.event.add(null);

      if (_activeCallbackIdentity != null) {
        if (widget.searcher.rxSearch.value.isNotEmpty) {
          if (widget.searcher.listFullSearchQuery.length ~/
                  widget.searcher.numPageItems !=
              0) {
            //widget.searcher.endSearchPage = false;
            //widget.searcher.pageSearchFinish = true;
            widget.searcher.snapshotScroolPage = widget
                .searcher.snapshotScroolPage
                .copyWith(endSearchPage: false, finishSearchPage: true);
          } else {
            widget.searcher.snapshotScroolPage = widget
                .searcher.snapshotScroolPage
                .copyWith(endSearchPage: true);
            // widget.searcher.endSearchPage = true;
            widget.searcher.pageSearch++;
            _futureSearchPageQuery(widget.searcher.rxSearch.value,
                scroollEndPage: true);
          }
        } else {
          final inteiro =
              widget.searcher.listFull.length ~/ widget.searcher.numPageItems !=
                  0;

          if (!inteiro && !widget.searcher.snapshotScroolPage.finishPage) {
            //widget.searcher.endPage = false;
            //widget.searcher.pageFinish = true;

            widget.searcher.snapshotScroolPage = widget
                .searcher.snapshotScroolPage
                .copyWith(endPage: false, finishPage: true);
          } else if (!widget.searcher.snapshotScroolPage.finishPage) {
            if (_activeCallbackIdentity != null) {
              _unsubscribe();

              widget.searcher.snapshotScroolPage.snapshot = widget
                  .searcher.snapshotScroolPage.snapshot
                  .inState(ConnectionState.none);
              //widget.searcher.snapshot =
              // widget.searcher.snapshot.inState(ConnectionState.none);
            }
            //widget.searcher.endPage = true;
            widget.searcher.snapshotScroolPage =
                widget.searcher.snapshotScroolPage.copyWith(endPage: true);
            widget.searcher.page++;
            _firstFuturePageSubscribe(scroollEndPage: true);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (downConnectyWithoutData) {
      // Apenas anuncia quando nao tem a primeira data e esta sem conexao
      return _widgetConnecty;
    }

    return Obx(() {
      print(widget.searcher.snapshotScroolPage.snapshot.connectionState
          .toString());
      if (widget.searcher.snapshotScroolPage.snapshot.connectionState ==
          ConnectionState.waiting) {
        if (widget.widgetWaiting == null)
          return Center(
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
        else
          return widget.widgetWaiting;
      }

      if (widget.searcher.snapshotScroolPage.snapshot.hasError) {
        if (widget.widgetError == null)
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
                      'Temos um erro: '
                      '${widget.searcher.snapshotScroolPage.snapshot.error}',
                    ),
                  ),
                )
              ]);
        else
          return widget.widgetError;
      }

      //final isListFull = widget.searcher.rxSearch.value.isEmpty;
      return ListView.builder(
        controller: _scrollController,
        itemCount: ((widget.searcher.snapshotScroolPage.endPage &&
                    !widget.searcher.snapshotScroolPage.finishPage) ||
                (widget.searcher.snapshotScroolPage.endSearchPage &&
                    !widget.searcher.snapshotScroolPage.finishPage))
            ? widget.searcher.snapshotScroolPage.snapshot.data.length + 1
            : widget.searcher.snapshotScroolPage.snapshot.data.length,
        itemBuilder: (ctx, index) {
          if (index ==
              widget.searcher.snapshotScroolPage.snapshot.data.length) {
            return const Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            );
          }
          return widget.paginationItemBuilder(context, index,
              widget.searcher.snapshotScroolPage.snapshot.data[index]);
        },
      );
    });

    //return widget.builder(context, _snapshot);
  }

  void _subscribreSearhQuery() {
    _worker = debounce(widget.searcher.rxSearch, (String query) {
      if (query.isNotEmpty) {
        widget.searcher.pageSearch = 1;
        //widget.searcher.pageSearchFinish = false;
        widget.searcher.snapshotScroolPage =
            widget.searcher.snapshotScroolPage.copyWith(finishSearchPage: true);

        final list = widget.searcher.haveSearchQueryPage(query);

        if (list.isNotEmpty) {
          widget.searcher.listFullSearchQuery.clear();
          widget.searcher.listFullSearchQuery.addAll(list);

          widget.searcher.snapshotScroolPage = AsyncSnapshotScrollPage<T>(
              snapshot: AsyncSnapshot<List<T>>.withData(
                  ConnectionState.done, widget.searcher.listFullSearchQuery));
          // widget.searcher.snapshot = AsyncSnapshot<List<T>>.withData(
          // ConnectionState.done, widget.searcher.listFullSearchQuery);
        } else {
          _futureSearchPageQuery(query);
        }
      } else {
        widget.searcher.snapshotScroolPage = AsyncSnapshotScrollPage<T>(
            snapshot: AsyncSnapshot<List<T>>.withData(
                ConnectionState.done, widget.searcher.listFull));
        // widget.searcher.snapshot = AsyncSnapshot<List<T>>.withData(
        //ConnectionState.done, widget.searcher.listFull);
      }
    }, time: const Duration(milliseconds: 350));

    /*_subscriptionSearch = widget.searcher.rxSearch.stream
        .distinct()
        .debounceTime(const Duration(milliseconds: 350))
        .listen((query) {});*/
  }

  @override
  void didUpdateWidget(SearchAppBarPageFutureBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.futureFetchPageItems != widget.futureFetchPageItems) {
      widget.searcher.listFull.clear();
      if (oldWidget.initialData != widget.initialData) {
        _haveInitialData = widget.initialData != null;

        if (_haveInitialData) {
          widget.searcher.listFull.addAll(widget.initialData);
        }
      }
      if (_activeCallbackIdentity != null) {
        _unsubscribe();
        //_snapshot = _snapshot.inState(ConnectionState.none);
        //widget.searcher.wrabListSearch(widget.initialData);

        widget.searcher.snapshotScroolPage.snapshot = widget
            .searcher.snapshotScroolPage.snapshot
            .inState(ConnectionState.none);
        //widget.searcher.snapshot =
        // widget.searcher.snapshot.inState(ConnectionState.none);
      }

      //widget.searcher.snapshotScroolPage =
      // widget.searcher.snapshotScroolPage.copyWith(finishPage: false);
      //widget.searcher.pageFinish = false;
      _firstFuturePageSubscribe();
    }
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
        widget.searcher.snapshotScroolPage = widget.searcher.snapshotScroolPage
            .copyWith(
                snapshot: widget.searcher.snapshotScroolPage.snapshot
                    .inState(ConnectionState.waiting));

        // widget.searcher.snapshot =
        //  widget.searcher.snapshot.inState(ConnectionState.waiting);

        /* setState(() {
          downConnectyWithoutData = false;
          _snapshot = _snapshot.inState(ConnectionState.waiting);
        });*/
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
