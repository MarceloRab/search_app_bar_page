import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SeacherScaffoldBase {
  final Widget? searchePageFloatingActionButton;
  final FloatingActionButtonLocation? searchePageFloatingActionButtonLocation;
  final FloatingActionButtonAnimator? searchePageFloatingActionButtonAnimator;
  final List<Widget>? searchePagePersistentFooterButtons;
  final Widget? searchePageDrawer;
  final Widget? searchePageEndDrawer;
  final Widget? searchePageBottomNavigationBar;
  final Widget? searchePageBottomSheet;
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

  SeacherScaffoldBase(
      this.searchePageFloatingActionButton,
      this.searchePageFloatingActionButtonLocation,
      this.searchePageFloatingActionButtonAnimator,
      this.searchePagePersistentFooterButtons,
      this.searchePageDrawer,
      this.searchePageEndDrawer,
      this.searchePageBottomNavigationBar,
      this.searchePageBottomSheet,
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
