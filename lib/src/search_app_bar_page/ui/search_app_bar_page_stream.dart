import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/connecty_controller.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/filters_type.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/seacher_widget_page_base.dart';

import '../../../search_app_bar_page.dart';
import '../controller/searcher_page_stream_controller.dart';

class SearchAppBarPageStream<T> extends StatefulWidget
    implements SeacherScaffoldBase {
  /// Paramentros do SearchAppBar

  final Widget? searchAppBartitle;
  final bool searchAppBarcenterTitle;
  final IconThemeData? searchAppBariconTheme;
  final Color? searchAppBarbackgroundColor;
  final Color? searchAppBarModeSearchBackgroundColor;
  final Color? searchAppBarElementsColor;

  /// [searchAppBarIconConnectyOffAppBarColor] You can change the color of
  /// [iconConnectyOffAppBar]. By default = Colors.redAccent.
  final Color? searchAppBarIconConnectyOffAppBarColor;
  final String? searchAppBarhintText;
  final bool searchAppBarflattenOnSearch;
  final TextCapitalization searchAppBarcapitalization;
  final List<Widget> searchAppBaractions;
  final double searchAppBarElevation;
  final TextInputType? searchAppBarKeyboardType;

  /// [magnifyinGlassColor] Changes the color of the magnifying glass.
  /// Keeps IconTheme color by default.
  final Color? magnifyinGlassColor;

  ///[iconConnectyOffAppBar] Appears when the connection status is off.
  ///There is already a default icon. If you don't want to present a choice
  ///[hideDefaultConnectyIconOffAppBar] = true; If you want to have a
  ///custom icon, do [hideDefaultConnectyIconOffAppBar] = true; and set the
  ///[iconConnectyOffAppBar]`.
  final bool hideDefaultConnectyIconOffAppBar;

  /// [iconConnectyOffAppBar] Displayed on the AppBar when the internet
  /// connection is switched off.
  /// It is always the closest to the center.
  final Widget? iconConnectyOffAppBar;

  ///  [iconConnectyOffAppBar] Aparece quando o status da conexao é off.
  ///  já existe um icone default. Caso nao queira apresentar escolha
  ///  [hideDefaultConnectyIconOffAppBar] = false;

  /// Parametros para o Scaffold

  ///  [widgetOffConnectyWaiting] Apenas mostra algo quando esta sem conexao
  ///  e ainda nao tem o primeiro valor da stream. Se a conexao voltar
  ///  passa a mostrar o [widgetWaiting] até apresentar o primeiro dado
  final Widget? widgetWaiting;
  final Widget? widgetOffConnectyWaiting;

  /// [widgetErrorBuilder] Widget built by the Object error returned by the
  /// [listStream] error.
  final WidgetsErrorBuilder? widgetErrorBuilder;

  /// [searchePageFloatingActionButton] , [searchePageFloatingActionButton] ,
  /// [searchePageFloatingActionButtonLocation] ,
  /// [searchePageFloatingActionButtonAnimator]  ...
  /// ...
  /// are passed on to the Scaffold.
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

  /// [initialData] List to be filtered by Search.
  /// These widgets will not be displayed. [widgetOffConnectyWaiting] and
  /// [widgetWaiting]
  final List<T>? initialData;

  /// [listStream] Just pass the Stream and we are already in charge
  /// of working with the data. There is a StremBuilder in background.
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

  ///If you want your list to be sorted, pass the function on.
  /// Example: (Person a, Person b) => a.name.compareTo(b.name),
  /// This list will be ordered by the object name parameter.
  //final Compare<T> compareSort;

  ///[sortCompare] Your list will be ordered by the same function
  ///[stringFilter]. True by default.
  final bool sortCompare;

  ///  [rxBoolAuth] Insert your RxBool here that changes with the auth
  /// status to have reactivity.
  final RxBoolAuth? rxBoolAuth;

  const SearchAppBarPageStream({
    Key? key,
    required this.listStream,
    required this.obxListBuilder,
    this.initialData,
    this.widgetWaiting,
    this.widgetErrorBuilder,
    this.stringFilter,
    //this.compareSort,
    this.sortCompare = true,
    this.rxBoolAuth,
    this.filtersType,
    this.searchAppBartitle,
    this.searchAppBarcenterTitle = false,
    this.searchAppBariconTheme,
    this.searchAppBarbackgroundColor,
    this.searchAppBarModeSearchBackgroundColor,
    this.searchAppBarElementsColor,
    this.searchAppBarIconConnectyOffAppBarColor,
    this.searchAppBarhintText,
    this.searchAppBarflattenOnSearch = false,
    this.searchAppBarcapitalization = TextCapitalization.none,
    this.searchAppBaractions = const <Widget>[],
    this.searchAppBarElevation = 4.0,
    this.searchAppBarKeyboardType,
    this.magnifyinGlassColor,
    this.hideDefaultConnectyIconOffAppBar = false,
    this.iconConnectyOffAppBar,
    this.widgetOffConnectyWaiting,
    this.searchePageFloatingActionButton,
    this.searchePageFloatingActionButtonLocation,
    this.searchePageFloatingActionButtonAnimator,
    this.searchePagePersistentFooterButtons,
    this.searchePageDrawer,
    this.searchePageEndDrawer,
    this.searchePageBottomNavigationBar,
    this.searchePageBottomSheet,
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
  }) : super(key: key);

  @override
  State<SearchAppBarPageStream<T>> createState() =>
      _SearchAppBarPageStreamState<T>();
}

