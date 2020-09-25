import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_state_manager/get_state_manager.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/seacher_base_controll.dart';

import 'search_paint.dart';
import 'search_widget.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  //final Searcher searcher;
  final Widget title;
  final bool centerTitle;
  final IconThemeData iconTheme;
  final Color backgroundColor;
  final Color searchBackgroundColor;
  final Color searchElementsColor;
  final String hintText;
  final bool flattenOnSearch;
  final TextCapitalization capitalization;
  final List<Widget> actions;
  final int _searchButtonPosition;

  final SeacherBase controller;

  final double elevation;

  SearchAppBar({
    //@required this.searcher,
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
    int searchButtonPosition,
    @required this.controller,
  })  : _searchButtonPosition = (searchButtonPosition != null &&
                (0 <= searchButtonPosition &&
                    searchButtonPosition <= actions.length))
            ? searchButtonPosition
            : max(actions.length, 0),
        //assert(controller != null),
        // assert(controller is DisposableInterface);
        assert(controller is SeacherBase);

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
  double _rippleStartX, _rippleStartY;
  AnimationController _controller;
  Animation<double> _animation;
  double _elevation;

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

  void animationStatusListener(AnimationStatus animationStatus) {
    if (animationStatus == AnimationStatus.completed) {
      //widget.searcher.setSearchMode(true);
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
    final searchButton = _buildSearchButton(context);
    final increasedActions = <Widget>[];
    increasedActions.addAll(widget.actions);
    increasedActions.insert(widget._searchButtonPosition, searchButton);
    final removeSeacher = <Widget>[];
    removeSeacher.addAll(widget.actions);
    return Obx(() {
      if (widget.controller.bancoInit)
        // if (widget.controller.listSearch != null)
        return AppBar(
          backgroundColor:
              widget.backgroundColor ?? Theme.of(context).primaryColor,
          iconTheme: widget.iconTheme ?? Theme.of(context).iconTheme,
          title: widget.title,
          elevation: _elevation,
          centerTitle: widget.centerTitle,
          actions: increasedActions,
        );
      else {
        return AppBar(
          backgroundColor:
              widget.backgroundColor ?? Theme.of(context).primaryColor,
          iconTheme: widget.iconTheme ?? Theme.of(context).iconTheme,
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
          color: widget.iconTheme?.color ?? Theme.of(context).iconTheme.color,
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
          )
        : const SizedBox.shrink();
  }
}
