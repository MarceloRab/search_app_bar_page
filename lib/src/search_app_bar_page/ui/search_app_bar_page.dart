import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/filters_type.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/seacher_widget_page_base.dart';

import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_page_controller.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/core/search_app_bar/search_app_bar.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/infra/rx_get_type.dart';

class SearchAppBarPage<T> extends StatefulWidget
    implements SearcherScaffoldBase {
  /// Parameters of SearchAppBar

  final Widget? searchAppBarTitle;
  final bool searchAppBarCenterTitle;
  final IconThemeData? searchAppBarIconTheme;
  final Color? searchAppBarBackgroundColor;
  final Color? searchAppBarModeSearchBackgroundColor;
  final Color? searchAppBarElementsColor;
  final String? searchAppBarHintText;
  final bool searchAppBarflattenOnSearch;
  final TextCapitalization searchAppBarCapitalization;
  final List<Widget> searchAppBarActions;
  final double searchAppBarElevation;
  final TextInputType? searchAppBarKeyboardType;
  final Color? magnifyGlassColor;
  final Color? searchTextColor;
  final double searchTextSize;

  /// Parameters Scaffold
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

  /// Parameters para o SearcherGetController

  /// [listFull] List to be filtered by Search.
  final List<T> listFull;

  /// [filtersType] These are the filters that the Controller uses to
  /// filter the list. Divide the filters into three types:
  ///  enum FiltersTypes { startsWith, equals, contains }
  /// Default = FiltersTypes.contains;
  final FiltersTypes? filtersType;

  /// [obxListBuilder] Function applied when it is filtered.
  final WidgetsListBuilder<T> obxListBuilder;

  /// [stringFilter] Required if you type.
  ///If not, it is understood that the type will be String.
  /// ex.: stringFilter: (Person person) => person.name,
  /// The list will be filtered by the person.name contains (default) a query.
  final StringFilter<T>? stringFilter;

  /// [whereFilter] Required if you want to make your own function to delete
  /// components from your list.
  ///If you don't want to use a String from your
  /// Object, pass it directly to a function to delete an item from your list.
  /// ex.: whereFilter: (Person person) => bool return - used to filter dates by the largest String,
  final WhereFilter<T>? whereFilter;

  /// [filter] Add function to do filtering manually.
  /// If you leave this parameter not null the parameter [stringFilter]
  /// must be null
  final Filter<T>? filter;

  /// [sortFunction] Manually add your sort function.
  final SortList<T>? sortFunction;

  ///[sortCompare] Your list will be ordered by the same function
  ///[stringFilter]. True by default.
  /// sort default compare by stringFilter return.
  final bool sortCompare;

  ///  [rxBoolAuth] Insert your RxBool here that changes with the auth
  /// status to have reactivity.
  final RxBoolAuth? rxBoolAuth;

  final OnSubmitted<T>? onSubmit;

  const SearchAppBarPage(
      {super.key,

      /// Parameters para o SearcherGetController
      required this.listFull,
      required this.obxListBuilder,
      this.onSubmit,
      this.sortCompare = true,
      this.filtersType,
      this.filter,
      this.sortFunction,
      this.stringFilter,
      this.whereFilter,
      this.rxBoolAuth,

      /// Parameters do SearchAppBar
      this.searchAppBarTitle,
      this.searchAppBarCenterTitle = false,
      this.searchAppBarIconTheme,
      this.searchAppBarBackgroundColor,
      this.searchAppBarModeSearchBackgroundColor,
      this.searchAppBarElementsColor,
      this.searchAppBarHintText,
      this.searchAppBarflattenOnSearch = false,
      this.searchAppBarCapitalization = TextCapitalization.none,
      this.searchAppBarActions = const <Widget>[],
      this.searchAppBarElevation = 4.0,
      this.searchAppBarKeyboardType,
      this.magnifyGlassColor,
      this.searchTextColor,
      this.searchTextSize = 18.0,

      /// Parameters para o Scaffold

      this.searchPageFloatingActionButton,
      this.searchPageFloatingActionButtonLocation,
      this.searchPageFloatingActionButtonAnimator,
      this.searchPagePersistentFooterButtons,
      this.searchPageDrawer,
      this.searchPageEndDrawer,
      this.searchPageBottomNavigationBar,
      this.searchPageBottomSheet,
      this.searchPageBackgroundColor,
      this.resizeToAvoidBottomInset,
      this.primary = true,
      this.drawerDragStartBehavior = DragStartBehavior.start,
      this.extendBody = false,
      this.extendBodyBehindAppBar = false,
      this.drawerScrimColor,
      this.drawerEdgeDragWidth,
      this.drawerEnableOpenDragGesture = true,
      this.endDrawerEnableOpenDragGesture = true,
      this.restorationId});

  @override
  SearchAppBarPageState<T> createState() => SearchAppBarPageState<T>();
}

