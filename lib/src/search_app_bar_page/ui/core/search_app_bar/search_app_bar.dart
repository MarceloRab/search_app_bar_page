import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_base_control.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/searcher_page_controller_variable.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/controller/utils/filters/functions_filters.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/core/search_app_bar/search_paint.dart';
import 'package:search_app_bar_page/src/search_app_bar_page/ui/core/search_app_bar/search_widget.dart';

class SearchAppBar<T> extends StatefulWidget implements PreferredSizeWidget {
  //final Searcher searcher;
  final Widget? title;
  final bool centerTitle;
  final IconThemeData? iconTheme;
  final Color? backgroundColor;
  final Color? searchBackgroundColor;
  final Color? searchElementsColor;
  final Color? searchTextColor;
  final double searchTextSize;
  final Color? magnifyGlassColor;
  final String? hintText;
  final bool flattenOnSearch;
  final TextCapitalization capitalization;
  final List<Widget> actions;
  final int _searchButtonPosition;
  final SearcherBase<T> controller;
  final double elevation;
  final TextInputType? keyboardType;

  final OnSubmitted<T>? onSubmit;

  final bool autoFocus;

  SearchAppBar({
    //@required this.searcher,
    super.key,
    required this.controller,
    this.onSubmit,
    this.elevation = 4.0,
    this.title,
    this.centerTitle = false,
    this.iconTheme,
    this.backgroundColor,
    this.searchBackgroundColor,
    this.searchElementsColor,
    this.searchTextColor,
    this.searchTextSize = 18.0,
    this.hintText,
    this.flattenOnSearch = false,
    this.capitalization = TextCapitalization.none,
    this.actions = const <Widget>[],
    int? searchButtonPosition,
    this.keyboardType,
    this.magnifyGlassColor,
    this.autoFocus = true,
  }) : _searchButtonPosition = (searchButtonPosition != null &&
                (0 <= searchButtonPosition &&
                    searchButtonPosition <= actions.length))
            ? searchButtonPosition
            : max(actions.length, 0);

  // assert(controller.isModSearch != null),
  //assert(controller.search != null);

  // search button position defaults to the end.

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  _SearchAppBarState<T> createState() => _SearchAppBarState<T>();
}

