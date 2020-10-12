import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_state_manager/get_state_manager.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/connecty_controller.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/core/search_app_bar/search_app_bar.dart';

import '../../../controller/searcher_page_stream_controller.dart';

typedef WidgetConnecty = Widget Function();

abstract class StreamSearcherBuilderBase<T, S> extends StatefulWidget {
  const StreamSearcherBuilderBase(
      {Key key,
      @required this.searcher,
      @required this.stream,
      @required this.widgetConnecty})
      : super(key: key);

  // nao de pode colocar final. Após um setState precisa refaze-la
  // vide o metodo didUpdateWidget
  // T as List
  final Stream<T> stream;
  final SearcherPageStreamController searcher;

  S initial();

  T get getInitialData;

  S afterConnected(S current) => current;

  S afterData(S current, T data);

  S afterError(S current, Object error) => current;

  S afterDone(S current) => current;

  S afterDisconnected(S current) => current;

  //final WidgetConnecty widgetConnecty;
  final Widget widgetConnecty;

  Widget build(BuildContext context, S currentSummary);

  @override
  State<StreamSearcherBuilderBase<T, S>> createState() =>
      _StreamSearcherGetxBuilderBase<T, S>();
}

/// State for [StreamBuilderBase].
class _StreamSearcherGetxBuilderBase<T, S>
    extends State<StreamSearcherBuilderBase<T, S>> {
  StreamSubscription<T> _subscription;
  StreamSubscription _subscriptionConnecty;
  S _summary;

  // T as List
  T _initialData;
  bool _haveInitialData;

  ConnectyController _connectyController;
  bool downConnectyWithoutData = false;

  Widget _widgetConnecty;

  @override
  void initState() {
    super.initState();
    _initialData = widget.getInitialData;
    _haveInitialData = _initialData != null;
    _summary = widget.initial();
    _subscribeStream();
    if (!_haveInitialData) {
      _connectyController = ConnectyController();
      _subscribeConnecty();
    } else {
      widget.searcher.listFull.addAll(_initialData as List);
      widget.searcher.sortCompareList(widget.searcher.listFull);
      widget.searcher.onSearchList(_initialData as List);
    }

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

  @override
  void didUpdateWidget(StreamSearcherBuilderBase<T, S> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.getInitialData != widget.getInitialData) {
      _initialData = widget.getInitialData;
      _haveInitialData = _initialData != null;

      if (_haveInitialData) {
        if (widget.searcher.haveInitialData) {
          downConnectyWithoutData = false;
        }
        _summary = widget.initial();
        widget.searcher.wrabListSearch(_initialData as List);
        _unsubscribeConnecty();
      }
    }

    if (oldWidget.stream != widget.stream) {
      if (_subscription != null) {
        _unsubscribeStream();
        //Necessário para resolver após o setState
        //widget.stream = oldWidget.stream.asBroadcastStream();
        _summary = widget.afterDisconnected(_summary);
      }

      _subscribeStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (downConnectyWithoutData) {
      // Apenas anuncia quando nao tem a primeira data e esta sem conexao
      return _widgetConnecty;
    }

    // retorna o build sobreposto do filho
    // este retona o builder
    return widget.build(context, _summary);
  }

  @override
  void dispose() {
    _unsubscribeStream();
    _unsubscribeConnecty();
    widget.searcher.onClose();
    super.dispose();
  }

  void _subscribeStream() {
    _subscription = widget.stream.listen((data) {
      downConnectyWithoutData = false;
      _unsubscribeConnecty();
      // reflexo no searchList
      widget.searcher.wrabListSearch(data as List);
      // quando haveInitialData = true a mudança é assumida pelo Obx
      // na classe StreamSearchBuilder
      if (!widget.searcher.haveInitialData) {
        setState(() {
          _summary = widget.afterData(_summary, data);
        });
      } else {
        _summary = widget.afterData(_summary, data);
      }
    }, onError: (Object error) {
      setState(() {
        _summary = widget.afterError(_summary, error);
      });
    }, onDone: () {
      setState(() {
        _summary = widget.afterDone(_summary);
      });
    });
    _summary = widget.afterConnected(_summary);
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
          _summary = widget.afterConnected(_summary);
        });
      }
    });
  }

  void _unsubscribeConnecty() {
    if (_subscriptionConnecty != null) {
      _subscriptionConnecty.cancel();
      _subscriptionConnecty = null;
      _connectyController.onClose();
    }
  }

  void _unsubscribeStream() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }
}

class StreamSearcherBuilderBase2<T> extends StatefulWidget {
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

