import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'controller/searcher_page_stream_controller.dart';
import 'filters/filter.dart';
import 'filters/filters_type.dart';
import 'search_app_bar/search_app_bar.dart';
import 'stream_helper/stream_search_builder.dart';

class SearchAppBarPageStream<T> extends StatefulWidget {
  /// Paramentros do SearchAppBar

  final Widget searchAppBartitle;
  final bool searchAppBarcenterTitle;
  final IconThemeData searchAppBariconTheme;
  final Color searchAppBarbackgroundColor;
  final Color searchAppBarModeSearchBackgroundColor;
  final Color searchAppBarElementsColor;
  final String searchAppBarhintText;
  final bool searchAppBarflattenOnSearch;
  final TextCapitalization searchAppBarcapitalization;
  final List<Widget> searchAppBaractions;
  final double searchAppBarelevation;
  final bool showIconConnectyOffAppBar;
  final Widget iconConnectyOffAppBar;

  ///  [iconConnectyOffAppBar] Aparece quando o status da conexao é off.
  ///  já existe um icone default. Caso nao queira apresentar escolha
  ///  [showIconConnectyOffAppBar] = false;

  /// Parametros para o Scaffold

  ///  [widgetConnecty] Apenas mostra algo quando esta sem conexao e ainda nao
  ///  tem o primeiro valor da stream. Se a conexao voltar passa a mostrar
  /// o [widgetWaiting] até apresentar o primeiro dado
  final Widget widgetWaiting;
  final Widget widgetConnecty;
  final Widget widgetError;
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
  final List<T> initialData;
  final Stream<List<T>> listStream;
  final FiltersTypes filtersType;
  final FunctionList<T> listBuilder;
  final StringFilter<T> stringFilter;
  final Compare<T> compareSort;

  /// Para montar em asBroadcastStream
  // nao de pode colocar final. Após um setState precisa refaze-la
  // vide o metodo didUpdateWidget

  const SearchAppBarPageStream({
    Key key,

    /// Parametros para o SearcherGetController
    @required this.listStream,
    @required this.listBuilder,
    this.compareSort,
    this.filtersType,
    this.stringFilter,
    this.widgetConnecty,

    /// Paramentros do SearchAppBar
    this.searchAppBartitle,
    this.searchAppBarcenterTitle = false,
    this.searchAppBariconTheme,
    this.searchAppBarbackgroundColor,
    this.searchAppBarModeSearchBackgroundColor,
    this.searchAppBarElementsColor,
    this.searchAppBarhintText,
    this.searchAppBarflattenOnSearch = false,
    this.searchAppBarcapitalization = TextCapitalization.none,
    this.searchAppBaractions = const <Widget>[],
    this.searchAppBarelevation = 4.0,
    this.showIconConnectyOffAppBar = true,
    this.iconConnectyOffAppBar,

    /// Parametros para o Scaffold

    this.initialData,
    this.widgetWaiting,
    this.widgetError,
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
  }) : super(key: key);

  @override
  _SearchAppBarPageStreamState<T> createState() =>
      _SearchAppBarPageStreamState<T>();
}

class _SearchAppBarPageStreamState<T> extends State<SearchAppBarPageStream<T>> {
  SearcherPageStreamController<T> _controller;

  //StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    _controller = SearcherPageStreamController<T>(
        //listStream: widget._stream,
        stringFilter: widget.stringFilter,
        compareSort: widget.compareSort,
        filtersType: widget.filtersType)
      ..onInit()
      ..subscribeWorker();
    //_subscribeListStream();
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
          searchElementsColor: widget.searchAppBarElementsColor,
          hintText: widget.searchAppBarhintText,
          flattenOnSearch: widget.searchAppBarflattenOnSearch,
          capitalization: widget.searchAppBarcapitalization,
          actions: widget.searchAppBaractions,
          showIconConnectyOffAppBar: widget.showIconConnectyOffAppBar,
          iconConnectyOffAppBar: widget.iconConnectyOffAppBar,
        ),
        body: StreamSearchBuilder<T>(
            initialData: widget.initialData,
            widgetConnecty: widget.widgetConnecty,
            stream: widget.listStream,
            searcher: _controller,
            listBuilder: widget.listBuilder,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
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
                            child: Text('Temos um erro: ${snapshot.error}'),
                          ),
                        )
                      ]);
                else
                  return widget.widgetError;
              } else {
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
            }),
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

