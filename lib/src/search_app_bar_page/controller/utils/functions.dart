import 'package:flutter/material.dart';

typedef GetWidgetBuilder<T> = Widget Function(
    BuildContext context, T streamObject);

typedef WidgetsErrorBuilder<T> = Widget Function(Object error);

typedef WidgetsPaginationItemBuilder<T> = Widget Function(
    BuildContext context, int index, T objectIndex);

typedef FutureFetchPageItems<T> = Future<List<T>> Function(int page);