class _SearchAppBarState<T> extends State<SearchAppBar<T>>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  double? _rippleStartX, _rippleStartY;
  // Ripple animation (CustomPaint radius)
  late AnimationController _controller;
  late Animation<double> _animation;
  // Fade animation (AppBar opacity)
  late AnimationController _fadeController;
  late Animation<double> _fade;
  double? _elevation;
  //Widget? _iconConnectyOffAppBar;
  //late final void Function(RawKeyEvent) _keyboardListener;

  @override
  bool get wantKeepAlive => true;

  double maxWidthHeaderSearch = 0;

  @override
  void initState() {
    super.initState();
    // Ripple controller (starts AFTER fade completes)
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    final curvedRipple =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _animation = Tween(begin: 0.0, end: 1.0).animate(curvedRipple);
    _controller.addStatusListener(animationStatusListener);

    // Fade-out controller (drives AppBar opacity from 1.0 -> 0.0)
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 50));
    final curvedFade =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic);
    _fade = Tween<double>(begin: 1.0, end: 0.0).animate(curvedFade);

    // When fade completes, start the ripple
    _fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.forward(from: 0.0);
      }
    });
    _elevation = widget.elevation;

    widget.controller.onCancelSearch = cancelSearch;
    widget.controller.initShowSearch = onSearchTapUp;
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

  void onSearchTapUp(TapUpDetails? details) {
    // Use local coordinates so the ripple is relative to the AppBar/dialog
    // If details is null, start ripple from the left edge (x=0) and vertically centered (y=AppBar height/2)

    if (widget.controller.isModSearch) return;
    if (details == null) {
      _rippleStartX = 0;
      _rippleStartY = widget.preferredSize.height / 2;
    } else {
      _rippleStartX = details.localPosition.dx;
      _rippleStartY = details.localPosition.dy;
    }

    if (_fadeController.isAnimating || _controller.isAnimating) return;
    // Start sequence: fade -> ripple (ripple will be started by fade's listener)
    _fadeController.forward(from: 0.0);
  }

  void cancelSearch() {
    widget.controller.isModSearch = false;
    if (widget.controller is SearcherPageControllerVariable<T>) {
      (widget.controller as SearcherPageControllerVariable<T>).onSearchList([]);
      (widget.controller as SearcherPageControllerVariable<T>)
          .onChangedQuery
          ?.call('');
    }
    widget.controller.rxSearch.value = '';
    _elevation = widget.elevation;
    //widget.onCancelSearch?.call();
    // Reset both animations to initial state (AppBar fully visible, no ripple)
    _controller.reset();
    _fadeController.reset();
  }

  /* Future<bool> _onWillPop(bool isInSearchMode) async {
    if (isInSearchMode) {
      cancelSearch();
      return false;
    } else {
      return true;
    }
  } */

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      final bool isInSearchMode = widget.controller.isModSearch;
      //return WillPopScope(
      //onWillPop: () => _onWillPop(isInSearchMode),
      return PopScope(
        onPopInvokedWithResult: (didPop, dynamic) {
          if (isInSearchMode) {
            cancelSearch();
            return;
          } else {
            //SystemNavigator.pop();
            if (maxWidthHeaderSearch == Get.width) {
              Get.back();
            }

            return;
          }
        },
        child: Stack(
          children: [
            _buildAppBar(context),
            _buildAnimation(),
            _buildSearchWidget(isInSearchMode, context),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    //RawKeyboard.instance.removeListener(_keyboardListener);
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Widget _buildAppBar(BuildContext context) {
    final Widget searchButton = _buildSearchButton(context);
    final List<Widget> increasedActions = <Widget>[];
    increasedActions.addAll(widget.actions);
    increasedActions.insert(widget._searchButtonPosition, searchButton);
    final List<Widget> removeSearcher = <Widget>[];
    removeSearcher.addAll(widget.actions);

    /* if (_iconConnectyOffAppBar != null) {
      increasedActions.insert(0, _iconConnectyOffAppBar!);
      removeSearcher.insert(0, _iconConnectyOffAppBar!);
    } */
//
    return Obx(() {
      // Always use LayoutBuilder to capture the current available width

      final bancoInitValue = widget.controller.bancoInitValue;
      final actionUse = bancoInitValue ? increasedActions : removeSearcher;

      // if (widget.controller.listSearch != null)
      return LayoutBuilder(builder: (context, constraints) {
        maxWidthHeaderSearch = constraints.maxWidth;

        // Use the standalone fade animation (runs before ripple)
        final fadeOut = _fade;

        return GestureDetector(
          onTapUp: onSearchTapUp,
          child: IgnorePointer(
            ignoring: widget.controller.isModSearch,
            child: FadeTransition(
              opacity: fadeOut,
              child: AppBar(
                backgroundColor: widget.backgroundColor ??
                    Theme.of(context).appBarTheme.backgroundColor ??
                    Theme.of(context).colorScheme.primary,
                iconTheme: widget.iconTheme ??
                    Theme.of(context).appBarTheme.iconTheme ??
                    Theme.of(context).iconTheme,
                title: widget.title,
                elevation: _elevation,
                centerTitle: widget.centerTitle,
                actions: actionUse,
              ),
            ),
          ),
        );
      });
    });

    /* return Obx(() {
      if (widget.controller.bancoInitValue)
        // if (widget.controller.listSearch != null)
        return LayoutBuilder(builder: (context, constraints) {
          maxWidthHeaderSearch = constraints.maxWidth;
          return GestureDetector(
            onTapUp: onSearchTapUp,
            child: AppBar(
              backgroundColor:
                  //widget.backgroundColor ?? Theme.of(context).appBarTheme.color,
                  widget.backgroundColor ?? Theme.of(context).appBarTheme.foregroundColor,
              iconTheme: widget.iconTheme ?? Theme.of(context).appBarTheme.iconTheme,
              title: widget.title,
              elevation: _elevation,
              centerTitle: widget.centerTitle,
              actions: increasedActions,
            ),
          );
        });
      else {
        return GestureDetector(
          onTapUp: onSearchTapUp,
          child: AppBar(
            backgroundColor:
                //widget.backgroundColor ?? Theme.of(context).appBarTheme.color,
                widget.backgroundColor ?? Theme.of(context).appBarTheme.foregroundColor,
            iconTheme: widget.iconTheme ?? Theme.of(context).appBarTheme.iconTheme,
            title: widget.title,
            elevation: _elevation,
            centerTitle: widget.centerTitle,
            actions: removeSearcher,
          ),
        );
      }
    }); */
  }

  Widget _buildSearchButton(BuildContext context) {
    return IconButton(
      onPressed: null,
      icon: Icon(
        Icons.search,
        color: widget.magnifyGlassColor ??
            widget.iconTheme?.color ??
            Theme.of(context).appBarTheme.iconTheme?.color ??
            Theme.of(context).iconTheme.color ??
            Colors.white,
      ),
    );
  }

  AnimatedBuilder _buildAnimation() {
    _rippleStartX = _rippleStartX ?? 0;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final containerWidth = (maxWidthHeaderSearch > 0)
            ? maxWidthHeaderSearch
            : MediaQuery.of(context).size.width;
        return CustomPaint(
          painter: AppBarPainter(
            containerHeight: widget.preferredSize.height,
            center:
                Offset(min(_rippleStartX!, containerWidth), _rippleStartY ?? 0),
            // grow up to ~112% of the container width to emphasize the sweep
            radius: _animation.value * containerWidth * 1.12,
            context: context,
            color: widget.searchBackgroundColor ??
                Theme.of(context).scaffoldBackgroundColor,
          ),
        );
      },
    );
  }

  Widget _buildSearchWidget(bool isInSearchMode, BuildContext context) {
    return isInSearchMode
        ? SearchWidget<T>(
            //searcher: widget.searcher,
            controller: widget.controller,
            onSubmit: widget.onSubmit,
            color: widget.searchElementsColor ??
                Theme.of(context).iconTheme.color ??
                Theme.of(context).colorScheme.onSurface,
            onCancelSearch: cancelSearch,
            textCapitalization: widget.capitalization,
            hintText: widget.hintText,
            keyboardType: widget.keyboardType,
            searchTextColor: widget.searchTextColor ??
                Theme.of(context).textTheme.titleLarge?.color ??
                Theme.of(context).colorScheme.onSurface,
            searchTextSize: widget.searchTextSize,
            autoFocus: widget.autoFocus,
          )
        : const SizedBox.shrink();
  }
}
