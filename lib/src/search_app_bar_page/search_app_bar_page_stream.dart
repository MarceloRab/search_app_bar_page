import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'filters/filter.dart';
import 'filters/filters_type.dart';
import 'search_app_bar/search_app_bar.dart';
import 'controller/searcher_page_stream_controller.dart';
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

  /// Parametros para o Scaffold

  final Widget widgetWaiting;
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
  final Stream<List<T>> _stream;

  SearchAppBarPageStream({
    Key key,

    /// Parametros para o SearcherGetController
    @required this.listStream,
    @required this.listBuilder,
    this.compareSort,
    this.filtersType,
    this.stringFilter,

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
  })  : _stream = listStream.asBroadcastStream(),
        super(key: key);

  @override
  _SearchAppBarPageStreamState<T> createState() =>
      _SearchAppBarPageStreamState<T>();
}

class _SearchAppBarPageStreamState<T> extends State<SearchAppBarPageStream<T>> {
  SearcherPageStreamController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SearcherPageStreamController<T>(
        listStream: widget._stream,
        stringFilter: widget.stringFilter,
        compareSort: widget.compareSort,
        filtersType: widget.filtersType)
      ..onInit()
      ..onReady();
  }

  @override
  void dispose() {
    _controller.onClose();
    super.dispose();
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
        ),
        body: StreamSearchBuilder<T>(
            initialData: widget.initialData,
            stream: widget._stream,
            searcher: _controller,
            listBuilder: widget.listBuilder,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                if (widget.widgetError == null)
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
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
                    child: SizedBox(
                      child: const CircularProgressIndicator(),
                      width: 60,
                      height: 60,
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

/*class SearchGetxPage<T> extends StatelessWidget {
  /// Parametros para o Scaffold
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
  final Stream<List<T>> listStream;
  final FiltersTypes filtersType;
  final FunctionList<T> listBuilder;
  final Widget widgetWaiting;
  final StringFilter<T> stringFilter;
  final Compare<T> compareSort;

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

  final Stream<List<T>> stream;

  SearchGetxPage({
    Key key,

    /// Parametros para o SearcherGetController
    @required this.listStream,
    this.compareSort,
    this.filtersType,
    @required this.listBuilder,
    this.widgetWaiting,
    this.stringFilter,

    /// Parametros para o Scaffold
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
  })  : stream = listStream.asBroadcastStream(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearcherGetController<T>>(
        global: false,
        //tag: UniqueKey().toString(),
        assignId: true,
        dispose: (State state) {
          debugPrint('SearchGetxPage  dispose ${state.toString()}');
        },
        init: SearcherGetController<T>(
            listStream: stream,
            stringFilter: stringFilter,
            compareSort: compareSort),
        builder: (controller) {
          return Scaffold(
              appBar: SearchAppBar(
                controller: controller,
                title: searchAppBartitle,
                centerTitle: searchAppBarcenterTitle,
                elevation: searchAppBarelevation,
                iconTheme: searchAppBariconTheme,
                backgroundColor: searchAppBarbackgroundColor,
                searchBackgroundColor: searchAppBarModeSearchBackgroundColor,
                searchElementsColor: searchAppBarElementsColor,
                hintText: searchAppBarhintText,
                flattenOnSearch: searchAppBarflattenOnSearch,
                capitalization: searchAppBarcapitalization,
                actions: searchAppBaractions,
              ),
              body: StreamSearchGetxBuilder<T>(
                  stream: stream,
                  searcher: controller,
                  listBuilder: listBuilder,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
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
                    } else {
                      if (widgetWaiting == null)
                        return Center(
                          child: SizedBox(
                            child: const CircularProgressIndicator(),
                            width: 60,
                            height: 60,
                          ),
                        );
                      else
                        return widgetWaiting;
                    }
                  }),
              floatingActionButton: searchePageFloaActionButton,
              floatingActionButtonLocation:
                  searchePageFloatingActionButtonLocation,
              floatingActionButtonAnimator:
                  searchePageFloatingActionButtonAnimator,
              persistentFooterButtons: searchePagePersistentFooterButtons,
              drawer: searchePageDrawer,
              endDrawer: searchePageEndDrawer,
              bottomNavigationBar: searchePageBottomNavigationBar,
              bottomSheet: searchePageBottomSheet,
              backgroundColor: searchPageBackgroundColor,
              resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,
              resizeToAvoidBottomInset: resizeToAvoidBottomInset,
              primary: primary,
              drawerDragStartBehavior: drawerDragStartBehavior,
              extendBody: extendBody,
              extendBodyBehindAppBar: extendBodyBehindAppBar,
              drawerScrimColor: drawerScrimColor,
              drawerEdgeDragWidth: drawerEdgeDragWidth,
              drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
              endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture);
        });
  }
}*/