  ///  [iconConnectyOffAppBar] Aparece quando o status da conexao é off.
  ///  já existe um icone default. Caso nao queira apresentar escolha
  ///  [hideDefaultConnectyIconOffAppBar] = false;

  /// Parametros para o Scaffold

  ///  [widgetOffConnectyWaiting] Apenas mostra algo quando esta sem conexao
  ///  e ainda nao tem o primeiro valor da stream. Se a conexao voltar
  ///  passa a mostrar o [widgetWaiting] até apresentar o primeiro dado
  final Widget widgetWaiting;
  final Widget widgetOffConnectyWaiting;

  /// [widgetErrorBuilder] Widget built by the Object error returned by the
  /// [listStream] error.
  final WidgetsErrorBuilder widgetErrorBuilder;

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

  /// Parametros para o SearcherGetController

  /// [initialData] List to be filtered by Search.
  /// These widgets will not be displayed. [widgetOffConnectyWaiting] and
  /// [widgetWaiting]
  final List<T> initialData;

  /// [listStream] Just pass the Stream and we are already in charge
  /// of working with the data. There is a StremBuilder in background.
  final Stream<List<T>> listStream;

  /// [filtersType] These are the filters that the Controller uses to
  /// filter the list. Divide the filters into three types:
  /// startsWith, equals, contains. Default = FiltersTypes.contains;
  final FiltersTypes filtersType;

  /// [listBuilder] Function applied when receiving data
  /// through Stream or filtering in search.
  //TODO: mudar tipo método
  final WidgetsListBuilder2<T> listBuilder;

  /// [stringFilter] Required if you type.
  ///If not, it is understood that the type will be String.
  /// ex.: stringFilter: (Person person) => person.name,
  /// The list will be filtered by the person.name contains (default) a query.
  final StringFilter<T> stringFilter;

  ///[compareSort] If you want your list to be sorted, pass the function on.
  /// Example: (Person a, Person b) => a.name.compareTo(b.name),
  /// This list will be ordered by the object name parameter.
  final Compare<T> compareSort;

  const StreamSearcherBuilderBase2({
    Key key,
    @required this.listStream,
    @required this.widgetConnecty,
    @required this.listBuilder,
    this.initialData,
    this.widgetWaiting,
    this.widgetErrorBuilder,
    this.widgetNothingFound,
    this.stringFilter,
    this.compareSort,
    this.filtersType,
    this.searchAppBartitle,
    this.searchAppBarcenterTitle,
    this.searchAppBariconTheme,
    this.searchAppBarbackgroundColor,
    this.searchAppBarModeSearchBackgroundColor,
    this.searchAppBarElementsColor,
    this.searchAppBarIconConnectyOffAppBarColor,
    this.searchAppBarhintText,
    this.searchAppBarflattenOnSearch,
    this.searchAppBarcapitalization,
    this.searchAppBaractions,
    this.searchAppBarelevation,
    this.searchAppBarKeyboardType,
    this.magnifyinGlassColor,
    this.hideDefaultConnectyIconOffAppBar,
    this.iconConnectyOffAppBar,
    this.widgetOffConnectyWaiting,
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
    this.primary,
    this.drawerDragStartBehavior,
    this.extendBody,
    this.extendBodyBehindAppBar,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture,
    this.endDrawerEnableOpenDragGesture,
  }) : super(key: key);

  final Widget widgetNothingFound;
  final Widget widgetConnecty;

  @override
  State<StreamSearcherBuilderBase2<T>> createState() =>
      _StreamSearcherBuilderBase2<T>();
}

