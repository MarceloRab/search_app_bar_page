import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/simple_app_bar_controller.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';

class RxListWidget<T> extends StatelessWidget {
  /// [obxListBuilder] Function applied when it is filtered.
  final WidgetsListBuilder<T> obxListBuilder;
  final SimpleAppBarController<T> controller;

  const RxListWidget(
      {super.key, required this.controller, required this.obxListBuilder});

  @override
  Widget build(BuildContext context) => Obx(() => obxListBuilder(
      context, controller.listSearch, controller.isModSearch, 0));
}
