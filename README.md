## Features
This package is variant of overlay notifications.

## Usage
First, wrap your entire app with an Overlay by modifying the build method like this:

```dart
@override
Widget build(BuildContext context) {
  return MaterialApp.router(
    builder: (context, child) {
      return Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) {
              return child;
            },
          ),
        ],
      );
    },
  );
}
```
Next, initialize the OverlayNotification class:
```dart
OverlayNotification().init(context: context);
```

OverlayNotification is singlton, no need to pass instance in variable. Just use OverlayNotification()

```dart
OverlayNotification().showNotification(SomeNotificationModel());
```

After this, specify your overlay notification events.
Extend your class with IOverlayNotificationModel

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

You can do it like this:

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
Then, use the showNotification function in the OverlayNotification class to display the notification:
```dart
overlayNotification.showNotification(ExampleNotification());
```
Or use DefaultNotificationWidget and always provide data into it.

```dart
OverlayNotification().showNotification(DefaultNotification(
  widget: SomeWidget(),
  animationCompleteCallback:() => someCallback(),
  duration: Duration(seconds: 3),
  notificationColor: Colors.white,
));
```