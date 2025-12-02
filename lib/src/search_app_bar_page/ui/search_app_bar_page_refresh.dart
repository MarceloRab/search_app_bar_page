import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_page_refresh_controller.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/seacher_widget_page_base.dart';

class SearchAppBarPageRefresh<T> extends StatefulWidget
    implements SearcherScaffoldBase {
  /// Parameters do SearchAppBar

  final Widget? searchAppBartitle;
  final bool searchAppBarcenterTitle;
  final IconThemeData? searchAppBarIconTheme;
  final Color? searchAppBarbackgroundColor;
  final Color? searchAppBarModeSearchBackgroundColor;
  final Color? searchAppBarElementsColor;

  final String? searchAppBarhintText;
  final bool searchAppBarflattenOnSearch;
  final TextCapitalization searchAppBarcapitalization;
  final List<Widget> searchAppBaractions;
  final double searchAppBarElevation;
  final TextInputType? searchAppBarKeyboardType;

  /// [magnifyInGlassColor] Changes the color of the magnifying glass.
  /// Keeps IconTheme color by default.
  final Color? magnifyInGlassColor;

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
  final Color? searchTextColor;
  final double searchTextSize;

  /// Parametros para o SearcherGetController

  /// [initialData] List to be filtered by Search.
  /// These widgets will not be displayed. [widgetOffConnectyWaiting] and
  /// [widgetWaiting]
  final List<T>? initialData;

  /// [functionRefresh] Just add the future function and we are already
  /// in charge of working with the data. There is a FutureBuilder
  /// in background.
  final FunctionRefresh<T> functionRefresh;

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

  ///If you want your list to be sorted, add the function on.
  /// Example: (Person a, Person b) => a.name.compareTo(b.name),
  /// This list will be ordered by the object name parameter.
  //final Compare<T> compareSort;

  ///[sortCompare] Your list will be ordered by the same function
  ///[stringFilter]. True by default.
  final bool sortCompare;

  ///  [rxBoolAuth] Insert your RxBool here that changes with the auth
  /// status to have reactivity.
  final RxBoolAuth? rxBoolAuth;

  final double refreshStrokeWidth;
  final double refreshDisplacement;

  /// The progress indicator's foreground color. The current theme's
  /// [ThemeData.floatingActionButtonTheme] by default.
  final Color? refreshColor;

  /// The progress indicator's background color. The current theme's
  /// [ThemeData.canvasColor] by default.
  final Color? refreshBackgroundColor;
  final RefreshIndicatorTriggerMode refreshTriggerMode;

  final bool autoFocus;

  //final OnSubmitted<T>? onSubmit;

  const SearchAppBarPageRefresh({
    Key? key,
    required this.functionRefresh,
    required this.obxListBuilder,
    //this.onSubmit,
    this.initialData,
    this.widgetErrorBuilder,
    this.stringFilter,
    //this.compareSort,
    this.sortCompare = true,
    this.rxBoolAuth,
    this.filtersType,
    this.searchAppBartitle,
    this.searchAppBarcenterTitle = false,
    this.searchAppBarIconTheme,
    this.searchAppBarbackgroundColor,
    this.searchAppBarModeSearchBackgroundColor,
    this.searchAppBarElementsColor,
    this.searchAppBarhintText,
    this.searchAppBarflattenOnSearch = false,
    this.searchAppBarcapitalization = TextCapitalization.none,
    this.searchAppBaractions = const <Widget>[],
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
    this.refreshStrokeWidth = 2.0,
    this.refreshBackgroundColor,
    this.refreshDisplacement = 40.0,
    this.refreshColor,
    this.refreshTriggerMode = RefreshIndicatorTriggerMode.onEdge,
    this.autoFocus = true,
  }) : super(key: key);

  @override
  State<SearchAppBarPageRefresh<T>> createState() =>
      _SearchAppBarPageRefreshState<T>();
}

