import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_page_controller.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/filters_type.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/core/search_app_bar/search_app_bar.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/infra/rx_get_type.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/seacher_widget_page_base.dart';

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

  /// [magnifyInGlassColor] Changes the color of the magnifying glass.
  /// Keeps IconTheme color by default.
  final Color? magnifyInGlassColor;

  final Color? searchTextColor;
  final double searchTextSize;

  /// [widgetWaiting] Widget built by the Object error returned by the
  /// [listAsync].
  final Widget? widgetWaiting;

  /// [widgetErrorBuilder] Widget built by the Object error returned by the
  /// [listAsync] or [onAsyncError].
  final WidgetsErrorBuilder? widgetErrorBuilder;

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

//TODO: modificar nome para explicar que é uma lista filtrada - na teoria não há necessidade de listFull
//TODO: quando isAsync = true, listFull não é usada
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
//TODO: trocar para listFilteredAsync

  /// [listAsync] Function to fetch list items asynchronously.
  final ListAsync<T>? listAsync;

  /// [isAsync] Set to true if you are using [listAsync].
  final bool isAsync;

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

  /// [autoFocus] Whether to focus the search field automatically when
  final bool autoFocus;

  /// [widthLargeScreenThreshold] Width threshold to consider a large screen layout.
  final double widthLargeScreenThreshold;

  const SearchAppBarPage(
      {super.key,

      /// Parameters para o SearcherGetController
      required this.listFull,
      required this.obxListBuilder,
      this.onSubmit,
      this.onEnter,
      this.sortCompare = true,
      this.filtersType,
      this.filter,
      this.sortFunction,
      this.stringFilter,
      this.whereFilter,
      this.rxBoolAuth,
      this.autoFocus = true,
      this.widthLargeScreenThreshold = 1100.0,
      this.isAsync = false,
      this.listAsync,

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
      this.magnifyInGlassColor,
      this.searchTextColor,
      this.searchTextSize = 18.0,
      this.widgetWaiting,
      this.widgetErrorBuilder,

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
      this.restorationId})
      : assert(!isAsync || listAsync != null,
            'listAsync must not be null if isAsync is true');

  @override
  SearchAppBarPageState<T> createState() => SearchAppBarPageState<T>();
}

class SearchAppBarPageState<T> extends State<SearchAppBarPage<T>> {
  late SearcherPageController<T> _controller;

  late final bool Function(KeyEvent) _keyboardHandler;
  bool _escapeKeyHeldDown = false;

  bool _handleGlobalKeyEvent(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (event is KeyDownEvent) {
        _controller.incrementSelection();
      }
      return true; // Use true se quiser capturar o evento e evitar propagação
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (event is KeyDownEvent) {
        _controller.decrementSelection();
      }
      return true;
    }
    final primaryFocus = FocusManager.instance.primaryFocus;
    // Ignora FocusScopeNode - só bloqueia se for um FocusNode de widget interativo (TextField, etc)
    final isInteractiveWidget = primaryFocus != null &&
        primaryFocus is! FocusScopeNode &&
        !_controller.focusSearch.hasFocus;

    if (!isInteractiveWidget) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        // Se existe foco em widget interativo (não focusSearch), não processa o Enter

        if (event is KeyDownEvent) {
          if (!isModSearch) {
            final list = widget.isAsync
                ? _controller.listSearch.toList()
                : _controller.listFull;
            widget.onEnter?.call(list, _controller.highLightIndex.value);
          } else {
            widget.onSubmit?.call(
                _controller.rxSearch.value,
                _controller.listSearch.toList(),
                _controller.highLightIndex.value);
          }
        }
        return true;
      }
    }

    //if (_controller.focusSearch.hasFocus) {

    if (event.logicalKey != LogicalKeyboardKey.escape) {
      return false;
    }

    if (event is KeyUpEvent) {
      _escapeKeyHeldDown = false;
      return false;
    }
    if (event is! KeyDownEvent || _escapeKeyHeldDown) {
      return false;
    }

    _escapeKeyHeldDown = true;

    if (isModSearch) {
      clearSearch();
    } else {
      initShowSearch();
      _controller.focusSearch.requestFocus();
    }
    return false;
  }

  SearchAppBarPageState();

  void clearSearch() {
    _controller.onCancelSearch?.call();
    _controller.highLightIndex.value = 0;
  }

  void initShowSearch() {
    _controller.initShowSearch?.call(null);
    if (widget.isAsync) {
      _controller.onSearchList([]);
      //refreshSearchList('');
    }
    _controller.rxSearch.value = '';
    _controller.highLightIndex.value = 0;
  }

  bool get isModSearch => _controller.isModSearch;

  void onEnter() {
    //* gera sobreposição caso haja outro Textfield na tela
    /* if (widget.onEnter != null) {
      final list = _controller.isModSearch ? _controller.listSearch : _controller.listFull;
      widget.onEnter!(list, _controller.highLightIndex.value);
    } */

    if (widget.onEnter != null && !_controller.isModSearch) {
      widget.onEnter!(_controller.listFull, _controller.highLightIndex.value);
    }
  }

  @override
  void initState() {
    //_escapeAction = KCallbackAction<EscapeIntent>(onInvoke: _handleUnFocusKeyPress);
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
        isAsync: widget.isAsync,
        listAsync: widget.listAsync,
        filter: widget.filter,
        sortFunction: widget.sortFunction,
        sortCompare: widget.sortCompare,
        filtersType: widget.filtersType)
      ..initFilters()
      ..onReady();

    _keyboardHandler = _handleGlobalKeyEvent;
    HardwareKeyboard.instance.addHandler(_keyboardHandler);
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

        if (_controller.rxSearch.value.isNotEmpty) {
          _controller.refreshSearchList(_controller.rxSearch.value);
        }
      }
    }
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_keyboardHandler);
    _controller.onClose();
    super.dispose();
  }

  bool get isSmallOrMobileScreen =>
      GetPlatform.isMobile || Get.width < widget.widthLargeScreenThreshold;

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
            autoFocus: widget.autoFocus,
            magnifyGlassColor:
                widget.magnifyGlassColor ?? widget.magnifyInGlassColor),
        body: Obx(() {
          if (_controller.isLoadingListAsync) {
            return widget.widgetWaiting ??
                const Center(
                  child: CircularProgressIndicator(),
                );
          }

          if (_controller.rxError.value != null) {
            if (widget.widgetErrorBuilder != null) {
              return widget.widgetErrorBuilder!(_controller.rxError.value);
            }

            return Center(
              child: Text(
                'Error: ${_controller.rxError.value}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (widget.rxBoolAuth?.auth.value == false) {
            return widget.rxBoolAuth!.authFalseWidget();
          }

          if (_controller.listSearch.isEmpty &&
              _controller.rxSearch.value.isEmpty &&
              widget.widgetWaiting != null) {
            return widget.widgetWaiting!;
          }

          return widget.obxListBuilder(context, _controller.listSearch.toList(),
              _controller.isModSearch, _controller.highLightIndex.value);
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

class KCallbackAction<T extends Intent> extends CallbackAction<T> {
  // ignore: use_super_parameters
  KCallbackAction({required void Function(T) onInvoke})
      : super(onInvoke: onInvoke);
}

class EscapeIntent extends Intent {
  const EscapeIntent();
}
