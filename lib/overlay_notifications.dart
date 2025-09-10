library overlay_notifications;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:overlay_notifications/overlay_widget.dart';

/// Notification interface
class IOverlayNotificationModel {
  IOverlayNotificationModel({
    required this.animationCompleteCallback,
    required this.notificationColor,
    required this.widget,
    this.duration,
  });

  final Widget widget;

  ///
  final VoidCallback animationCompleteCallback;
  final Duration? duration;
  final Color notificationColor;
}

class DefaultNotification implements IOverlayNotificationModel {
  DefaultNotification({
    required this.widget,
    required this.animationCompleteCallback,
    required this.notificationColor,
    this.duration,
  });

  @override
  Widget widget;

  @override
  VoidCallback animationCompleteCallback;

  @override
  Duration? duration;

  @override
  Color notificationColor;
}

class OverlayNotification {
  // check i class was alrady initd
  bool hasInited = false;

  // Private constructor
  OverlayNotification._internal();

  // Singleton instance
  static final OverlayNotification _instance = OverlayNotification._internal();

  // Factory constructor to return the singleton instance
  factory OverlayNotification() {
    return _instance;
  }

  /// Notification controller
  late final StreamController<IOverlayNotificationModel> overlayNotificationsController;

  late Duration _duration;

  /// Send new notification to [overlayNotificationsController] as event
  void showNotification(IOverlayNotificationModel model) => overlayNotificationsController.add(model);

  /// Initialize [overlayNotificationsController]
  ///
  /// add listener that listen to [overlayNotificationsController] stream
  ///
  /// Can be initialized only once
  ///
  /// if it was already initialized throw exception
  ///
  /// U can set default [duration] for all notification
  ///
  /// If duration was provided in [IOverlayNotificationModel] it will be used
  Future<void> init({
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) async {
    if (hasInited) {
      throw Exception('OverlayNotification alrady initialized');
    }
    _duration = duration;
    hasInited = true;

    overlayNotificationsController = StreamController<IOverlayNotificationModel>.broadcast();

    overlayNotificationsController.stream.listen((notification) {
      _showOverlayNotification(
          context: context,
          notificationWidget: notification.widget,
          animationCompleteCallback: notification.animationCompleteCallback,
          notificationColor: notification.notificationColor,
          duration: notification.duration);
    });
  }

  Future<void> _showOverlayNotification({
    required BuildContext context,
    required Widget notificationWidget,
    required VoidCallback animationCompleteCallback,
    required Color notificationColor,
    Duration? duration,
  }) async {
    final overlay = Overlay.of(context);

    final entry = OverlayEntry(builder: (context) {
      return OverlayNotificationWidget(
        notificationWidget: notificationWidget,
        animationCompleteCallback: animationCompleteCallback,
        duration: duration ?? _duration,
        notificationColor: notificationColor,
      );
    });

    overlay.insert(entry);

    await Future<void>.delayed(_duration);

    entry.remove();
  }
}
