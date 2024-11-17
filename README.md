## Features

This package is my variant of overlay notification.

Usage not that simple but i usually use this package

## Usage

fist pass overlay over all app like this

```dart
@override
Widget build(BuildContext) {
    return MetiralApp.router(
        builder: (context,child){
            return Overlay(
                initialEntries: [
                    OverlayEntry(
                    builder: (context) {
                        return child;
                    },
                   ),
                ]
            )
        }
    )
}
```

Next step is to init OverlayNotification class

```dart
  final overlayNotification = await OverlayNotification()..init(context: context);
```

After this specify youre overlay notification events;

just extend youre class with IOverlayNotificationModel 

```dart
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
```

you can do it like this

```dart
class ExampleNotification extends IOverlayNotificationModel {
  ExampleNotification()
      : super(
          animationCompleteCallback: () {},
          duration: const Duration(seconds: 3),
          notificationColor: Colors.red,
          widget: const Text('Example Notification'),
        );
}
```

then use showNotification function in OverlayNotification class to show notification

```dart
overlayNotification.showNotification(ExampleNotification())
```

or use DefaultNotificationWidget and always provide data into 