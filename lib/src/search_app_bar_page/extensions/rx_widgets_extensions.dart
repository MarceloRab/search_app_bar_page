import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/functions.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/get_stream_widget.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/infra/rx_get_type.dart';

extension ListRxWidget<T> on RxList<T> {
  Widget getStreamWidget(
      {required GetWidgetBuilder<List<T>> obxWidgetBuilder,
      WidgetsErrorBuilder? widgetErrorBuilder,
      Widget? widgetWaiting,
      List<T>? initialData,
      RxBoolAuth? rxBoolAuth}) {
    return GetStreamWidget<List<T>>(
      stream: stream as Stream<List<T>>,
      obxWidgetBuilder: obxWidgetBuilder,
      initialData: initialData,
      widgetWaiting: widgetWaiting,
      widgetErrorBuilder: widgetErrorBuilder,
      rxBoolAuth: rxBoolAuth,
    );
  }
}

extension RxWidget<T> on Rx<T> {
  Widget getStreamWidget(
      {required GetWidgetBuilder<T> obxWidgetBuilder,
      WidgetsErrorBuilder? widgetErrorBuilder,
      Widget? widgetWaiting,
      T? initialData,
      RxBoolAuth? rxBoolAuth}) {
    return GetStreamWidget<T>(
      stream: stream as Stream<T>,
      obxWidgetBuilder: obxWidgetBuilder,
      initialData: initialData,
      widgetWaiting: widgetWaiting,
      widgetErrorBuilder: widgetErrorBuilder,
      rxBoolAuth: rxBoolAuth,
    );
  }
}

extension RxIntWidget on RxInt {
  Widget getStreamWidget(
      {required GetWidgetBuilder<int> obxWidgetBuilder,
      WidgetsErrorBuilder? widgetErrorBuilder,
      Widget? widgetWaiting,
      int? initialData,
      RxBoolAuth? rxBoolAuth}) {
    return GetStreamWidget<int>(
      stream: stream as Stream<int>,
      obxWidgetBuilder: obxWidgetBuilder,
      initialData: initialData,
      widgetWaiting: widgetWaiting,
      widgetErrorBuilder: widgetErrorBuilder,
      rxBoolAuth: rxBoolAuth,
    );
  }
}

extension RxNumberWidget on RxNum {
  Widget getStreamWidget(
      {required GetWidgetBuilder<num> obxWidgetBuilder,
      WidgetsErrorBuilder? widgetErrorBuilder,
      Widget? widgetWaiting,
      num? initialData,
      RxBoolAuth? rxBoolAuth}) {
    return GetStreamWidget<num>(
      stream: stream as Stream<num>,
      obxWidgetBuilder: obxWidgetBuilder,
      initialData: initialData,
      widgetWaiting: widgetWaiting,
      widgetErrorBuilder: widgetErrorBuilder,
      rxBoolAuth: rxBoolAuth,
    );
  }
}

extension RxDoubleWidget on RxDouble {
  Widget getStreamWidget(
      {required GetWidgetBuilder<double> obxWidgetBuilder,
      WidgetsErrorBuilder? widgetErrorBuilder,
      Widget? widgetWaiting,
      double? initialData,
      RxBoolAuth? rxBoolAuth}) {
    return GetStreamWidget<double>(
      stream: stream as Stream<double>,
      obxWidgetBuilder: obxWidgetBuilder,
      initialData: initialData,
      widgetWaiting: widgetWaiting,
      widgetErrorBuilder: widgetErrorBuilder,
      rxBoolAuth: rxBoolAuth,
    );
  }
}

extension RxBoolWidget on RxBool {
  Widget getStreamWidget(
      {required GetWidgetBuilder<bool> obxWidgetBuilder,
      WidgetsErrorBuilder? widgetErrorBuilder,
      Widget? widgetWaiting,
      bool? initialData,
      RxBoolAuth? rxBoolAuth}) {
    return GetStreamWidget<bool>(
      stream: stream as Stream<bool>,
      obxWidgetBuilder: obxWidgetBuilder,
      initialData: initialData,
      widgetWaiting: widgetWaiting,
      widgetErrorBuilder: widgetErrorBuilder,
      rxBoolAuth: rxBoolAuth,
    );
  }
}

extension RxStringWidget on RxString {
  Widget getStreamWidget(
      {required GetWidgetBuilder<String> obxWidgetBuilder,
      WidgetsErrorBuilder? widgetErrorBuilder,
      Widget? widgetWaiting,
      String? initialData,
      RxBoolAuth? rxBoolAuth}) {
    return GetStreamWidget<String>(
      stream: stream as Stream<String>,
      obxWidgetBuilder: obxWidgetBuilder,
      initialData: initialData,
      widgetWaiting: widgetWaiting,
      widgetErrorBuilder: widgetErrorBuilder,
      rxBoolAuth: rxBoolAuth,
    );
  }
}
