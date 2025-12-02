import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/get_stream_controller.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/functions.dart';

import 'package:search_app_bar_page/src/search_app_bar_page/ui/infra/rx_get_type.dart';

class GetStreamPage<T> extends StatefulWidget {
  ///  [rxBoolAuth] Insert your RxBool here that changes with the auth
  /// status to have reactivity.
  final RxBoolAuth? rxBoolAuth;

  ///[stream] Just add your stream and you will receive streamObject which is
  ///snapshot.data to build your page.
  final Stream<T> stream;

  final T? initialData;

  /// [widgetErrorBuilder] Widget built by the Object error returned by the
  /// [stream] error.
  final WidgetsErrorBuilder? widgetErrorBuilder;

  /// [obxWidgetBuilder] This function starts every time we receive
  ///snapshot.data through the stream. To set up your page, you receive
  /// the context, the streamObject which is snapshot.data.
  final GetWidgetBuilder<T> obxWidgetBuilder;

  /// [floatingActionButton] , [pageDrawer] ,
  /// [floatingActionButtonLocation] ,
  /// [floatingActionButtonAnimator]  ...
  /// are passed on to the Scaffold.

  final Widget? floatingActionButton;

  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final Widget? pageDrawer;
  final Widget? pageEndDrawer;
  final Widget? pageBottomNavigationBar;
  final Widget? pageBottomSheet;
  final Color? pageBackgroundColor;

  final String? restorationId;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;

  ///AppBar parameters

  final Color? appBarBackgroundColor;
  final Widget? title;
  final bool centerTitle;
  final IconThemeData? iconTheme;
  final double elevation;
  final List<Widget> actions;

  /// [iconConnectyOffAppBar] Displayed on the AppBar when the internet
  /// connection is switched off.
  /// It is always the closest to the center.
  final Widget? iconConnectyOffAppBar;
  final Color? iconConnectyOffAppBarColor;

  ///[iconConnectyOffAppBar] Appears when the connection status is off.
  ///There is already a default icon. If you don't want to present a choice
  ///[hideDefaultConnectyIconOffAppBar] = true; If you want to have a
  ///custom icon, do [hideDefaultConnectyIconOffAppBar] = true; and set the
  ///[iconConnectyOffAppBar]`.

  const GetStreamPage(
      {super.key,
      required this.stream,
      required this.obxWidgetBuilder,
      this.initialData,
      this.rxBoolAuth,
      this.widgetErrorBuilder,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.floatingActionButtonAnimator,
      this.persistentFooterButtons,
      this.pageDrawer,
      this.pageEndDrawer,
      this.pageBottomNavigationBar,
      this.pageBottomSheet,
      this.pageBackgroundColor,
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
      this.appBarBackgroundColor,
      this.title,
      this.centerTitle = false,
      this.elevation = 4.0,
      this.actions = const <Widget>[],
      this.iconTheme,
      this.iconConnectyOffAppBar,
      this.iconConnectyOffAppBarColor});

  @override
  _GetStreamPageState<T> createState() => _GetStreamPageState<T>();
}

class _GetStreamPageState<T> extends State<GetStreamPage<T>> {
  StreamSubscription? _subscription;

  late GetStreamController<T> _controller;

  Widget? _widgetWaiting;

  bool downConnectWithoutData = false;

  late Widget? _widgetConnect;

  StreamSubscription? _subscriptionConnecty;

  bool haveData = false;

  Widget? _iconConnectOffAppBar;

  @override
  void initState() {
    //_controller = GetStreamController();
    _controller = Get.put<GetStreamController<T>>(GetStreamController());
    super.initState();

    if (widget.initialData != null) {
      _controller.initial(widget.initialData!);
    }
    _subscribeStream();
  }

  @override
  void dispose() {
    _controller.onClose();
    _unsubscribeStream();
    _subscription?.cancel();
    _subscriptionConnecty?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GetStreamPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialData != widget.initialData) {
      if (_controller.snapshot.connectionState == ConnectionState.none) {
        _controller.initial(widget.initialData!);
      } else {
        _controller.afterData(widget.initialData!);
      }
    }

    if (oldWidget.stream != widget.stream) {
      if (_subscription != null) {
        _unsubscribeStream();

        _controller.afterDisconnected();
      }

      _subscribeStream();
    }
  }

  void _subscribeStream() {
    _subscription = widget.stream.listen((data) {
      if (data == null) {
        _controller.afterError(Exception('It cannot return null. 😢'));
        return;
      } else {
        //objesctStream ??= data;
        haveData = true;
        downConnectWithoutData = false;
        _controller.afterData(data);
      }
    }, onError: (Object error) {
      _controller.afterError(error);
    }, onDone: () {
      _controller.afterDone();
    });

    //_controller.afterConnected();
  }

  void _unsubscribeStream() {
    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    final List<Widget> increasedActions = [];
    increasedActions.addAll(widget.actions);

    if (_iconConnectOffAppBar != null) {
      increasedActions.insert(0, _iconConnectOffAppBar!);
    }

    return AppBar(
      backgroundColor:
          //widget.appBarbackgroundColor ?? Theme.of(context).appBarTheme.color,
          widget.appBarBackgroundColor ??
              Theme.of(context).appBarTheme.foregroundColor,
      iconTheme: widget.iconTheme ?? Theme.of(context).appBarTheme.iconTheme,
      title: widget.title,
      elevation: widget.elevation,
      centerTitle: widget.centerTitle,
      actions: increasedActions as List<Widget>?,
    );
  }

  Widget buildBody() {
    return Obx(() {
      if (widget.rxBoolAuth?.auth.value == false) {
        return widget.rxBoolAuth!.authFalseWidget();
      }
      if (downConnectWithoutData) {
        /// Apenas anuncia quando nao tem a primeira data e esta sem conexao
        return _widgetConnect!;
      }

      if (_controller.snapshot.connectionState == ConnectionState.waiting) {
        return _widgetWaiting!;
      }

      if (_controller.snapshot.hasError) {
        return buildWidgetError(_controller.snapshot.error);
      }

      return widget.obxWidgetBuilder(context, _controller.snapshot.data!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        body: buildBody(),
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
        persistentFooterButtons: widget.persistentFooterButtons,
        drawer: widget.pageDrawer,
        endDrawer: widget.pageEndDrawer,
        bottomNavigationBar: widget.pageBottomNavigationBar,
        bottomSheet: widget.pageBottomSheet,
        backgroundColor: widget.pageBackgroundColor,
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
  }
}
