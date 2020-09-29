import 'dart:async';

import 'package:flutter/material.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/connecty_controller.dart';

import '../controller/searcher_page_stream_controller.dart';

typedef WidgetConnecty = Widget Function();

abstract class StreamSearcherGetxBuilderBase<T, S> extends StatefulWidget {
  const StreamSearcherGetxBuilderBase(
      {Key key,
      @required this.searcher,
      @required this.stream,
      @required this.widgetConnecty})
      : super(key: key);

  // nao de pode colocar final. Após um setState precisa refaze-la
  // vide o metodo didUpdateWidget
  // T as List
  final Stream<T> stream;
  final SearcherPageStreamController searcher;

  S initial();

  T get haveInitialData;

  S afterConnected(S current) => current;

  S afterData(S current, T data);

  S afterError(S current, Object error) => current;

  S afterDone(S current) => current;

  S afterDisconnected(S current) => current;

  //final WidgetConnecty widgetConnecty;
  final Widget widgetConnecty;

  Widget build(BuildContext context, S currentSummary);

  @override
  State<StreamSearcherGetxBuilderBase<T, S>> createState() =>
      _StreamSearcherGetxBuilderBase<T, S>();
}

/// State for [StreamBuilderBase].
class _StreamSearcherGetxBuilderBase<T, S>
    extends State<StreamSearcherGetxBuilderBase<T, S>> {
  StreamSubscription<T> _subscription;
  StreamSubscription _subscriptionConnecty;
  S _summary;

  // T as List
  T _data;
  bool _haveData;

  ConnectyController _connectyController;
  bool downConnectyWithoutData = false;

  Widget _widgetConnecty;

  @override
  void initState() {
    super.initState();
    _data = widget.haveInitialData;
    _haveData = _data != null;
    _summary = widget.initial();
    _subscribeStream();
    if (!_haveData) {
      _connectyController = ConnectyController();
      _subscribeConnecty();
    } else {
      widget.searcher.wrabListSearch(_data as List);
    }

    if (widget.widgetConnecty == null) {
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
      _widgetConnecty = widget.widgetConnecty;
    }
  }

  @override
  void didUpdateWidget(StreamSearcherGetxBuilderBase<T, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      if (_subscription != null) {
        _unsubscribeStream();
        //Necessário para resolver após o setState
        //widget.stream = oldWidget.stream.asBroadcastStream();
        _summary = widget.afterDisconnected(_summary);
      }

      _subscribeStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (downConnectyWithoutData) {
      // Apenas anuncia quando nao tem a primeira data e esta sem conexao
      return _widgetConnecty;
    }

    return widget.build(context, _summary);
  }

  @override
  void dispose() {
    _unsubscribeStream();
    _unsubscribeConnecty();
    widget.searcher.onClose();
    super.dispose();
  }

  void _subscribeStream() {
    _subscription = widget.stream.listen((data) {
      downConnectyWithoutData = false;
      _unsubscribeConnecty();
      // reflexo no searchList
      widget.searcher.wrabListSearch(data as List);
      // quando haveInitialData = true a mudança é assumida pelo Obx
      // na classe StreamSearchBuilder
      if (!widget.searcher.haveInitialData) {
        setState(() {
          _summary = widget.afterData(_summary, data);
        });
      } else {
        _summary = widget.afterData(_summary, data);
      }
    }, onError: (Object error) {
      setState(() {
        _summary = widget.afterError(_summary, error);
      });
    }, onDone: () {
      setState(() {
        _summary = widget.afterDone(_summary);
      });
    });
    _summary = widget.afterConnected(_summary);
  }

  void _subscribeConnecty() {
    _subscriptionConnecty =
        _connectyController.connectyStream.listen((bool isConnected) {
      if (!isConnected && (!_haveData)) {
        //lançar _widgetConnecty
        setState(() {
          downConnectyWithoutData = true;
        });
      } else if (isConnected && (!_haveData)) {
        setState(() {
          downConnectyWithoutData = false;
          _summary = widget.afterConnected(_summary);
        });
      }
    });
  }

  void _unsubscribeConnecty() {
    if (_subscriptionConnecty != null) {
      _subscriptionConnecty.cancel();
      _subscriptionConnecty = null;
      _connectyController.onClose();
    }
  }

  void _unsubscribeStream() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }
}
