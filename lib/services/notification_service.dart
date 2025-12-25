import 'package:dialisaku/models/get_jadwal_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // FIX: Hapus data notifikasi terjadwal yang mungkin korup
    // untuk mengatasi crash GSON di Android.
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('scheduled_notifications');
    } catch (e) {
      if (kDebugMode) {
        print('Could not clear scheduled_notifications: $e');
      }
    }

    // Menginisialisasi basis data zona waktu
    tz.initializeTimeZones();
    // Mendapatkan zona waktu lokal perangkat
    try {
      final String localTimezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTimezone));
    } catch (e) {
      if (kDebugMode) {
        print('Could not get timezone: $e');
      }
      // Rethrow the exception to make it visible in release builds.
      rethrow;
    }

    // Pengaturan inisialisasi untuk Android
    // Pastikan Anda punya ikon bernama 'ic_launcher' di direktori mipmap
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notif');

    // Pengaturan inisialisasi untuk iOS
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: (id, title, body, payload) async {
              // menangani notifikasi saat aplikasi di foreground (untuk iOS versi lama)
            });

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      // Di sini kita bisa menangani apa yang terjadi saat notifikasi di-tap
      // Misalnya, navigasi ke halaman tertentu.
    });
  }

  Future<void> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  TimeOfDay? _parseTime(String timeString) {
    final parts = timeString.split(':');
    if (parts.length >= 2) {
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    return null;
  }

  Future<void> scheduleAllNotificationsForPasien(
      ModelGetJadwaResponseData jadwal) async {
    // FIX: Panggil cancelAll untuk membersihkan semua notifikasi terjadwal
    // sebelum mengatur yang baru. Ini lebih bersih daripada loop manual.
    await cancelAllNotifications();

    // Fungsi helper internal untuk menjadwalkan notifikasi dengan payload
    Future<void> schedule(int id, String title, String body, TimeOfDay? time,
        String payload) async {
      if (time != null) {
        await scheduleDailyNotification(
          id: id,
          title: title,
          body: body,
          time: time,
          payload: payload, // FIX: Meneruskan payload
        );
      }
    }

    final waktuMakan1 = _parseTime(jadwal.waktuMakan1);
    await schedule(
        0,
        'Waktunya Makan Pagi!',
        'Jangan lupa untuk mencatat menu makan pagi Anda hari ini.',
        waktuMakan1,
        'makan_pagi'); // Payload
    await schedule(4, 'Waktunya Minum!', 'Jangan lupa catat minum Anda.',
        waktuMakan1, 'minum_1'); // Payload

    final waktuMakan2 = _parseTime(jadwal.waktuMakan2);
    await schedule(
        1,
        'Waktunya Makan Siang!',
        'Jangan lupa untuk mencatat menu makan siang Anda hari ini.',
        waktuMakan2,
        'makan_siang'); // Payload
    await schedule(5, 'Waktunya Minum!', 'Jangan lupa catat minum Anda.',
        waktuMakan2, 'minum_2'); // Payload

    final waktuMakan3 = _parseTime(jadwal.waktuMakan3);
    await schedule(
        2,
        'Waktunya Makan Malam!',
        'Jangan lupa untuk mencatat menu makan malam Anda hari ini.',
        waktuMakan3,
        'makan_malam'); // Payload
    await schedule(6, 'Waktunya Minum!', 'Jangan lupa catat minum Anda.',
        waktuMakan3, 'minum_3'); // Payload

    final waktuAlarmBb = _parseTime(jadwal.waktuAlarmBb);
    await schedule(
        3,
        'Waktunya Timbang Berat Badan!',
        'Ayo timbang dan catat berat badan Anda sekarang.',
        waktuAlarmBb,
        'timbang_bb'); // Payload
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    String payload = '',
  }) async {
    final tz.TZDateTime scheduledTime = _nextInstanceOfTime(time);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_notification_channel_id',
            'Daily Notifications',
            channelDescription: 'Channel untuk pengingat harian',
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('custom_sound'),
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            sound: 'custom_sound.aiff',
            presentSound: true,
          ),
        ),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'immediate_notification_channel_id',
        'Immediate Notifications',
        channelDescription: 'Channel untuk notifikasi langsung',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('custom_sound'),
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        sound: 'custom_sound.aiff',
        presentSound: true,
      ),
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
