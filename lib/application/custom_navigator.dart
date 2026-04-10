
import 'package:flutter/material.dart';

extension NavigatorExtension on BuildContext {
  Future<T?> push<T extends Object?>(Widget screen, {
    bool fullscreenDialog = false,
    String? routeName,
  }) {
    return Navigator.of(this).push<T>(
      _buildRoute(screen, fullscreenDialog: fullscreenDialog, routeName: routeName),
    );
  }
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
      Widget screen, {
        TO? result,
        bool fullscreenDialog = false,
      }) {
    return Navigator.of(this).pushReplacement<T, TO>(
      _buildRoute(screen, fullscreenDialog: fullscreenDialog),
      result: result,
    );
  }
  Future<T?> pushAndRemoveAll<T extends Object?>(
      Widget screen, {
        bool fullscreenDialog = false,
      }) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
      _buildRoute(screen, fullscreenDialog: fullscreenDialog),
          (route) => false,
    );
  }
  void maybePop<T extends Object?>([T? result]) {
    Navigator.of(this).maybePop(result);
  }
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  PageRoute<T> _buildRoute<T extends Object?>(
      Widget screen, {
        bool fullscreenDialog = false,
        String? routeName,
      }) {
    return MaterialPageRoute<T>(
      builder: (context) => screen,
      fullscreenDialog: fullscreenDialog,
      settings: routeName != null ? RouteSettings(name: routeName) : null,
    );
  }
}