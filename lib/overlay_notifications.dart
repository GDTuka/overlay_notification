library overlay_notifications;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:overlay_notifications/overlay_widget.dart';

class IOverlayNotificationModel {
  IOverlayNotificationModel({
    required this.animationCompleteCallback,
    required this.duration,
    required this.notificationColor,
    required this.widget,
  });

  final Widget widget;
  final VoidCallback animationCompleteCallback;
  final Duration duration;
  final Color notificationColor;
}

class DefaultNotification implements IOverlayNotificationModel {
  DefaultNotification({
    required this.widget,
    required this.animationCompleteCallback,
    required this.duration,
    required this.notificationColor,
  });

  @override
  Widget widget;

  @override
  VoidCallback animationCompleteCallback;

  @override
  Duration duration;

  @override
  Color notificationColor;
}

class OverlayNotification {
  bool _hasInited = false;

  late final StreamController<IOverlayNotificationModel> overlayNotificationsController;

  late Duration _duration;

  Future<void> showNotification(IOverlayNotificationModel model) async => overlayNotificationsController.add(model);

  Future<void> init({
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) async {
    if (_hasInited) {
      throw Exception('OverlayNotification alrady initialized');
    }
    _duration = duration;
    _hasInited = true;

    overlayNotificationsController = StreamController<IOverlayNotificationModel>.broadcast();

    overlayNotificationsController.stream.listen((event) {
      _showOverlayNotification(
        context: context,
        notificationWidget: event.widget,
        animationCompleteCallback: event.animationCompleteCallback,
        notificationColor: event.notificationColor,
      );
    });
  }

  Future<void> _showOverlayNotification({
    required BuildContext context,
    required Widget notificationWidget,
    required VoidCallback animationCompleteCallback,
    required Color notificationColor,
  }) async {
    final overlay = Overlay.of(context);

    final entry = OverlayEntry(builder: (context) {
      return OverlayNotificationWidget(
        notificationWidget: notificationWidget,
        animationCompleteCallback: animationCompleteCallback,
        duration: _duration,
        notificationColor: notificationColor,
      );
    });

    overlay.insert(entry);

    await Future<void>.delayed(_duration);

    entry.remove();
  }
}