/// State for [StreamBuilderBase].
class _StreamSearcherBuilderBase2<T>
    extends State<StreamSearcherBuilderBase2<T>> {
  StreamSubscription<List<T>> _subscription;
  StreamSubscription _subscriptionConnecty;

  // T as List

  bool _haveInitialData;

  ConnectyController _connectyController;
  bool downConnectyWithoutData = false;

  Widget _widgetConnecty;
  Widget _widgetWaiting;
  Widget _widgetNothingFound;

  Worker _worker;

  SearcherPageStreamController<T> _controller;

  void initial(List<T> data) => _controller.snapshot =
      AsyncSnapshot<List<T>>.withData(ConnectionState.none, data);

  void afterConnected() => _controller.snapshot =
      _controller.snapshot.inState(ConnectionState.waiting);

  void afterData(List<T> data) => _controller.snapshot = _controller.snapshot =
      AsyncSnapshot<List<T>>.withData(ConnectionState.active, data);

  void afterError(Object error) => _controller.snapshot =
      AsyncSnapshot<List<T>>.withError(ConnectionState.active, error);

  void afterDone() =>
      _controller.snapshot = _controller.snapshot.inState(ConnectionState.done);

  void afterDisconnected() =>
      _controller.snapshot = _controller.snapshot.inState(ConnectionState.none);

  @override
  void initState() {
    super.initState();
    _controller = SearcherPageStreamController<T>(
        //listStream: widget._stream,
        stringFilter: widget.stringFilter,
        compareSort: widget.compareSort,
        filtersType: widget.filtersType)
      ..onInit();
    //..subscribeWorker();

    _haveInitialData = widget.initialData != null;

    _subscribeStream();
    _subscribreSearhQuery();
    if (!_haveInitialData) {
      _subscribeConnecty();
    } else {
      _controller.listFull.addAll(widget.initialData);
      _controller.sortCompareList(_controller.listFull);
      initial(_controller.listFull);
    }

    buildwidgetsDefault();
  }

  @override
  void didUpdateWidget(StreamSearcherBuilderBase2<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialData != widget.initialData) {
      //_initialData = widget.getInitialData;
      _haveInitialData = widget.initialData != null;

      if (_haveInitialData) {
        _controller.wrabListSearch(widget.initialData);
        downConnectyWithoutData = false;
        _unsubscribeConnecty();

        if (widget.initialData.length > _controller.listFull.length) {
          _controller.listFull.clear();
          _controller.listFull.addAll(widget.initialData);
          _controller.sortCompareList(_controller.listFull);
          initial(_controller.listFull);
        }
      } else if (_controller.listFull.isEmpty &&
          _subscriptionConnecty != null) {
        _subscribeConnecty();
      }
    }

    if (oldWidget.stringFilter != widget.stringFilter) {
      _controller.stringFilter = widget.stringFilter;
    }

    if (oldWidget.compareSort != widget.compareSort) {
      _controller.compareSort = widget.compareSort;
    }

    if (oldWidget.filtersType != widget.filtersType) {
      _controller.filtersType = widget.filtersType;
    }

    if (_controller.listFull.isNotEmpty) {
      if (_controller.rxSearch.value.isNotEmpty) {
        afterData(_controller.refreshSeachList2(_controller.rxSearch.value));
      } else {
        _controller.sortCompareList(_controller.listFull);
        afterData(_controller.listFull);
      }
    }

    if (oldWidget.listStream != widget.listStream) {
      if (_subscription != null) {
        _unsubscribeStream();

        afterDisconnected();
      }

      _subscribeStream();
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
      //print(widget.searcher.snapshotScroolPage.snapshot.connectionState
      //.toString());
      if (_controller.snapshot.connectionState == ConnectionState.waiting) {
        return _widgetWaiting;
      }

      if (_controller.snapshot.hasError) {
        return buildWidgetError(_controller.snapshot.error);
      }

      if (_controller.snapshot.data.isEmpty) {
        return _widgetNothingFound;
      }
      //final isListFull = widget.searcher.rxSearch.value.isEmpty;
      return widget.listBuilder(
          context, _controller.snapshot.data, _controller.isModSearch);
    });
  }

  @override
  void dispose() {
    _unsubscribeStream();
    _unsubscribeConnecty();
    _controller.onClose();
    _worker?.dispose();
    super.dispose();
  }

  void _subscribeStream() {
    _subscription = widget.listStream.listen((data) {
      downConnectyWithoutData = false;
      _unsubscribeConnecty();
      // reflexo no searchList
      // widget.searcher.wrabListSearch(data);

      _controller.listFull = data;
      _controller.sortCompareList(_controller.listFull);

      if (_controller.rxSearch.value.isNotEmpty) {
        afterData(_controller.refreshSeachList2(_controller.rxSearch.value));
      } else {
        afterData(_controller.listFull);
      }
    }, onError: (Object error) {
      afterError(error);
    }, onDone: () {
      afterDone();
    });
    afterConnected();
  }

  void _subscribreSearhQuery() {
    _worker = debounce(_controller.rxSearch, (String query) {
      if (query.isNotEmpty) {
        afterData(_controller.refreshSeachList2(query));
      } else {
        afterData(_controller.listFull);
      }
    }, time: const Duration(milliseconds: 350));
  }

  void _subscribeConnecty() {
    _connectyController = ConnectyController();
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
          afterConnected();
        });
      }
    });
  }

  void _unsubscribeConnecty() {
    if (_subscriptionConnecty != null) {
      _subscriptionConnecty.cancel();
      _subscriptionConnecty = null;
      _connectyController.onClose();
    }
  }

  void _unsubscribeStream() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }

  Widget buildWidgetError(Object error) {
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

  void buildwidgetsDefault() {
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
  }
}
