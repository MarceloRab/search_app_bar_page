import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/seacher_base_controll.dart';

import 'search_paint.dart';
import 'search_widget.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  //final Searcher searcher;
  final Widget? title;
  final bool centerTitle;
  final IconThemeData? iconTheme;
  final Color? backgroundColor;
  final Color? searchBackgroundColor;
  final Color? searchElementsColor;
  final Color? magnifyinGlassColor;
  final String? hintText;
  final bool flattenOnSearch;
  final TextCapitalization capitalization;
  final List<Widget> actions;
  final int _searchButtonPosition;
  final SeacherBase controller;
  final double elevation;
  final TextInputType? keyboardType;

  SearchAppBar({
    //@required this.searcher,
    Key? key,
    required this.controller,
    this.elevation = 4.0,
    this.title,
    this.centerTitle = false,
    this.iconTheme,
    this.backgroundColor,
    this.searchBackgroundColor,
    this.searchElementsColor,
    this.hintText,
    this.flattenOnSearch = false,
    this.capitalization = TextCapitalization.none,
    this.actions = const <Widget>[],
    int? searchButtonPosition,
    this.keyboardType,
    this.magnifyinGlassColor,
  })  : _searchButtonPosition = (searchButtonPosition != null &&
                (0 <= searchButtonPosition &&
                    searchButtonPosition <= actions.length))
            ? searchButtonPosition
            : max(actions.length, 0),
        //assert(
        // hideDefaultConnectyIconOffAppBar &&
        // iconConnectyOffAppBar == null),
        // assert(controller is DisposableInterface);
        //assert(controller is SeacherBase),
        super(key: key);

  // assert(controller.isModSearch != null),
  //assert(controller.search != null);

  // search button position defaults to the end.

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar>
    with SingleTickerProviderStateMixin {
  double? _rippleStartX, _rippleStartY;
  late AnimationController _controller;
  late Animation<double> _animation;
  double? _elevation;
  Widget? _iconConnectyOffAppBar;

  //final ProductsController controller = Modular.get<ProductsController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.addStatusListener(animationStatusListener);
    _elevation = widget.elevation;
  }

  /* @override
  void didUpdateWidget(SearchAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.hideDefaultConnectyIconOffAppBar !=
        widget.hideDefaultConnectyIconOffAppBar) {
      buildwidgetConnecty();
    }
  }*/

  void animationStatusListener(AnimationStatus animationStatus) {
    if (animationStatus == AnimationStatus.completed) {
      widget.controller.isModSearch = true;

      if (widget.flattenOnSearch) _elevation = 0.0;
    }
  }

  void onSearchTapUp(TapUpDetails details) {
    _rippleStartX = details.globalPosition.dx;
    _rippleStartY = details.globalPosition.dy;
    _controller.forward();
  }

  void cancelSearch() {
    widget.controller.isModSearch = false;
    widget.controller.rxSearch.value = '';
    _elevation = widget.elevation;
    _controller.reverse();
  }

  Future<bool> _onWillPop(bool isInSearchMode) async {
    if (isInSearchMode) {
      cancelSearch();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Obx(() {
      final bool isInSearchMode = widget.controller.isModSearch;
      return WillPopScope(
        onWillPop: () => _onWillPop(isInSearchMode),
        child: Stack(
          children: [
            _buildAppBar(context),
            _buildAnimation(screenWidth),
            _buildSearchWidget(isInSearchMode, context),
          ],
        ),
      );
    });
  }

  Widget _buildAppBar(BuildContext context) {
    final Widget searchButton = _buildSearchButton(context);
    final List<Widget> increasedActions = <Widget>[];
    increasedActions.addAll(widget.actions);
    increasedActions.insert(widget._searchButtonPosition, searchButton);
    final List<Widget> removeSeacher = <Widget>[];
    removeSeacher.addAll(widget.actions);

    if (_iconConnectyOffAppBar != null) {
      increasedActions.insert(0, _iconConnectyOffAppBar!);
      removeSeacher.insert(0, _iconConnectyOffAppBar!);
    }

    return Obx(() {
      if (widget.controller.bancoInitValue)
        // if (widget.controller.listSearch != null)
        return AppBar(
          backgroundColor:
              //widget.backgroundColor ?? Theme.of(context).appBarTheme.color,
              widget.backgroundColor ??
                  Theme.of(context).appBarTheme.foregroundColor,
          iconTheme:
              widget.iconTheme ?? Theme.of(context).appBarTheme.iconTheme,
          title: widget.title,
          elevation: _elevation,
          centerTitle: widget.centerTitle,
          actions: increasedActions,
        );
      else {
        return AppBar(
          backgroundColor:
              //widget.backgroundColor ?? Theme.of(context).appBarTheme.color,
              widget.backgroundColor ??
                  Theme.of(context).appBarTheme.foregroundColor,
          iconTheme:
              widget.iconTheme ?? Theme.of(context).appBarTheme.iconTheme,
          title: widget.title,
          elevation: _elevation,
          centerTitle: widget.centerTitle,
          actions: removeSeacher,
        );
      }
    });
  }

  Widget _buildSearchButton(BuildContext context) {
    return GestureDetector(
      onTapUp: onSearchTapUp,
      child: IconButton(
        onPressed: null,
        icon: Icon(
          Icons.search,
          color:
              widget.magnifyinGlassColor ?? Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }

  AnimatedBuilder _buildAnimation(double screenWidth) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: AppBarPainter(
            containerHeight: widget.preferredSize.height,
            center: Offset(_rippleStartX ?? 0, _rippleStartY ?? 0),
            // increase radius in % from 0% to 100% of screenWidth
            radius: _animation.value * screenWidth,
            context: context,
            color: widget.searchBackgroundColor ?? Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildSearchWidget(bool isInSearchMode, BuildContext context) {
    return isInSearchMode
        ? SearchWidget(
            //searcher: widget.searcher,
            controller: widget.controller,
            color: widget.searchElementsColor ?? Theme.of(context).primaryColor,
            onCancelSearch: cancelSearch,
            textCapitalization: widget.capitalization,
            hintText: widget.hintText,
            keyboardType: widget.keyboardType,
          )
        : const SizedBox.shrink();
  }
}
