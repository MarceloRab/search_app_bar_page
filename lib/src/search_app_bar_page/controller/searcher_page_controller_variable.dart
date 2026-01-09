import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_base_control.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';

class SearcherPageControllerVariable<T> extends SearcherBase<T> {
  final RxBool _isModSearch = false.obs;

  @override
  bool get isModSearch => _isModSearch.value;

  @override
  set isModSearch(bool value) => _isModSearch.value = value;

  @override
  VoidCallback? onCancelSearch;

  @override
  ValueChanged<TapUpDetails?>? initShowSearch;

  @override
  bool autoFocus = true;

  @override
  final RxString rxSearch = ''.obs;

  @override
  bool? sortCompare = true;

  @override
  set bancoInitValue(bool value) => bancoInit.value = value;

  @override
  bool get bancoInitValue => bancoInit.value;

  @override
  final RxBool bancoInit = true.obs;

  final listSearch = <T>[].obs;
  final Rx<Object?> rxError = Rx<Object?>(null);

  final RxBool _isLoadingListAsync = false.obs;
  bool get isLoadingListAsync => _isLoadingListAsync.value;
  set isLoadingListAsync(bool value) => _isLoadingListAsync.value = value;

  ListVariableFunction<T>? listAsync;

  final ValueChanged<String>? onChangedQuery;

  Function(Iterable<T>) get onSearchList => listSearch.assignAll;

  //Compare<T> compareSort;

  Worker? _worker;

  //StringFilter<T> get _defaultFilter => (T value) => value as String;

  @override
  final focusSearch = FocusNode();

  SearcherPageControllerVariable({
    required this.listAsync,
    this.onChangedQuery,
  });

  void onReady() {
    _worker = debounce(rxSearch, (String? value) async {
      rxError.value = null;

      if (value == null || value.isEmpty) {
        onChangedQuery?.call('');
        onSearchList([]);
        return;
      }

      isLoadingListAsync = true;
      try {
        onChangedQuery?.call(value);
        final list = await listAsync!.call(rxSearch.value);
        isLoadingListAsync = false;

        // Discard result if the query changed while waiting for the response
        if (rxSearch.value != value) return;

        onSearchList(list);
        //refreshAsyncSearchList(value, list);
      } catch (err) {
        isLoadingListAsync = false;
        rxError.value = err;

        onCancelSearch?.call();
        highLightIndex.value = 0;
      }
    },
        time: listAsync is Future<List<T>> Function(String?)
            ? const Duration(milliseconds: 300)
            : Duration.zero);
  }

  final RxInt highLightIndex = 0.obs;

  void incrementSelection() {
    if (highLightIndex.value < listSearch.length - 1) {
      highLightIndex.value++;
    }
  }

  void decrementSelection() {
    if (highLightIndex.value > 0) {
      highLightIndex.value--;
    }
  }

  FutureOr onClose() {
    _worker?.dispose();
    focusSearch.dispose();
    //_isModSearch.close();
    //_isModSearch.close();
    //rxSearch.close();
    //listSearch.close();
    // bancoInit.close();
  }

  @override
  void sortCompareList(List<T> list) {}
}
