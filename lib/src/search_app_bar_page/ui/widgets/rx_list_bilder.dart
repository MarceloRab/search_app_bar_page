import 'package:flutter/material.dart';
import 'package:get_state_manager/get_state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/simple_app_bar_controller.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';

class RxListWidget<T> extends StatelessWidget {
  /// [listBuilder] Function applied when it is filtered.
  final WidgetsListBuilder<T> listBuilder;
  final SimpleAppBarController<T> controller;

  const RxListWidget(
      {Key key, @required this.controller, @required this.listBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Obx(() =>
      listBuilder(context, controller.listSearch, controller.isModSearch));
}
