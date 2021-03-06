import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/get_stream_controller.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/functions.dart';

import 'infra/rx_get_type.dart';

class GetStreamWidget<T> extends StatefulWidget {
  ///[stream] Just pass your stream and you will receive streamObject which is
  ///snapshot.data to build your page.
  final Stream<T> stream;

  ///  [rxBoolAuth] Insert your RxBool here that changes with the auth
  /// status to have reactivity.
  final RxBoolAuth rxBoolAuth;

  /// [widgetErrorBuilder] Widget built by the Object error returned by the
  /// [stream] error.
  final WidgetsErrorBuilder widgetErrorBuilder;

  /// [obxWidgetBuilder] This function starts every time we receive
  ///snapshot.data through the stream. To set up your page, you receive
  /// the context, the streamObject which is snapshot.data.
  final GetWidgetBuilder<T> obxWidgetBuilder;

  /// Start showing [widgetWaiting] until it shows the first data
  final Widget widgetWaiting;

  final T initialData;

  const GetStreamWidget(
      {Key key,
      @required this.stream,
      this.widgetErrorBuilder,
      this.obxWidgetBuilder,
      this.widgetWaiting,
      this.initialData,
      this.rxBoolAuth})
      : super(key: key);

  @override
  _GetStreamWidgetState<T> createState() => _GetStreamWidgetState<T>();
}

class _GetStreamWidgetState<T> extends State<GetStreamWidget<T>> {
  StreamSubscription<T> _subscription;

  GetStreamController<T> _controller;

  Widget _widgetWaiting;

  @override
  void initState() {
    // _controller = GetStreamController();
    _controller = Get.put<GetStreamController<T>>(GetStreamController());
    super.initState();

    if (widget.initialData != null) {
      _controller.initial(widget.initialData);
    }

    _subscribeStream();
    _buildWidgetsDefault();
  }

  @override
  void dispose() {
    _controller.onClose();
    _unsubscribeStream();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GetStreamWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialData != widget.initialData) {
      if (_controller.snapshot.connectionState == ConnectionState.none) {
        _controller.initial(widget.initialData);
      } else {
        _controller.afterData(widget.initialData);
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
      } else {
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
      _subscription.cancel();
      _subscription = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.snapshot.connectionState == ConnectionState.waiting) {
        return _widgetWaiting;
      }

      if (_controller.snapshot.hasError) {
        return buildWidgetError(_controller.snapshot.error);
      }

      return widget.obxWidgetBuilder(context, _controller.snapshot.data);
    });
  }

  Widget buildWidgetError(Object error) {
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
      return widget.widgetErrorBuilder(error);
    }
  }

  void _buildWidgetsDefault() {
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