class SearchAppBarPageState<T> extends State<SearchAppBarPage<T>> {
  late SearcherPageController<T> _controller;

  //Worker _worker;

  SearchAppBarPageState();

  void clearSearch() {
    _controller.clearSearch();
  }

  @override
  void initState() {
    super.initState();
    /*_controller = Get.put(SearcherPageController<T>(
        listFull: widget.listFull,
        stringFilter: widget.stringFilter,
        //compareSort: widget.compareSort,
        sortCompare: widget.sortCompare,
        filtersType: widget.filtersType)
      ..initFilters()
      ..onReady())!;*/

    _controller = SearcherPageController<T>(
        listFull: widget.listFull,
        stringFilter: widget.stringFilter,
        whereFilter: widget.whereFilter,
        //compareSort: widget.compareSort,
        filter: widget.filter,
        sortFunction: widget.sortFunction,
        sortCompare: widget.sortCompare,
        filtersType: widget.filtersType)
      ..initFilters()
      ..onReady();
  }

  @override
  void didUpdateWidget(SearchAppBarPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    _controller.stringFilter = widget.stringFilter;
    //_controller.compareSort = widget.compareSort;
    _controller.sortCompare = widget.sortCompare;
    _controller.filtersType = widget.filtersType;
    _controller.sortFunction = widget.sortFunction;
    _controller.filter = widget.filter;

    _controller.initFilters();

    if (oldWidget.listFull != widget.listFull) {
      _controller.listFull.clear();
      _controller.listFull.addAll(widget.listFull);
      _controller.sortCompareList(widget.listFull);

      if (_controller.rxSearch.value.isNotEmpty) {
        //if (oldWidget.sortFunction != widget.sortFunction) {
        _controller.refreshSearchList(_controller.rxSearch.value);
      } else {
        //if (oldWidget.sortFunction != widget.sortFunction) {
        _controller.onSearchList(widget.listFull);
      }
    } else {
      if (widget.listFull.isNotEmpty) {
        _controller.sortCompareList(widget.listFull);
        _controller.onSearchList(widget.listFull);
      }
    }
  }

  @override
  void dispose() {
    //TODO: para 5.0
    _controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SearchAppBar<T>(
            controller: _controller,
            onSubmit: widget.onSubmit,
            title: widget.searchAppBarTitle,
            centerTitle: widget.searchAppBarCenterTitle,
            elevation: widget.searchAppBarElevation,
            iconTheme: widget.searchAppBarIconTheme,
            backgroundColor: widget.searchAppBarBackgroundColor,
            searchBackgroundColor: widget.searchAppBarModeSearchBackgroundColor,
            searchElementsColor: widget.searchAppBarElementsColor,
            hintText: widget.searchAppBarHintText,
            flattenOnSearch: widget.searchAppBarflattenOnSearch,
            capitalization: widget.searchAppBarCapitalization,
            actions: widget.searchAppBarActions,
            keyboardType: widget.searchAppBarKeyboardType,
            searchTextSize: widget.searchTextSize,
            searchTextColor: widget.searchTextColor,
            magnifyGlassColor: widget.magnifyGlassColor),
        body: Obx(() {
          if (widget.rxBoolAuth?.auth.value == false) {
            return widget.rxBoolAuth!.authFalseWidget();
          }
          return widget.obxListBuilder(context, _controller.listSearch.toList(),
              _controller.isModSearch);
        }),
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
}
