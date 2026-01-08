import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_page_controller_variable.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/core/search_app_bar/search_app_bar.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/infra/rx_get_type.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/seacher_widget_page_base.dart';

/// Use this class when you cannot use a full list. List with varied sizes.

class SearchAppBarPageVariableList<T> extends StatefulWidget
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
  /// [listVariableFunction].
  final Widget? widgetWaiting;

  /// [widgetErrorBuilder] Widget built by the Object error returned by the
  /// [listVariableFunction] or [onAsyncError].
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

  /// [obxListBuilder] Function applied when it is filtered.
  final WidgetsListBuilder<T> obxListBuilder;

  /// [listVariableFunction] Function to fetch list items asynchronously or no.
  /// Return a list of items from a query. Filter however you want.

  final ListVariableFunction<T>? listVariableFunction;

  /// [onChanged] Function called when the search text changes.
  final ValueChanged<String>? onChangedQuery;

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

  //final VoidCallback? onCancelSearch;

  const SearchAppBarPageVariableList(
      {super.key,

      /// Parameters para o SearcherGetController

      required this.obxListBuilder,
      required this.listVariableFunction,
      this.onChangedQuery,
      this.onSubmit,
      this.onEnter,
      //this.onCancelSearch,
      this.rxBoolAuth,
      this.autoFocus = true,
      this.widthLargeScreenThreshold = 1100.0,

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
      this.restorationId});

  @override
  SearchAppBarPageStateVariableList<T> createState() =>
      SearchAppBarPageStateVariableList<T>();
}

class SearchAppBarPageStateVariableList<T>
    extends State<SearchAppBarPageVariableList<T>> {
  late final SearcherPageControllerVariable<T> _controller;

  @override
  void initState() {
    super.initState();

    _controller = SearcherPageControllerVariable<T>(
      listAsync: widget.listVariableFunction,
      onChangedQuery: widget.onChangedQuery,
    )..onReady();

    _keyboardHandler = _handleGlobalKeyEvent;
    HardwareKeyboard.instance.addHandler(_keyboardHandler);
  }

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
            widget.onEnter?.call(_controller.listSearch.toList(),
                _controller.highLightIndex.value);
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

  void clearSearch() {
    _controller.onCancelSearch?.call();
    _controller.onChangedQuery?.call('');
    _controller.onSearchList([]);
    _controller.highLightIndex.value = 0;
  }

  void initShowSearch() {
    _controller.initShowSearch?.call(null);
    _controller.onChangedQuery?.call('');
    _controller.onSearchList([]);
    _controller.rxSearch.value = '';
    _controller.highLightIndex.value = 0;
  }

  void onSearchList(List<T> list) {
    _controller.onSearchList(list);
  }

  bool get isModSearch => _controller.isModSearch;

  void onEnter() {
    //* gera sobreposição caso haja outro Textfield na tela
    /* if (widget.onEnter != null) {
      final list = _controller.isModSearch ? _controller.listSearch : _controller.listFull;
      widget.onEnter!(list, _controller.highLightIndex.value);
    } */

    if (widget.onEnter != null && !_controller.isModSearch) {
      widget.onEnter!(
          _controller.listSearch.toList(), _controller.highLightIndex.value);
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

class KCallbackActionVariable<T extends Intent> extends CallbackAction<T> {
  // ignore: use_super_parameters
  KCallbackActionVariable({required void Function(T) onInvoke})
      : super(onInvoke: onInvoke);
}

class EscapeIntentVariable extends Intent {
  const EscapeIntentVariable();
}
