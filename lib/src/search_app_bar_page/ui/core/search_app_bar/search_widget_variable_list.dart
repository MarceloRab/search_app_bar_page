import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_page_controller.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_page_controller_variable.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';

class SearchWidgetVariableList<T> extends StatefulWidget
    implements PreferredSizeWidget {
  final Color? color;
  final Color? searchTextColor;
  final double searchTextSize;
  final VoidCallback onCancelSearch;

  final TextCapitalization? textCapitalization;
  final String? hintText;

  final SearcherPageControllerVariable<T> controller;
  final TextInputType? keyboardType;

  final OnSubmitted<T>? onSubmit;

  final bool autoFocus;

  final TextEditingController? textController;

  const SearchWidgetVariableList({
    super.key,
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
    this.textController,
  });

  @override
  _SearchWidgetVariableListState<T> createState() =>
      _SearchWidgetVariableListState<T>();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _SearchWidgetVariableListState<T>
    extends State<SearchWidgetVariableList<T>> {
  late TextEditingController textController;
  Worker? _worker;
  bool _isLocalUpdate = false;

  @override
  void initState() {
    super.initState();
    textController = widget.textController ?? TextEditingController();

    // Configura valor inicial se vazio
    if (textController.text.isEmpty &&
        widget.controller.rxSearch.value.isNotEmpty) {
      textController.text = widget.controller.rxSearch.value;
    }

    textController.addListener(_onTextChanged);

    // Escuta alterações externas (do controller) no rxSearch
    _worker = ever(widget.controller.rxSearch, (String value) {
      // Se o texto for diferente e NÃO estivermos no meio de um update local...
      if (textController.text != value && !_isLocalUpdate) {
        _isLocalUpdate = true;
        // Atualiza o texto visualmente
        textController.value = TextEditingValue(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
        _isLocalUpdate = false;
      }
    });
  }

  void _onTextChanged() {
    // Se for um update provocado pelo 'ever', ignoramos para não criar loop
    if (_isLocalUpdate) return;

    if (textController.text != widget.controller.rxSearch.value) {
      widget.controller.rxSearch(textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
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
          widget.controller.rxSearch.value.isEmpty) {
        return const SizedBox.shrink();
      }

      return IconButton(
        padding: const EdgeInsets.only(top: 12),
        icon: Icon(
          Icons.close,
          color: widget.color,
        ),
        onPressed: () {
          // Apenas limpa o reactive. O listener 'ever' vai limpar o texto visualmente.
          widget.controller.rxSearch('');
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
    return TextField(
        controller: textController,
        focusNode: widget.controller is SearcherPageController<T>
            ? (widget.controller as SearcherPageController<T>).focusSearch
            : null,
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

  @override
  void dispose() {
    _worker?.dispose();
    textController.removeListener(_onTextChanged);
    if (widget.textController == null) {
      textController.dispose();
    }
    super.dispose();
  }
}
