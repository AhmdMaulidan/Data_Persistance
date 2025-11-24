import 'dart:isolate';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ========================================
// 1. BACKGROUND PROCESS dengan ISOLATE
// ========================================
class IsolateService {
// Menjalankan komputasi berat di background menggunakan Isolate
static Future<int> calculateFactorial(int number) async {
final receivePort = ReceivePort();
await Isolate.spawn(_factorialComputation, {
'number': number,
'sendPort': receivePort.sendPort,
});
// Tunggu hasil dari isolate
final result = await receivePort.first as int;
return result;
}

// Fungsi yang berjalan di isolate terpisah
static void _factorialComputation(Map<String, dynamic> args) {
final number = args['number'] as int;
final sendPort = args['sendPort'] as SendPort;
int result = 1;
for (int i = 1; i <= number; i++) {
result *= i;
}
sendPort.send(result);
}

// Simulasi komputasi berat dengan delay
static Future<String> heavyComputation() async {
final receivePort = ReceivePort();
await Isolate.spawn(_heavyTask, receivePort.sendPort);
final result = await receivePort.first as String;
return result;
}
static void _heavyTask(SendPort sendPort) {
// Simulasi proses berat
int sum = 0;
for (int i = 0; i < 100000000; i++) {
sum += i;
}
sendPort.send('Komputasi selesai! Sum: $sum');
}
}

// ========================================
// 2. WORKMANAGER (Background Task)
// ========================================
// Callback yang dipanggil oleh WorkManager di background
// HARUS ada annotation @pragma('vm:entry-point')
@pragma('vm:entry-point')
void callbackDispatcher() {
Workmanager().executeTask((task, inputData) async {
print('Background Task dijalankan: $task');
print(' Input data: $inputData');
print(' Timestamp: ${DateTime.now()}');
try {
switch (task) {
case 'simpleTask':
await _handleSimpleTask();
break;
case 'periodicTask':
await _handlePeriodicTask();
break;
case 'syncTask':
await _handleSyncTask(inputData);
break;
default:
print('⚠ Task tidak dikenali: $task');
}
print('✅ Task $task selesai dengan sukses');
return Future.value(true); // Task berhasil
} catch (e, stackTrace) {
print('❌ Error di background task: $e');
print(' Stack trace: $stackTrace');
return Future.value(false); // Task gagal, akan di-retry
}
});
}

// Handler untuk simple task
Future<void> _handleSimpleTask() async {
print('Menjalankan Simple Task...');
// Simulasi proses (misal: sync data, cleanup, dll)
await Future.delayed(Duration(seconds: 2));
// Kirim notifikasi bahwa task selesai
await _showBackgroundNotification(
'Simple Task Selesai',
'Background task telah selesai dijalankan',
);
}

// Handler untuk periodic task
Future<void> _handlePeriodicTask() async {
print('Menjalankan Periodic Task...');
final now = DateTime.now();
final timeString = '${now.hour}:${now.minute}:${now.second}';
// Kirim notifikasi
await _showBackgroundNotification(
'Periodic Task',
'Task berkala dijalankan pada $timeString'
,
);
}

// Handler untuk sync task dengan data
Future<void> _handleSyncTask(Map<String, dynamic>? inputData) async {
print('Menjalankan Sync Task...');
final message = inputData?['message'] ?? 'No data';
// Simulasi sinkronisasi data
await Future.delayed(Duration(seconds: 1));
await _showBackgroundNotification(
'Sync Task',
'Data berhasil disinkronkan: $message'
,
);
}

// Helper untuk menampilkan notifikasi dari background
Future<void> _showBackgroundNotification(String title, String body)
async {
final plugin = FlutterLocalNotificationsPlugin();
const AndroidInitializationSettings initializationSettingsAndroid =
AndroidInitializationSettings('@mipmap/ic_launcher');
const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
const InitializationSettings initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
  iOS: initializationSettingsIOS,
);
await plugin.initialize(initializationSettings);
const AndroidNotificationDetails androidDetails =
AndroidNotificationDetails(
'background_channel',
'Background Tasks',
channelDescription: 'Notifikasi dari background tasks',
importance: Importance.high,
priority: Priority.high,
);
const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
const NotificationDetails notificationDetails = NotificationDetails(
  android: androidDetails,
  iOS: iosDetails,
);
await plugin.show(
DateTime.now().millisecond, // ID unik berdasarkan waktu
title,
body,
notificationDetails,
);
}

// ========================================
// WorkManager Service
// ========================================
class BackgroundService {
// Initialize WorkManager
static Future<void> initialize() async {
await Workmanager().initialize(
callbackDispatcher,
isInDebugMode: true, // Set false di production
);
print('WorkManager initialized');
}

// Register one-time task
static Future<void> registerOneTimeTask({
required String taskName,
Duration delay = const Duration(seconds: 10),
Map<String, dynamic>? inputData,
}) async {
try {
await Workmanager().registerOneOffTask(
taskName,
taskName,
initialDelay: delay,
inputData: inputData,
// Constraints dihapus untuk memastikan task bisa berjalan
// Jika perlu constraints, bisa ditambahkan kembali
);
print('One-time task registered: $taskName, delay: ${delay.inSeconds}s');
if (inputData != null) {
print(' Input data: $inputData');
}
} catch (e) {
print('error registering one-time task: $e');
rethrow;
}
}

// Register periodic task (minimal 15 menit)
static Future<void> registerPeriodicTask({
required String taskName,
Duration frequency = const Duration(minutes: 15),
}) async {
await Workmanager().registerPeriodicTask(
taskName,
taskName,
frequency: frequency,
// Constraints dihapus untuk memastikan task bisa berjalan
);
print('Periodic task registered: $taskName');
}

// Cancel specific task
static Future<void> cancelTask(String taskName) async {
await Workmanager().cancelByUniqueName(taskName);
print('❌ Task cancelled: $taskName');
}

// Cancel all tasks
static Future<void> cancelAllTasks() async {
await Workmanager().cancelAll();
print('All tasks cancelled');
}
}