/* void _subscribeListStream() {
    _streamSubscription = widget._stream.listen((listData) {
      if (_controller.bancoInit) {
        // Fica negativo dentro do StreamBuilder
        // Após apresentar o primeiro Obx(())
        _controller.listFull = listData;
        if (_controller.rxSearch.value.isNotEmpty) {
          _controller.refreshSeachList(_controller.rxSearch.value);
        } else {
          _controller.sortCompareList(listData);
          _controller.onSearchFilter(listData);
        }
      } else {
        _controller.initialChangeList = listData;
      }
    });
  }


void _unsubscribeListStream() {
    if (_streamSubscription != null) {
      _streamSubscription.cancel();
      _streamSubscription = null;
    }
  }


 @override
  void didUpdateWidget(SearchAppBarPageStream<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._stream != widget._stream) {
      if (_streamSubscription != null) {
        _unsubscribeListStream();
        //Necessário para resolver após o setState
        widget._stream = oldWidget._stream.asBroadcastStream();
      }

      _subscribeListStream();
    }
  }


 @override
  void dispose() {
    //_controller.onClose();
    _unsubscribeListStream();
    super.dispose();
  }
*/

/*
class SearchAppBarPageStream<T> extends StatelessWidget {
  /// Paramentros do SearchAppBar

  final Widget searchAppBartitle;
  final bool searchAppBarcenterTitle;
  final IconThemeData searchAppBariconTheme;
  final Color searchAppBarbackgroundColor;
  final Color searchAppBarModeSearchBackgroundColor;
  final Color searchAppBarElementsColor;
  final String searchAppBarhintText;
  final bool searchAppBarflattenOnSearch;
  final TextCapitalization searchAppBarcapitalization;
  final List<Widget> searchAppBaractions;
  final double searchAppBarelevation;
  final bool showIconConnectyOffAppBar;
  final Widget iconConnectyOffAppBar;

  ///  [iconConnectyOffAppBar] Aparece quando o status da conexao é off.
  ///  já existe um icone default. Caso nao queira apresentar escolha
  ///  [showIconConnectyOffAppBar] = false;


  /// Parametros para o Scaffold

  ///  [widgetConnecty] Apenas mostra algo quando esta sem conexao e ainda nao
  ///  tem o primeiro valor da stream. Se a conexao voltar passa a mostrar
  /// o [widgetWaiting] até apresentar o primeiro dado
  final Widget widgetWaiting;
  final Widget widgetConnecty;
  final Widget widgetError;
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
  final List<T> initialData;
  final Stream<List<T>> listStream;
  final FiltersTypes filtersType;
  final FunctionList<T> listBuilder;
  final StringFilter<T> stringFilter;
  final Compare<T> compareSort;

  /// Para montar em asBroadcastStream
  // nao de pode colocar final. Após um setState precisa refaze-la
  // vide o metodo didUpdateWidget
  Stream<List<T>> _stream;

  SearchAppBarPageStream({
    Key key,

    /// Parametros para o SearcherGetController
    @required this.listStream,
    @required this.listBuilder,
    this.compareSort,
    this.filtersType,
    this.stringFilter,
    this.widgetConnecty,

    /// Paramentros do SearchAppBar
    this.searchAppBartitle,
    this.searchAppBarcenterTitle = false,
    this.searchAppBariconTheme,
    this.searchAppBarbackgroundColor,
    this.searchAppBarModeSearchBackgroundColor,
    this.searchAppBarElementsColor,
    this.searchAppBarhintText,
    this.searchAppBarflattenOnSearch = false,
    this.searchAppBarcapitalization = TextCapitalization.none,
    this.searchAppBaractions = const <Widget>[],
    this.searchAppBarelevation = 4.0,
    this.showIconConnectyOffAppBar = true,
    this.iconConnectyOffAppBar,

    /// Parametros para o Scaffold

    this.initialData,
    this.widgetWaiting,
    this.widgetError,
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
  })
      : _stream = listStream.asBroadcastStream(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SearchAppBar(
          controller: SearcherPageStreamController<T>(
            //listStream: widget._stream,
              stringFilter: stringFilter,
              compareSort: compareSort,
              filtersType: filtersType)
            ..onInit()
            ..subscribeWorker(),
          title: searchAppBartitle,
          centerTitle:searchAppBarcenterTitle,
          elevation: searchAppBarelevation,
          iconTheme: searchAppBariconTheme,
          backgroundColor: searchAppBarbackgroundColor,
          searchBackgroundColor: searchAppBarModeSearchBackgroundColor,
          searchElementsColor: searchAppBarElementsColor,
          hintText: searchAppBarhintText,
          flattenOnSearch: searchAppBarflattenOnSearch,
          capitalization: searchAppBarcapitalization,
          actions: searchAppBaractions,
          showIconConnectyOffAppBar: showIconConnectyOffAppBar,
          iconConnectyOffAppBar: iconConnectyOffAppBar,
        ),
        body: StreamSearchBuilder<T>(
            initialData: .initialData,
            widgetConnecty: .widgetConnecty,
            stream: ._stream,
            searcher: _controller,
            listBuilder: widget.listBuilder,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
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
                            child: Text('Temos um erro: ${snapshot.error}'),
                          ),
                        )
                      ]);
                else
                  return widget.widgetError;
              } else {
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
            }),
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
