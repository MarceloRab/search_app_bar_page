import 'dart:async';

import 'package:flutter/material.dart';

import '../controller/searcher_page_stream_controller.dart';

abstract class StreamSearcherGetxBuilderBase<T, S> extends StatefulWidget {
  const StreamSearcherGetxBuilderBase({this.stream, Key key, this.searcher})
      : super(key: key);

  final Stream<T> stream;
  final SearcherPageStreamController searcher;

  S initial();

  S afterConnected(S current) => current;

  S afterData(S current, T data);

  S afterError(S current, Object error) => current;

  S afterDone(S current) => current;

  S afterDisconnected(S current) => current;

  Widget build(BuildContext context, S currentSummary);

  @override
  State<StreamSearcherGetxBuilderBase<T, S>> createState() =>
      _StreamSearcherGetxBuilderBase<T, S>();
}

/// State for [StreamBuilderBase].
class _StreamSearcherGetxBuilderBase<T, S>
    extends State<StreamSearcherGetxBuilderBase<T, S>> {
  StreamSubscription<T> _subscription;
  S _summary;

  @override
  void initState() {
    super.initState();
    _summary = widget.initial();
    _subscribe();
  }

  @override
  void didUpdateWidget(StreamSearcherGetxBuilderBase<T, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      if (_subscription != null) {
        _unsubscribe();
        _summary = widget.afterDisconnected(_summary);
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(context, _summary);

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.stream != null) {
      _subscription = widget.stream.listen((T data) {
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
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }
}
