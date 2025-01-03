import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/seacher_widget_page_base.dart';

import 'package:search_app_bar_page/search_app_bar_page.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_page_stream_controller.dart';

class SearchAppBarPageStream<T> extends StatefulWidget
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

  /// Parameters para o SearcherGetController

  /// [initialData] List to be filtered by Search.
  /// [widgetWaiting]
  final List<T>? initialData;

  /// [listStream] Just add the Stream and we are already in charge
  /// of working with the data. There is a StreamBuilder in background.
  final Stream<List<T>> listStream;

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

  const SearchAppBarPageStream({
    super.key,
    required this.listStream,
    required this.obxListBuilder,
    this.initialData,
    this.widgetErrorBuilder,
    this.stringFilter,
    this.filter,
    this.sortFunction,
    //this.compareSort,
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
  });

  @override
  // ignore: lines_longer_than_80_chars
  State<SearchAppBarPageStream<T>> createState() =>
      _SearchAppBarPageStreamState<T>();
}

/// State for [StreamBuilderBase].
class _SearchAppBarPageStreamState<T> extends State<SearchAppBarPageStream<T>> {
  StreamSubscription? _subscription;

  // T as List

  bool _haveInitialData = false;
  Widget? _widgetWaiting;

  Worker? _worker;

  late SearcherPageStreamController<T> _controller;

  @override
  void initState() {
    super.initState();

    /*_controller = Get.put(SearcherPageStreamController<T>(
        stringFilter: widget.stringFilter,
        sortCompare: widget.sortCompare,
        filtersType: widget.filtersType)
      ..onInitFilter())!;*/

    _controller = SearcherPageStreamController<T>(
        stringFilter: widget.stringFilter,
        filter: widget.filter,
        sortFunction: widget.sortFunction,
        sortCompare: widget.sortCompare,
        filtersType: widget.filtersType)
      ..onInitFilter();

    _haveInitialData = widget.initialData != null;

    _subscribeStream();
    _buildWidgetsDefault();
    _subscribeSearchQuery();
    if (_haveInitialData) {
      _controller.listFull.addAll(widget.initialData!);
      _controller.sortCompareList(_controller.listFull);
      _controller.initial(_controller.listFull);
    }
  }

  @override
  void didUpdateWidget(SearchAppBarPageStream<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    _controller.stringFilter = widget.stringFilter;
    //_controller.compareSort = widget.compareSort;
    _controller.sortCompare = widget.sortCompare;
    _controller.filtersType = widget.filtersType;
    _controller.sortFunction = widget.sortFunction;
    _controller.filter = widget.filter;
    _controller.onInitFilter();

    if (oldWidget.initialData != widget.initialData) {
      //_initialData = widget.getInitialData;
      _haveInitialData = widget.initialData != null;

      if (_haveInitialData) {
        //_controller.wrabListSearch(widget.initialData);

        //if (widget.initialData!.length > _controller.listFull.length) {
        _controller.listFull.clear();
        _controller.listFull.addAll(widget.initialData!);

        _controller.initial(_controller.listFull);

        //}
      }
    }

    if (_controller.listFull.isNotEmpty) {
      if (_controller.rxSearch.value.isNotEmpty) {
        _controller.afterData(

            /// já tem sort dentro
            _controller.refreshSearchList2(_controller.rxSearch.value));
      } else {
        //if (oldWidget.sortFunction != widget.sortFunction) {
        _controller.sortCompareList(_controller.listFull);

        _controller.afterData(_controller.listFull);
      }
    }

    if (oldWidget.listStream != widget.listStream) {
      if (_subscription != null) {
        _unsubscribeStream();

        _controller.afterDisconnected();
      }

      _subscribeStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SearchAppBar(
            controller: _controller,
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
            magnifyGlassColor: widget.magnifyInGlassColor),
        body: buildBody(),
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
    _unsubscribeStream();
    _controller.onClose();
    if (_worker?.disposed == true) {
      _worker?.dispose();
    }
    _subscription?.cancel();

    //_controller.bancoInit.close();

    super.dispose();
  }

  void _subscribeStream() {
    _subscription = widget.listStream.listen((List<T>? data) {
      if (data == null) {
        if (_controller.listFull.isNotEmpty) {
          _controller.afterData(_controller.listFull);
        } else
          _controller.afterError(Exception('It cannot return null. 😢'));
        return;
      } else {
        if (!_controller.bancoInitValue) {
          // Mostrar lupa do Search
          _controller.bancoInitValue = true;

          //TODO: mudado aqui para 5.0
          /* if (_controller.bancoInit.canUpdate) {
            _controller.bancoInit.close();
          } */

          /* if (_controller.bancoInit.subject.isPaused) {
            _controller.bancoInit.close();
          } */
        }
      }

      _controller.listFull = data;
      _controller.sortCompareList(_controller.listFull);

      if (_controller.rxSearch.value.isNotEmpty) {
        _controller.afterData(
            _controller.refreshSearchList2(_controller.rxSearch.value));
      } else {
        _controller.afterData(_controller.listFull);
      }
    }, onError: (Object error) {
      _controller.afterError(error);
    }, onDone: () {
      _controller.afterDone();
    });
    _controller.afterConnected();
  }

  void _subscribeSearchQuery() {
    _worker = debounce(_controller.rxSearch, (String? query) {
      if (query!.isNotEmpty) {
        _controller.afterData(_controller.refreshSearchList2(query));
      } else {
        _controller.afterData(_controller.listFull);
      }
    }, time: const Duration(milliseconds: 350));
  }

  void _unsubscribeStream() {
    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
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

  void _buildWidgetsDefault() {
    if (widget.widgetWaiting == null) {
      _widgetWaiting = const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
  }
}
