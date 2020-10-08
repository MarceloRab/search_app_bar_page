import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final Widget widgetNothingFound;
  final Widget widgetEndScrollPage;

  const SearchAppBarPageFutureBuilder({
    Key key,
    @required this.futureFetchPageItems,
    @required this.paginationItemBuilder,
    //this.builder,
    this.initialData,
    this.searcher,
    this.widgetConnecty,
    this.numPageItems,
    this.widgetError,
    this.widgetWaiting,
    this.widgetNothingFound,
    this.widgetEndScrollPage,
    //@required this.futureInitialList
  }) : super(key: key);

  @override
  _SearchAppBarPageFutureBuilderState<T> createState() =>
      _SearchAppBarPageFutureBuilderState<T>();
}

class _SearchAppBarPageFutureBuilderState<T>
    extends State<SearchAppBarPageFutureBuilder<T>> {
  Object _activeListFullCallbackIdentity;
  Object _activeListSearchCallbackIdentity;

  //AsyncSnapshot<List<T>> _snapshot;
  ConnectyController _connectyController;
  StreamSubscription _subscriptionConnecty;

  //StreamSubscription _subscriptionSearch;

  bool _haveInitialData;
  bool downConnectyWithoutData = false;

  Widget _widgetConnecty;

  ScrollController _scrollController;

  Worker _worker;

  Widget _widgetWaiting;
  Widget _widgetError;
  Widget _widgetNothingFound;
  Widget _widgetEndScrollPage;

  bool _oneMorePage = false;

  @override
  void initState() {
    super.initState();
    //_controller = widget.searcher;

    _scrollController = ScrollController();
    _scrollController.addListener(pagesListener);

    if (widget.numPageItems != null) {
      widget.searcher.numPageItems = widget.numPageItems;
    }
    _haveInitialData = widget.initialData != null;
    //_snapshot = AsyncSnapshot<List<T>>.withData(
    // ConnectionState.none, widget.initialData);

    if (_haveInitialData) {
      if (widget.searcher.numPageItems != 0) {
        widget.searcher.page =
            (widget.initialData.length / widget.numPageItems).ceil();
      }

      widget.searcher.listFull.addAll(widget.initialData);
      widget.searcher.sortCompareList(widget.searcher.listFull);

      widget.searcher.snapshotScroolPage = AsyncSnapshotScrollPage<T>(
          snapshot: AsyncSnapshot<List<T>>.withData(
              ConnectionState.none, widget.initialData));
      /* widget.searcher.snapshot = AsyncSnapshot<List<T>>.withData(
          ConnectionState.none, widget.initialData);*/

      //widget.searcher.onSearchList(widget.initialData);
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

    buildDeafultWidgets();
  }

  void _firstFuturePageSubscribe({bool scroollEndPage = false}) {
    final Object callbackIdentity = Object();
    _activeListFullCallbackIdentity = callbackIdentity;

    widget.futureFetchPageItems(widget.searcher.page, '').then<void>(
        (List<T> data) {
      //widget.futureInitialList.then<void>((List<T> data) {
      if (widget.searcher.numPageItems == 0) {
        widget.searcher.numPageItems = data.length;
      }

      if (_activeListFullCallbackIdentity == callbackIdentity) {
        if (downConnectyWithoutData) {
          downConnectyWithoutData = false;
          _unsubscribeConnecty();
        }
        // Encerroou dados da API
        if (data.isEmpty) {
          widget.searcher.finishPage = true;
          widget.searcher.snapshotScroolPage = widget
              .searcher.snapshotScroolPage
              .copyWith(loadinglistFullScroll: false);
          return;
        }

        // Ultima pagina
        if (data.length - widget.searcher.numPageItems < 0) {
          widget.searcher.wrabListSearch(data);

          widget.searcher.finishPage = true;
          widget.searcher.snapshotScroolPage =
              widget.searcher.snapshotScroolPage.copyWith(
                  snapshot: AsyncSnapshot<List<T>>.withData(
                      ConnectionState.done, widget.searcher.listFull),
                  loadinglistFullScroll: false);
          return;
        }

        widget.searcher.wrabListSearch(data);

        widget.searcher.snapshotScroolPage = widget.searcher.snapshotScroolPage
            .copyWith(
                snapshot: AsyncSnapshot<List<T>>.withData(
                    ConnectionState.done, widget.searcher.listFull),
                loadinglistFullScroll: false);
      }
    }, onError: (Object error) {
      if (_activeListFullCallbackIdentity == callbackIdentity) {
        refazFutureListFull();

        widget.searcher.snapshotScroolPage = widget.searcher.snapshotScroolPage
            .copyWith(
                snapshot: AsyncSnapshot<List<T>>.withError(
                    ConnectionState.done, error),
                loadinglistFullScroll: false);
      }
    });

    if (!scroollEndPage) {
      widget.searcher.snapshotScroolPage = widget.searcher.snapshotScroolPage
          .copyWith(
              snapshot: widget.searcher.snapshotScroolPage.snapshot
                  .inState(ConnectionState.waiting),
              loadinglistFullScroll: false);
    }
  }

  void _futureSearchPageQuery(String query, {bool scroollEndPage = false}) {
    if (_activeListSearchCallbackIdentity != null) {
      _unsubscribeSearhCallBack();

      widget.searcher.snapshotScroolPage = widget.searcher.snapshotScroolPage
          .copyWith(
              snapshot: widget.searcher.snapshotScroolPage.snapshot
                  .inState(ConnectionState.none));

      //widget.searcher.snapshotScroolPage = AsyncSnapshotScrollPage<T>(
      //snapshot: widget.searcher.snapshotScroolPage.snapshot
      //.inState(ConnectionState.none));
    }
    final Object callbackIdentity = Object();
    _activeListSearchCallbackIdentity = callbackIdentity;
    if (!scroollEndPage) {
      widget.searcher.snapshotScroolPage = widget.searcher.snapshotScroolPage
          .copyWith(
              snapshot: widget.searcher.snapshotScroolPage.snapshot
                  .inState(ConnectionState.waiting));
    }

    widget.futureFetchPageItems(widget.searcher.pageSearch, query).then((data) {
      if (_activeListSearchCallbackIdentity == callbackIdentity) {
        // Recebeu lista vazia - encerrou
        if (data.isEmpty) {
          _oneMorePage = false;

          widget.searcher.mapsSearch[widget.searcher.rxSearch.value]
              .isListSearchFull = true;
          widget.searcher.snapshotScroolPage =
              widget.searcher.snapshotScroolPage.copyWith(
                  snapshot: AsyncSnapshot<List<T>>.withData(
                      ConnectionState.done,
                      widget.searcher.mapsSearch[widget.searcher.rxSearch.value]
                          .listSearch),
                  loadingSearchScroll: false);

          return;
        }

        if (data.length - widget.searcher.numPageItems < 0) {
          _oneMorePage = false;

          /*print('searche.page => ${widget.searcher.pageSearch.toString()}');
          print('listSearch.query => '
              '${widget.searcher.mapsSearch[widget.searcher.rxSearch.value]
              .listSearch.length.toString()}');*/

          /* final num =
              (widget.searcher.pageSearch - 1) * widget.searcher.numPageItems;
          widget.searcher.mapsSearch[widget.searcher.rxSearch.value].listSearch
              .removeRange(
              num,
              widget.searcher.mapsSearch[widget.searcher.rxSearch.value]
                  .listSearch.length);
          widget.searcher.mapsSearch[widget.searcher.rxSearch.value].listSearch
              .addAll(data);*/

          widget.searcher.mapsSearch[widget.searcher.rxSearch.value]
              .isListSearchFull = true;

          widget.searcher.snapshotScroolPage =
              widget.searcher.snapshotScroolPage.copyWith(
                  snapshot: AsyncSnapshot<List<T>>.withData(
                      ConnectionState.done,
                      widget.searcher.mapsSearch[widget.searcher.rxSearch.value]
                          .listSearch),
                  //endSearchPage: false,
                  //finishSearchPage: true,
                  loadingSearchScroll: false);
          return;
        }

        /*print('searche.page => ${widget.searcher.pageSearch.toString()}');
        print('listSearch.query => '
            '${widget.searcher.mapsSearch[widget.searcher.rxSearch.value]
            .listSearch.length.toString()}');*/
        final num =
            (widget.searcher.pageSearch - 1) * widget.searcher.numPageItems;

        widget.searcher.mapsSearch[widget.searcher.rxSearch.value].listSearch
            .removeRange(
                num,
                widget.searcher.mapsSearch[widget.searcher.rxSearch.value]
                    .listSearch.length);
        widget.searcher.mapsSearch[widget.searcher.rxSearch.value].listSearch
            .addAll(data);

        if (_oneMorePage) {
          _oneMorePage = false;
          widget.searcher.pageSearch++;
          _futureSearchPageQuery(widget.searcher.rxSearch.value,
              scroollEndPage: true);
        } else {
          widget.searcher.snapshotScroolPage =
              widget.searcher.snapshotScroolPage.copyWith(
                  snapshot: AsyncSnapshot<List<T>>.withData(
                      ConnectionState.done,
                      widget.searcher.mapsSearch[widget.searcher.rxSearch.value]
                          .listSearch),
                  loadingSearchScroll: false);
        }
      } else {
        refazFutureSearchQuery();
      }
    }, onError: (Object error) {
      if (_activeListSearchCallbackIdentity == callbackIdentity) {
        refazFutureSearchQuery();

        widget.searcher.snapshotScroolPage = widget.searcher.snapshotScroolPage
            .copyWith(
                snapshot: AsyncSnapshot<List<T>>.withError(
                    ConnectionState.done, error),
                loadingSearchScroll: false);
      }
    });
  }

  void pagesListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 3 &&
        _scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
      if (_activeListFullCallbackIdentity != null) {
        if (widget.searcher.rxSearch.value.isNotEmpty) {
          if (!widget.searcher.mapsSearch[widget.searcher.rxSearch.value]
              .isListSearchFull) {
            if (!widget.searcher.snapshotScroolPage.loadingSearchScroll) {
              final listBuilder = widget.searcher
                  .haveSearchQueryPage(widget.searcher.rxSearch.value);

              if (listBuilder.isListSearchFull) {
                widget.searcher.snapshotScroolPage =
                    widget.searcher.snapshotScroolPage.copyWith(
                        snapshot: AsyncSnapshot<List<T>>.withData(
                            ConnectionState.done, listBuilder.listSearch),
                        loadingSearchScroll: false);
              } else {
                debugPrint('listFullSearchQuery '
                    // ignore: lines_longer_than_80_chars
                    '${listBuilder.listSearch.toString()}');

                widget.searcher.snapshotScroolPage = widget
                    .searcher.snapshotScroolPage
                    .copyWith(loadingSearchScroll: true);

                if (listBuilder.listSearch.length -
                        (widget.searcher.pageSearch *
                            widget.searcher.numPageItems) ==
                    0) {
                  widget.searcher.pageSearch++;
                } else {
                  _oneMorePage = true;
                }

                _futureSearchPageQuery(widget.searcher.rxSearch.value,
                    scroollEndPage: true);
              }
            }
          }
        } else {
          if (!widget.searcher.finishPage) {
            if (!widget.searcher.snapshotScroolPage.loadinglistFullScroll) {
              widget.searcher.snapshotScroolPage = widget
                  .searcher.snapshotScroolPage
                  .copyWith(loadinglistFullScroll: true);

              if (_activeListFullCallbackIdentity != null) {
                _unsubscribeListFullCallBack();

                widget.searcher.snapshotScroolPage =
                    widget.searcher.snapshotScroolPage.copyWith(
                        snapshot: widget.searcher.snapshotScroolPage.snapshot
                            .inState(ConnectionState.none));
              }

              widget.searcher.page++;
              /*print(
                  ' TESTE PAGE LISTFULL ANTES API --- '
                      '-${widget.searcher.page.toString()}-  ');*/
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
    if (downConnectyWithoutData) {
      // Apenas anuncia quando nao tem a primeira data e esta sem conexao
      return _widgetConnecty;
    }

    return Obx(() {
      //print(widget.searcher.snapshotScroolPage.snapshot.connectionState
      //.toString());
      if (widget.searcher.snapshotScroolPage.snapshot.connectionState ==
          ConnectionState.waiting) {
        return _widgetWaiting;
      }

      if (widget.searcher.snapshotScroolPage.snapshot.hasError) {
        return _widgetError;
      }

      if (widget.searcher.snapshotScroolPage.snapshot.data.isEmpty) {
        return _widgetNothingFound;
      }
      //final isListFull = widget.searcher.rxSearch.value.isEmpty;
      return ListView.builder(
        controller: _scrollController,
        itemCount: (widget.searcher.snapshotScroolPage.loadingSearchScroll ||
                widget.searcher.snapshotScroolPage.loadinglistFullScroll)
            ? widget.searcher.snapshotScroolPage.snapshot.data.length + 1
            : widget.searcher.snapshotScroolPage.snapshot.data.length,
        itemBuilder: (ctx, index) {
          if (index ==
              widget.searcher.snapshotScroolPage.snapshot.data.length) {
            return _widgetEndScrollPage;
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
        final listBuilder = widget.searcher.haveSearchQueryPage(query);

        if (listBuilder.listSearch.isNotEmpty) {
          //if (!listSearchBuild.isListSearchFull) {
          if (listBuilder.isListSearchFull) {
            widget.searcher.snapshotScroolPage =
                widget.searcher.snapshotScroolPage.copyWith(
                    snapshot: AsyncSnapshot<List<T>>.withData(
                        // ConnectionState.done, listSearchBuild.listSearch));
                        ConnectionState.done,
                        listBuilder.listSearch));
          } else {
            if (listBuilder.listSearch.length < widget.searcher.numPageItems) {
              _futureSearchPageQuery(query);
            } else {
              widget.searcher.snapshotScroolPage =
                  widget.searcher.snapshotScroolPage.copyWith(
                      snapshot: AsyncSnapshot<List<T>>.withData(
                          ConnectionState.done, listBuilder.listSearch));
            }

            /*if (widget.searcher.progide) {

            } else {
              //quando volta se continuar sem uma pagina pede mais
              if (listBuilder.listSearch.length <
                  widget.searcher.numPageItems) {
                _futureSearchPageQuery(query);
              } else
                widget.searcher.snapshotScroolPage =
                    widget.searcher.snapshotScroolPage.copyWith(
                        snapshot: AsyncSnapshot<List<T>>.withData(
                            ConnectionState.done, listBuilder.listSearch));
            }*/
          }

          /*widget.searcher.snapshotScroolPage = AsyncSnapshotScrollPage<T>(
              snapshot: AsyncSnapshot<List<T>>.withData(
                  ConnectionState.done, widget.searcher.listFullSearchQuery));*/
        } else if (listBuilder.listSearch.isEmpty &&
            listBuilder.isListSearchFull) {
          //widget.searcher.listFullSearchQuery.clear();
          widget.searcher.snapshotScroolPage =
              widget.searcher.snapshotScroolPage.copyWith(
                  snapshot: AsyncSnapshot<List<T>>.withData(
                      ConnectionState.done, listBuilder.listSearch));
        } else {
          _futureSearchPageQuery(query);
        }
      } else {
        //widget.searcher.restartQuery();
        widget.searcher.snapshotScroolPage = widget.searcher.snapshotScroolPage
            .copyWith(
                snapshot: AsyncSnapshot<List<T>>.withData(
                    ConnectionState.done, widget.searcher.listFull));
      }
    }, time: const Duration(milliseconds: 350));

    /*_subscriptionSearch = widget.searcher.rxSearch.stream
        .distinct()
        .debounceTime(const Duration(milliseconds: 350))
        .listen((query) {});*/
  }

  @override
  void didUpdateWidget(covariant SearchAppBarPageFutureBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialData != widget.initialData) {
      if (widget.initialData != null && widget.numPageItems == null) {
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
          if (widget.initialData.length > widget.searcher.listFull.length) {
            widget.searcher.page =
                (widget.initialData.length / widget.numPageItems).ceil();

            widget.searcher.listFull.clear();
            widget.searcher.listFull.addAll(widget.initialData);
            widget.searcher.sortCompareList(widget.searcher.listFull);

            if (widget.searcher.rxSearch.value.isEmpty) {
              widget.searcher.snapshotScroolPage = AsyncSnapshotScrollPage<T>(
                  snapshot: AsyncSnapshot<List<T>>.withData(
                      ConnectionState.none, widget.searcher.listFull));
            } else {
              final listBuilder = widget.searcher.haveSearchQueryPage(
                  widget.searcher.rxSearch.value,
                  restart: true);

              widget.searcher.snapshotScroolPage =
                  widget.searcher.snapshotScroolPage.copyWith(
                      snapshot: AsyncSnapshot<List<T>>.withData(
                          ConnectionState.done, listBuilder.listSearch),
                      loadingSearchScroll: false);
            }
          }
        }
      }
    }
    if (widget.searcher.listFull.isEmpty) {
      if (oldWidget.futureFetchPageItems != widget.futureFetchPageItems) {
        if (_activeListFullCallbackIdentity != null) {
          _unsubscribeListFullCallBack();

          widget.searcher.snapshotScroolPage =
              widget.searcher.snapshotScroolPage.copyWith(
                  snapshot: widget.searcher.snapshotScroolPage.snapshot
                      .inState(ConnectionState.none),
                  loadinglistFullScroll: false);
        }

        _firstFuturePageSubscribe();
      }
    }
  }

  void refazFutureSearchQuery() {
    _oneMorePage = false;

    if (widget.searcher.pageSearch > 1 &&
        widget.searcher.snapshotScroolPage.loadingSearchScroll) {
      if ((widget.searcher.mapsSearch[widget.searcher.rxSearch.value].listSearch
                  .length ~/
              widget.searcher.numPageItems) ==
          0) {
        widget.searcher.page--;
      }
    }
  }

  void refazFutureListFull() {
    if (widget.searcher.snapshotScroolPage.loadinglistFullScroll) {
      widget.searcher.page--;
    }
  }

  @override
  void dispose() {
    _unsubscribeListFullCallBack();
    _unsubscribeSearhCallBack();
    widget.searcher.onClose();
    _scrollController.removeListener(pagesListener);
    _scrollController.dispose();
    _unsubscribeConnecty();
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

    if (widget.widgetError == null) {
      _widgetError = Column(
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
    } else {
      _widgetError = widget.widgetError;
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

/* void _unsubscribeSearhQuery() {
    if (_subscriptionSearch != null) {
      _subscriptionSearch.cancel();
      _subscriptionSearch = null;
    }
  }*/
}
