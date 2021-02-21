import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/seacher_base_controll.dart';

class SearchWidget extends StatefulWidget implements PreferredSizeWidget {
  final Color color;
  final VoidCallback onCancelSearch;

  final TextCapitalization textCapitalization;
  final String hintText;

  final SeacherBase controller;
  final TextInputType keyboardType;

  const SearchWidget({
    @required this.controller,
    @required this.onCancelSearch,
    this.color,
    this.textCapitalization,
    this.hintText,
    this.keyboardType = TextInputType.text,
  });

  @override
  _SearchWidgetState createState() => _SearchWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _SearchWidgetState extends State<SearchWidget> {
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
          textController.text = '';
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
      //textAlign: TextAlign.left,
      //autocorrect: false,
      keyboardType: widget.keyboardType,
      autofocus: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(top: 12.0),
        hintText: widget.hintText,
      ),
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      style: const TextStyle(fontSize: 18.0),
      onChanged: widget.controller.rxSearch,
    );
  }

  TextEditingController _configController() {
    //final TextEditingController textController = TextEditingController();
    textController.value =
        TextEditingValue(text: widget.controller.rxSearch.value);
    //TextEditingValue(text: controller.rxSearch.value ?? '');
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text?.length ?? 0),
    );
    return textController;
  }
}
