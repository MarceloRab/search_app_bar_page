import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/filters_type.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/seacher_widget_page_base.dart';

import '../controller/searcher_page_controller.dart';
import 'core/search_app_bar/search_app_bar.dart';
import 'infra/rx_get_type.dart';

class SearchAppBarPage<T> extends StatefulWidget
    implements SeacherScaffoldBase {
  /// Paramentros do SearchAppBar

  final Widget? searchAppBartitle;
  final bool searchAppBarcenterTitle;
  final IconThemeData? searchAppBariconTheme;
  final Color? searchAppBarbackgroundColor;
  final Color? searchAppBarModeSearchBackgroundColor;
  final Color? searchAppBarElementsColor;
  final String? searchAppBarhintText;
  final bool searchAppBarflattenOnSearch;
  final TextCapitalization searchAppBarcapitalization;
  final List<Widget> searchAppBaractions;
  final double searchAppBarElevation;
  final TextInputType? searchAppBarKeyboardType;
  final Color? magnifyinGlassColor;

  /// Parametros para o Scaffold
  @override
  final Widget? searchePageFloatingActionButton;
  @override
  final FloatingActionButtonLocation? searchePageFloatingActionButtonLocation;
  @override
  final FloatingActionButtonAnimator? searchePageFloatingActionButtonAnimator;
  @override
  final List<Widget>? searchePagePersistentFooterButtons;
  @override
  final Widget? searchePageDrawer;
  @override
  final Widget? searchePageEndDrawer;
  @override
  final Widget? searchePageBottomNavigationBar;
  @override
  final Widget? searchePageBottomSheet;
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

  /// Parametros para o SearcherGetController

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

  const SearchAppBarPage(
      {Key? key,

      /// Parametros para o SearcherGetController
      required this.listFull,
      required this.obxListBuilder,
      this.sortCompare = true,
      this.filtersType,
      this.filter,
      this.sortFunction,
      this.stringFilter,
      this.rxBoolAuth,

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
      this.searchAppBarElevation = 4.0,
      this.searchAppBarKeyboardType,
      this.magnifyinGlassColor,

      /// Parametros para o Scaffold

      this.searchePageFloatingActionButton,
      this.searchePageFloatingActionButtonLocation,
      this.searchePageFloatingActionButtonAnimator,
      this.searchePagePersistentFooterButtons,
      this.searchePageDrawer,
      this.searchePageEndDrawer,
      this.searchePageBottomNavigationBar,
      this.searchePageBottomSheet,
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
      this.restorationId})
      :
        //assert(listFull != null),
        super(key: key);

  @override
  _SearchAppBarPageState<T> createState() => _SearchAppBarPageState<T>();
}

class _SearchAppBarPageState<T> extends State<SearchAppBarPage<T>> {
  late SearcherPageController<T> _controller;

  //Worker _worker;

  _SearchAppBarPageState();

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
        _controller.refreshSeachList(_controller.rxSearch.value);
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
            elevation: widget.searchAppBarElevation,
            iconTheme: widget.searchAppBariconTheme,
            backgroundColor: widget.searchAppBarbackgroundColor,
            searchBackgroundColor: widget.searchAppBarModeSearchBackgroundColor,
            searchElementsColor: widget.searchAppBarElementsColor,
            hintText: widget.searchAppBarhintText,
            flattenOnSearch: widget.searchAppBarflattenOnSearch,
            capitalization: widget.searchAppBarcapitalization,
            actions: widget.searchAppBaractions,
            keyboardType: widget.searchAppBarKeyboardType,
            magnifyinGlassColor: widget.magnifyinGlassColor),
        body: Obx(() {
          if (widget.rxBoolAuth?.auth.value == false) {
            return widget.rxBoolAuth!.authFalseWidget();
          }
          return widget.obxListBuilder(context, _controller.listSearch.toList(),
              _controller.isModSearch);
        }),
        floatingActionButton: widget.searchePageFloatingActionButton,
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