/// State for [StreamBuilderBase].
class _SearchAppBarPageStreamState<T> extends State<SearchAppBarPageStream<T>> {
  StreamSubscription? _subscription;
  StreamSubscription? _subscriptionConnecty;

  // T as List

  bool _haveInitialData = false;

  late ConnectController _connectyController;
  bool downConnectyWithoutData = false;

  Widget? _widgetConnecty;
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
        sortCompare: widget.sortCompare,
        filtersType: widget.filtersType)
      ..onInitFilter();

    _haveInitialData = widget.initialData != null;

    _subscribeStream();
    _subscribreSearhQuery();
    if (!_haveInitialData) {
      _subscribeConnecty();
    } else {
      _controller.listFull.addAll(widget.initialData!);
      _controller.sortCompareList(_controller.listFull);
      _controller.initial(_controller.listFull);
    }

    buildWidgetsDefault();
  }

  @override
  void didUpdateWidget(SearchAppBarPageStream<T> oldWidget) {
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
        _unsubscribeConnecty();

        if (widget.initialData!.length > _controller.listFull.length) {
          _controller.listFull.clear();
          _controller.listFull.addAll(widget.initialData!);
          _controller.sortCompareList(_controller.listFull);
          _controller.initial(_controller.listFull);
        }
      } else if (_controller.listFull.isEmpty &&
          _subscriptionConnecty != null) {
        _subscribeConnecty();
      }
    }

    if (_controller.listFull.isNotEmpty) {
      if (_controller.rxSearch.value.isNotEmpty) {
        _controller.afterData(
            _controller.refreshSeachList2(_controller.rxSearch.value));
      } else {
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
            title: widget.searchAppBartitle,
            centerTitle: widget.searchAppBarcenterTitle,
            elevation: widget.searchAppBarElevation,
            iconTheme: widget.searchAppBariconTheme,
            backgroundColor: widget.searchAppBarbackgroundColor,
            searchBackgroundColor: widget.searchAppBarModeSearchBackgroundColor,
            iconConnectyOffAppBarColor:
                widget.searchAppBarIconConnectyOffAppBarColor,
            searchElementsColor: widget.searchAppBarElementsColor,
            hintText: widget.searchAppBarhintText,
            flattenOnSearch: widget.searchAppBarflattenOnSearch,
            capitalization: widget.searchAppBarcapitalization,
            actions: widget.searchAppBaractions,
            hideDefaultConnectyIconOffAppBar:
                widget.hideDefaultConnectyIconOffAppBar,
            iconConnectyOffAppBar: widget.iconConnectyOffAppBar,
            keyboardType: widget.searchAppBarKeyboardType,
            magnifyinGlassColor: widget.magnifyinGlassColor),
        body: buildBody(),
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
    _unsubscribeStream();
    _unsubscribeConnecty();
    _controller.onClose();
    if (_worker?.disposed == true) {
      _worker?.dispose();
    }
    _subscription?.cancel();
    _subscriptionConnecty?.cancel();

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
          if (_controller.bancoInit.canUpdate) {
            _controller.bancoInit.close();
          }
        }
      }
      downConnectyWithoutData = false;
      _unsubscribeConnecty();

      _controller.listFull = data;
      _controller.sortCompareList(_controller.listFull);

      if (_controller.rxSearch.value.isNotEmpty) {
        _controller.afterData(
            _controller.refreshSeachList2(_controller.rxSearch.value));
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

  void _subscribreSearhQuery() {
    _worker = debounce(_controller.rxSearch, (String? query) {
      if (query!.isNotEmpty) {
        _controller.afterData(_controller.refreshSeachList2(query));
      } else {
        _controller.afterData(_controller.listFull);
      }
    }, time: const Duration(milliseconds: 350));
  }

  void _subscribeConnecty() {
    _connectyController = ConnectController();
    _subscriptionConnecty =
        _connectyController.rxConnect.stream.listen((isConnected) {
      if (!isConnected && (!_haveInitialData)) {
        //lançar _widgetConnecty
        setState(() {
          downConnectyWithoutData = true;
        });
      } else if (isConnected && (!_haveInitialData)) {
        setState(() {
          downConnectyWithoutData = false;
          _controller.afterConnected();
        });
      }
    });
  }

  void _unsubscribeConnecty() {
    if (_subscriptionConnecty != null) {
      _subscriptionConnecty!.cancel();
      _subscriptionConnecty = null;
      _connectyController.onClose();
    }
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

  void buildWidgetsDefault() {
    if (widget.widgetOffConnectyWaiting == null) {
      _widgetConnecty = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Check connection...',
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      );
    } else {
      _widgetConnecty = widget.widgetOffConnectyWaiting;
    }

    if (widget.widgetWaiting == null) {
      _widgetWaiting = Center(
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
    } else {
      _widgetWaiting = widget.widgetWaiting;
    }
  }
}
