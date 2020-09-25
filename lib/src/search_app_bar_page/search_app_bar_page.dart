import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_state_manager/get_state_manager.dart';

import 'controller/searcher_page_controller.dart';
import 'filters/filter.dart';
import 'filters/filters_type.dart';
import 'search_app_bar/search_app_bar.dart';

class SearchAppBarPage<T> extends StatefulWidget {
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
  final List<T> listFull;
  final FiltersTypes filtersType;
  final FunctionList<T> listBuilder;
  final StringFilter<T> stringFilter;
  final Compare<T> compareSort;

  SearchAppBarPage({
    Key key,

    /// Parametros para o SearcherGetController
    @required this.listFull,
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
    this.widgetWaiting,
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
  _SearchAppBarPageState<T> createState() => _SearchAppBarPageState<T>();
}

class _SearchAppBarPageState<T> extends State<SearchAppBarPage<T>> {
  SearcherPageController<T> _controller;

  @override
  void initState() {
    super.initState();
    _controller = SearcherPageController<T>(
        listFull: widget.listFull,
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
        body: Obx(() => widget.listBuilder(
            _controller.listSearch, _controller.isModSearch)),
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
