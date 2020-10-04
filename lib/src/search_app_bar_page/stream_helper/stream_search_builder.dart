import 'package:flutter/material.dart';
import 'package:get_state_manager/get_state_manager.dart';

import '../controller/searcher_page_stream_controller.dart';
import '../filters/functions_filters.dart';
import 'stream_seacher_builde_base.dart';

class StreamSearchBuilder<
        T> //extends StreamBuilderBase<List<T>, AsyncSnapshot<List<T>>> {
    extends StreamSearcherBuilderBase<List<T>, AsyncSnapshot<List<T>>> {
  const StreamSearchBuilder({
    Key key,
    this.searcher,
    this.initialData,
    @required this.widgetConnecty,
    @required this.listBuilder,
    Stream<List<T>> stream,
    @required this.builder,
  })  : assert(builder != null),
        super(
            key: key,
            stream: stream,
            searcher: searcher,
            widgetConnecty: widgetConnecty);

  final AsyncWidgetBuilder<List<T>> builder;
  final List<T> initialData;
  final WidgetsListBuilder<T> listBuilder;
  @override
  final SearcherPageStreamController<T> searcher;
  @override
  final Widget widgetConnecty;

  @override
  List<T> get getInitialData => initialData;

  @override
  AsyncSnapshot<List<T>> initial() =>
      AsyncSnapshot<List<T>>.withData(ConnectionState.none, initialData);

  @override
  AsyncSnapshot<List<T>> afterConnected(AsyncSnapshot<List<T>> current) =>
      current.inState(ConnectionState.waiting);

  @override
  AsyncSnapshot<List<T>> afterData(
      AsyncSnapshot<List<T>> current, List<T> data) {
    return AsyncSnapshot<List<T>>.withData(ConnectionState.active, data);
  }

  @override
  AsyncSnapshot<List<T>> afterError(
      AsyncSnapshot<List<T>> current, Object error) {
    return AsyncSnapshot<List<T>>.withError(ConnectionState.active, error);
  }

  @override
  AsyncSnapshot<List<T>> afterDone(AsyncSnapshot<List<T>> current) =>
      current.inState(ConnectionState.done);

  @override
  AsyncSnapshot<List<T>> afterDisconnected(AsyncSnapshot<List<T>> current) =>
      current.inState(ConnectionState.none);

  @override
  Widget build(BuildContext context, AsyncSnapshot<List<T>> currentSummary) {
    if (currentSummary.hasData) {
      searcher.haveInitialData = true;

      /// Para mostrar o botao de procurar no app bar a partir dai
      /// no método _buildAppBar - class SearchAppBar
      return Obx(() {
        return listBuilder(context, searcher.listSearch, searcher.isModSearch);
      });
    }

    return builder(context, currentSummary);
  }
}
