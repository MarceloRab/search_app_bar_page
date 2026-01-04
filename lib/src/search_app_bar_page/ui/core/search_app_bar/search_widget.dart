import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_base_control.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_page_controller.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';

class SearchWidget<T> extends StatefulWidget implements PreferredSizeWidget {
  final Color? color;
  final Color? searchTextColor;
  final double searchTextSize;
  final VoidCallback onCancelSearch;

  final TextCapitalization? textCapitalization;
  final String? hintText;

  final SearcherBase<T> controller;
  final TextInputType? keyboardType;

  final OnSubmitted<T>? onSubmit;

  final bool autoFocus;

  const SearchWidget({
    required this.controller,
    required this.onCancelSearch,
    this.onSubmit,
    this.color,
    this.searchTextColor,
    this.searchTextSize = 18.0,
    this.textCapitalization,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.autoFocus = true,
  });

  @override
  _SearchWidgetState<T> createState() => _SearchWidgetState<T>();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _SearchWidgetState<T> extends State<SearchWidget<T>> {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // to handle notches properly
    return SafeArea(
      //top: true,
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildBackButton(),
          Expanded(child: _buildTextField()),
          _buildClearButton(),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildClearButton() {
    return Obx(() {
      if (!widget.controller.isModSearch ||
          widget.controller.rxSearch.value.isEmpty)
        return const SizedBox.shrink();

      return IconButton(
        padding: const EdgeInsets.only(top: 12),
        icon: Icon(
          Icons.close,
          color: widget.color,
        ),
        onPressed: () {
          widget.controller.rxSearch('');
          textController.clear();
        },
      );
    });
  }

  Widget _buildBackButton() {
    return IconButton(
      padding: const EdgeInsets.only(top: 12),
      icon: Icon(Icons.arrow_back, color: widget.color),
      onPressed: widget.onCancelSearch,
    );
  }

  Widget _buildTextField() {
    _configController();

    return TextField(
        // key: UniqueKey(),
        controller: textController,
        focusNode: widget.controller is SearcherPageController<T>
            ? (widget.controller as SearcherPageController<T>).focusSearch
            : null,
        //textAlign: TextAlign.left,
        //autocorrect: false,
        keyboardType: widget.keyboardType,
        autofocus: widget.autoFocus,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(top: 12.0),
          hintText: widget.hintText,
        ),
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        style: TextStyle(
            fontSize: widget.searchTextSize,
            color: widget.searchTextColor ??
                Theme.of(context).textTheme.titleLarge?.color ??
                Theme.of(context).colorScheme.onSurface),
        onChanged: widget.controller.rxSearch.call,
        onSubmitted: (value) {
          if (widget.controller is SearcherPageController<T>) {
            widget.onSubmit?.call(
                value,
                (widget.controller as SearcherPageController).listSearch
                    as List<T>,
                (widget.controller as SearcherPageController)
                    .highLightIndex
                    .value);
            widget.onCancelSearch();
          }
        });
  }

  TextEditingController _configController() {
    //final TextEditingController textController = TextEditingController();
    textController.value =
        TextEditingValue(text: widget.controller.rxSearch.value);
    //TextEditingValue(text: controller.rxSearch.value ?? '');
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text.length),
    );
    return textController;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
