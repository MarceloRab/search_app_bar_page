import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SearcherScaffoldBase {
  final Widget? searchPageFloatingActionButton;
  final FloatingActionButtonLocation? searchPageFloatingActionButtonLocation;
  final FloatingActionButtonAnimator? searchPageFloatingActionButtonAnimator;
  final List<Widget>? searchPagePersistentFooterButtons;
  final Widget? searchPageDrawer;
  final Widget? searchPageEndDrawer;
  final Widget? searchPageBottomNavigationBar;
  final Widget? searchPageBottomSheet;
  final Color? searchPageBackgroundColor;

  final String? restorationId;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;

  SearcherScaffoldBase(
      this.searchPageFloatingActionButton,
      this.searchPageFloatingActionButtonLocation,
      this.searchPageFloatingActionButtonAnimator,
      this.searchPagePersistentFooterButtons,
      this.searchPageDrawer,
      this.searchPageEndDrawer,
      this.searchPageBottomNavigationBar,
      this.searchPageBottomSheet,
      this.searchPageBackgroundColor,
      this.restorationId,
      this.resizeToAvoidBottomInset,
      this.primary,
      this.drawerDragStartBehavior,
      this.extendBody,
      this.extendBodyBehindAppBar,
      this.drawerScrimColor,
      this.drawerEdgeDragWidth,
      this.drawerEnableOpenDragGesture,
      this.endDrawerEnableOpenDragGesture);
}