class _SearchAppBarPageRefreshState<T>
    extends State<SearchAppBarPageRefresh<T>> {
  // T as List

  bool _haveInitialData = false;

  bool downConnectyWithoutData = false;

  late final Widget? _widgetConnecty;
  late final Widget? _widgetWaiting;

  Worker? _worker;

  late SearcherPageRefreshController<T> _controller;

  Object? _activeCallbackIdentity;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    /*_controller = Get.put(SearcherPageRefreshController<T>(
        stringFilter: widget.stringFilter,
        sortCompare: widget.sortCompare,
        filtersType: widget.filtersType)
      ..onInitFilter())!;*/

    _controller = SearcherPageRefreshController<T>(
        stringFilter: widget.stringFilter,
        sortCompare: widget.sortCompare,
        filtersType: widget.filtersType)
      ..onInitFilter();

    _haveInitialData = widget.initialData != null;

    _subscribe(isRefresh: false);
    _subscribreSearhQuery();
    if (_haveInitialData) {
      _controller.listFuture.addAll(widget.initialData!);
      _controller.sortCompareList(_controller.listFuture);
      _controller.initial(_controller.listFuture);
    }
  }

  @override
  void didUpdateWidget(SearchAppBarPageRefresh<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    _controller.stringFilter = widget.stringFilter;
    //_controller.compareSort = widget.compareSort;
    _controller.sortCompare = widget.sortCompare;
    _controller.filtersType = widget.filtersType;
    _controller.onInitFilter();

    if (oldWidget.initialData != widget.initialData) {
      //_initialData = widget.getInitialData;
      _haveInitialData = widget.initialData != null;

      if (_haveInitialData) {
        //_controller.wrabListSearch(widget.initialData);
        downConnectyWithoutData = false;

        if (widget.initialData!.length > _controller.listFuture.length) {
          _controller.listFuture.clear();
          _controller.listFuture.addAll(widget.initialData!);
          _controller.sortCompareList(_controller.listFuture);
          _controller.initial(_controller.listFuture);
        }
      }
    }

    if (_controller.listFuture.isNotEmpty) {
      if (_controller.rxSearch.value.isNotEmpty) {
        _controller.afterData(
            _controller.refreshSeachList2(_controller.rxSearch.value));
      } else {
        _controller.sortCompareList(_controller.listFuture);
        _controller.afterData(_controller.listFuture);
      }
    }

    if (oldWidget.functionRefresh != widget.functionRefresh) {
      if (_controller.snapshot.connectionState != ConnectionState.active) {
        if (_activeCallbackIdentity != null) {
          _unsubscribe();
          _controller.afterConnected();
        }
        _subscribe(isRefresh: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SearchAppBar<T>(
            controller: _controller,
            //onSubmit: widget.onSubmit,
            title: widget.searchAppBartitle,
            centerTitle: widget.searchAppBarcenterTitle,
            elevation: widget.searchAppBarElevation,
            iconTheme: widget.searchAppBarIconTheme,
            backgroundColor: widget.searchAppBarbackgroundColor,
            searchBackgroundColor: widget.searchAppBarModeSearchBackgroundColor,
            searchElementsColor: widget.searchAppBarElementsColor,
            hintText: widget.searchAppBarhintText,
            flattenOnSearch: widget.searchAppBarflattenOnSearch,
            capitalization: widget.searchAppBarcapitalization,
            actions: widget.searchAppBaractions,
            keyboardType: widget.searchAppBarKeyboardType,
            searchTextSize: widget.searchTextSize,
            searchTextColor: widget.searchTextColor,
            autoFocus: widget.autoFocus,
            magnifyGlassColor: widget.magnifyInGlassColor),
        body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              _subscribe(isRefresh: true);
            },
            child: buildBody()),
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

  Widget buildBody() {
    if (downConnectyWithoutData) {
      // Apenas anuncia quando nao tem a primeira data e esta sem conexao
      return _widgetConnecty!;
    }

    return Obx(() {
      if (widget.rxBoolAuth?.auth.value == false) {
        return widget.rxBoolAuth!.authFalseWidget();
      }
      if (_controller.snapshot.connectionState == ConnectionState.waiting) {
        return _widgetWaiting!;
      }

      if (_controller.snapshot.hasError) {
        return buildWidgetError(_controller.snapshot.error);
      }

      //final isListFull = widget.searcher.rxSearch.value.isEmpty;
      return widget.obxListBuilder(
          context, _controller.snapshot.data!, _controller.isModSearch);
    });
  }

  @override
  void dispose() {
    _unsubscribe();
    _controller.onClose();
    if (_worker?.disposed == true) {
      _worker?.dispose();
    }

    super.dispose();
  }

  void _subscribe({required bool isRefresh}) {
    final Object callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;
    widget.functionRefresh().then<void>((List<T> data) {
      if (_activeCallbackIdentity == callbackIdentity) {
        if (_controller.listFuture.isNotEmpty) {
          _controller.afterData(_controller.listFuture);
        }
      }

      if (!_controller.bancoInitValue) {
        // Mostrar lupa do Search
        _controller.bancoInitValue = true;

        //TODO: mudado aqui para 5.0
        /* if (_controller.bancoInit.canUpdate) {
          _controller.bancoInit.close();
        } */

        /* if (_controller.bancoInit.subject.isClosed) {
          _controller.bancoInit.close();
        } */
      }

      downConnectyWithoutData = false;

      _controller.listFuture = data;
      _controller.sortCompareList(_controller.listFuture);

      if (_controller.rxSearch.value.isNotEmpty) {
        _controller.afterData(
            _controller.refreshSeachList2(_controller.rxSearch.value));
      } else {
        _controller.afterData(_controller.listFuture);
      }
    }, onError: (Object error, StackTrace stackTrace) {
      if (_activeCallbackIdentity == callbackIdentity) {
        _controller.afterError(error);
      }
    });

    if (!isRefresh) _controller.afterConnected();
  }

  void _subscribreSearhQuery() {
    _worker = debounce(_controller.rxSearch, (String? query) {
      if (query!.isNotEmpty) {
        _controller.afterData(_controller.refreshSeachList2(query));
      } else {
        _controller.afterData(_controller.listFuture);
      }
    }, time: const Duration(milliseconds: 350));
  }

  void _unsubscribe() {
    _activeCallbackIdentity = null;
  }

  Widget buildWidgetError(Object? error) {
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
      return widget.widgetErrorBuilder!(error);
    }

    //return _widgetError;
  }
}
