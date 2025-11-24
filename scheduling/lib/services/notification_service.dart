import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  Timer? _scheduledTimer;

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _createNotificationChannels();

    await _requestPermissions();

    _isInitialized = true;
  }

  Future<void> _createNotificationChannels() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            'simple_channel',
            'Simple Notifications',
            description: 'Channel untuk notifikasi sederhana',
            importance: Importance.high,
          ),
        );

        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            'scheduled_channel',
            'Scheduled Notifications',
            description: 'Channel untuk notifikasi terjadwal',
            importance: Importance.high,
          ),
        );

        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            'periodic_channel',
            'Periodic Notifications',
            description: 'Channel untuk notifikasi berkala',
            importance: Importance.high,
          ),
        );
      }
    }
  }

  Future<void> _requestPermissions() async {
   if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
    } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
       await _notifications.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
       await _notifications.resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }


  void _onNotificationTapped(NotificationResponse response) {
    // print('Notifikasi diklik: ${response.payload}');
  }

  Future<void> showSimpleNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'simple_channel',
      'Simple Notifications',
      channelDescription: 'Channel untuk notifikasi sederhana',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
    );
    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );
    await _notifications.show(
      0,
      title,
      body,
      notificationDetails,
      payload: 'simple_notification',
    );
  }

  Future<void> scheduleNotification({
    required String title,
    required String body,
    required Duration delay,
  }) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      _scheduledTimer?.cancel();

      if (delay.inSeconds < 60) {
        print(
          'Scheduling notification with Timer for ${delay.inSeconds} seconds',
        );
        await _notifications.cancel(1);
        _scheduledTimer = Timer(delay, () async {
          print('Timer fired, showing notification now');
          await _showScheduledNotification(title: title, body: body);
        });
        print('Notification timer started');
        return;
      }

      final scheduledTime = tz.TZDateTime.now(tz.local).add(delay);
      final now = tz.TZDateTime.now(tz.local);

      if (scheduledTime.isBefore(now) || scheduledTime.isAtSameMomentAs(now)) {
        throw Exception(
          'Scheduled time must be in the future. Current: $now, Scheduled: $scheduledTime',
        );
      }

      print(
        'Scheduling notification at: $scheduledTime (in ${delay.inSeconds} seconds)',
      );
      print('Current time: $now');

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'scheduled_channel',
        'Scheduled Notifications',
        channelDescription: 'Channel untuk notifikasi terjadwal',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        showWhen: true,
        channelShowBadge: true,
        largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
      );

      const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      try {
        await _notifications.zonedSchedule(
          1,
          title,
          body,
          scheduledTime,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: 'scheduled_notification',
        );
        print(
          'Notification scheduled successfully with exactAllowWhileIdle mode',
        );
      } catch (e) {
        print('Failed with exactAllowWhileIdle, trying exact: $e');
        try {
          await _notifications.zonedSchedule(
            1,
            title,
            body,
            scheduledTime,
            notificationDetails,
            androidScheduleMode: AndroidScheduleMode.exact,
            payload: 'scheduled_notification',
          );
          print('Notification scheduled successfully with exact mode');
        } catch (e2) {
          print('Failed with exact, trying inexactAllowWhileIdle: $e2');
          await _notifications.zonedSchedule(
            1,
            title,
            body,
            scheduledTime,
            notificationDetails,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            payload: 'scheduled_notification',
          );
          print(
            'Notification scheduled successfully with inexactAllowWhileIdle mode',
          );
        }
      }
    } catch (e) {
      print('Error in scheduleNotification: $e');
      rethrow;
    }
  }

  Future<void> _showScheduledNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'Channel untuk notifikasi terjadwal',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      showWhen: true,
      channelShowBadge: true,
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
    );
    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );
    await _notifications.show(
      1,
      title,
      body,
      notificationDetails,
      payload: 'scheduled_notification',
    );
    print('Scheduled notification displayed');
  }

  Future<void> cancelNotification(int id) async {
    if (id == 1) {
      _scheduledTimer?.cancel();
      _scheduledTimer = null;
    }
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    _scheduledTimer?.cancel();
    _scheduledTimer = null;
    await _notifications.cancelAll();
  }

  void dispose() {
    _scheduledTimer?.cancel();
    _scheduledTimer = null;
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
