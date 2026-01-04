import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/seacher_widget_page_base.dart';

class SearchAppBarPageObx<T> extends StatefulWidget
    implements SearcherScaffoldBase {
  /// Parameters do SearchAppBar

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
  final Color? searchTextColor;
  final double searchTextSize;

  /// [magnifyInGlassColor] Changes the color of the magnifying glass.
  /// Keeps IconTheme color by default.
  final Color? magnifyInGlassColor;

  /// Start showing [widgetWaiting] until it shows the first data
  final Widget? widgetWaiting;

  /// [widgetErrorBuilder] Widget built by the Object error returned by the
  /// [listStream] error.
  final WidgetsErrorBuilder? widgetErrorBuilder;

  /// [searchPageFloatingActionButton] , [searchPageFloatingActionButton] ,
  /// [searchPageFloatingActionButtonLocation] ,
  /// [searchPageFloatingActionButtonAnimator]  ...
  /// ...
  /// are passed on to the Scaffold.
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
  final Color? magnifyGlassColor;

  /// Parameters para o SearcherGetController

  /// [listRx] Just add the RxList and we are already in charge
  /// of working with the data. There is a Obx in background.
  final RxList<T> listRx;

  /// [filtersType] These are the filters that the Controller uses to
  /// filter the list. Divide the filters into three types:
  /// startsWith, equals, contains. Default = FiltersTypes.contains;
  final FiltersTypes? filtersType;

  /// [obxListBuilder] Function applied when receiving data
  /// through Stream or filtering in search.
  final WidgetsListBuilder<T> obxListBuilder;

  /// [stringFilter] Required if you type.
  ///If not, it is understood that the type will be String.
  /// ex.: stringFilter: (Person person) => person.name,
  /// The list will be filtered by the person.name contains (default) a query.
  final StringFilter<T>? stringFilter;

  /// [whereFilter] Required if you type.
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

  ///If you want your list to be sorted, add the function on.
  /// Example: (Person a, Person b) => a.name.compareTo(b.name),
  /// This list will be ordered by the object name parameter.
  //final Compare<T> compareSort;

  ///[sortCompare] Your list will be ordered by the same function
  ///[stringFilter]. True by default.
  /// sort default compare by stringFilter return.
  final bool sortCompare;

  ///  [rxBoolAuth] Insert your RxBool here that changes with the auth
  /// status to have reactivity.
  final RxBoolAuth? rxBoolAuth;

  /// [onSubmit] Function called when submitting the search.
  /// Use the Enter key to submit the search.
  final OnSubmitted<T>? onSubmit;

  /// [onEnter] Triggers highlightIndex when isModSearch is false.
  final OnEnter<T>? onEnter;

  //final OnSubmitted<T>? onSubmit;

  /// [widthLargeScreenThreshold] Width threshold to consider a large screen layout.
  final double widthLargeScreenThreshold;

  /// [timeDebounce] Time in milliseconds for debounce.
  final Duration? timeDebounce;

  final bool autoFocus;

  const SearchAppBarPageObx({
    super.key,
    required this.listRx,
    required this.obxListBuilder,
    //this.onSubmit,
    this.onSubmit,
    this.onEnter,
    this.widgetErrorBuilder,
    this.stringFilter,
    this.whereFilter,
    this.filter,
    this.sortFunction,
    this.widthLargeScreenThreshold = 1100.0,
    this.timeDebounce,
    //this.compareSort,
    this.autoFocus = true,
    this.sortCompare = true,
    this.rxBoolAuth,
    this.filtersType,
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
    this.magnifyInGlassColor,
    this.searchTextColor,
    this.searchTextSize = 18.0,
    this.searchPageFloatingActionButton,
    this.searchPageFloatingActionButtonLocation,
    this.searchPageFloatingActionButtonAnimator,
    this.searchPagePersistentFooterButtons,
    this.searchPageDrawer,
    this.searchPageEndDrawer,
    this.searchPageBottomNavigationBar,
    this.searchPageBottomSheet,
    this.searchPageBackgroundColor,
    this.restorationId,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.widgetWaiting,
    this.magnifyGlassColor,
  });

  @override
  // ignore: lines_longer_than_80_chars
  State<SearchAppBarPageObx<T>> createState() => _SearchAppBarPageObxState<T>();
}

/// State for [StreamBuilderBase].
class _SearchAppBarPageObxState<T> extends State<SearchAppBarPageObx<T>> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final listFull = widget.listRx.value;
      return SearchAppBarPage<T>(
        listFull: listFull,
        obxListBuilder: widget.obxListBuilder,
        onSubmit: widget.onSubmit,
        onEnter: widget.onEnter,
        sortCompare: widget.sortCompare,
        filtersType: widget.filtersType,
        filter: widget.filter,
        sortFunction: widget.sortFunction,
        stringFilter: widget.stringFilter,
        whereFilter: widget.whereFilter,
        rxBoolAuth: widget.rxBoolAuth,
        autoFocus: widget.autoFocus,
        timeDebounce: widget.timeDebounce,
        widthLargeScreenThreshold: widget.widthLargeScreenThreshold,
        searchAppBarTitle: widget.searchAppBarTitle,
        searchAppBarCenterTitle: widget.searchAppBarCenterTitle,
        searchAppBarIconTheme: widget.searchAppBarIconTheme,
        searchAppBarBackgroundColor: widget.searchAppBarBackgroundColor,
        searchAppBarModeSearchBackgroundColor:
            widget.searchAppBarModeSearchBackgroundColor,
        searchAppBarElementsColor: widget.searchAppBarElementsColor,
        searchAppBarHintText: widget.searchAppBarHintText,
        searchAppBarflattenOnSearch: widget.searchAppBarflattenOnSearch,
        searchAppBarCapitalization: widget.searchAppBarCapitalization,
        searchAppBarActions: widget.searchAppBarActions,
        searchAppBarElevation: widget.searchAppBarElevation,
        searchAppBarKeyboardType: widget.searchAppBarKeyboardType,
        magnifyGlassColor: widget.magnifyGlassColor,
        magnifyInGlassColor: widget.magnifyInGlassColor,
        searchTextColor: widget.searchTextColor,
        searchTextSize: widget.searchTextSize,
        searchPageFloatingActionButton: widget.searchPageFloatingActionButton,
        searchPageFloatingActionButtonLocation:
            widget.searchPageFloatingActionButtonLocation,
        searchPageFloatingActionButtonAnimator:
            widget.searchPageFloatingActionButtonAnimator,
        searchPagePersistentFooterButtons:
            widget.searchPagePersistentFooterButtons,
        searchPageDrawer: widget.searchPageDrawer,
        searchPageEndDrawer: widget.searchPageEndDrawer,
        searchPageBottomNavigationBar: widget.searchPageBottomNavigationBar,
        searchPageBottomSheet: widget.searchPageBottomSheet,
        searchPageBackgroundColor: widget.searchPageBackgroundColor,
        restorationId: widget.restorationId,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        primary: widget.primary,
        drawerDragStartBehavior: widget.drawerDragStartBehavior,
        extendBody: widget.extendBody,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        drawerScrimColor: widget.drawerScrimColor,
        drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
        widgetWaiting: widget.widgetWaiting,
        widgetErrorBuilder: widget.widgetErrorBuilder,
      );
    });
  }
}
