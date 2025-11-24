import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scheduling/services/background_service.dart';
import '../services/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Timer state
  int _timerSeconds = 10;
  Timer? _timer;
  bool _isTimerRunning = false;

  // Notification service
  final NotificationService _notificationService = NotificationService();

  // Isolate state
  bool _isCalculating = false;
  String _isolateResult = '';

  @override
  void initState() {
    super.initState();
    // Initialize notification service and request permissions
    _notificationService.initialize();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notificationService.dispose();
    super.dispose();
  }

  // Timer methods
  void _startTimer() {
    setState(() {
      _isTimerRunning = true;
      _timerSeconds = 10;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          timer.cancel();
          _isTimerRunning = false;
          _showSnackBar('Timer selesai!');
        }
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _timer?.cancel();
      _isTimerRunning = false;
      _timerSeconds = 10;
    });
  }

  // Notification methods
  Future<void> _showSimpleNotification() async {
    try {
      await _notificationService.showSimpleNotification(
        title: '📬 Notifikasi Sederhana',
        body: 'Ini adalah contoh notifikasi instant!',
      );
      _showSnackBar('Notifikasi sederhana ditampilkan');
    } catch (e) {
      _showSnackBar('Error: $e');
      print('Error showing notification: $e');
    }
  }

  Future<void> _scheduleNotification() async {
    try {
      await _notificationService.scheduleNotification(
        title: '⏰ Notifikasi Terjadwal',
        body: 'Notifikasi ini muncul 5 detik setelah dijadwalkan',
        delay: const Duration(seconds: 5),
      );
      _showSnackBar('Notifikasi akan muncul dalam 5 detik');
    } catch (e) {
      _showSnackBar('Error: $e');
      print('Error scheduling notification: $e');
    }
  }

  Future<void> _cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
    _showSnackBar('Semua notifikasi dibatalkan');
  }

  // Isolate method
  Future<void> _runIsolateComputation() async {
    setState(() {
      _isCalculating = true;
      _isolateResult = 'Menghitung...';
    });
    try {
      // Hitung faktorial 20 di background thread
      final result = await IsolateService.calculateFactorial(20);
      setState(() {
        _isolateResult = 'Faktorial 20 = $result';
        _isCalculating = false;
      });
      _showSnackBar('Komputasi di Isolate selesai!');
    } catch (e) {
      setState(() {
        _isolateResult = 'Error: $e';
        _isCalculating = false;
      });
    }
  }

  // 4. WORKMANAGER (Background Task)
  Future<void> _registerOneTimeTask() async {
    await BackgroundService.registerOneTimeTask(
      taskName: 'simpleTask',
      delay: const Duration(seconds: 10),
    );
    _showSnackBar('One-time task dijadwalkan (10 detik)');
  }

  Future<void> _registerPeriodicTask() async {
    await BackgroundService.registerPeriodicTask(
      taskName: 'periodicTask',
      frequency: const Duration(minutes: 15),
    );
    _showSnackBar('Periodic task dijadwalkan (setiap 15 menit)');
  }

  Future<void> _registerSyncTask() async {
    await BackgroundService.registerOneTimeTask(
      taskName: 'syncTask',
      delay: const Duration(seconds: 5),
      inputData: {'message': 'Data dari aplikasi'},
    );
    _showSnackBar('Sync task dijadwalkan (5 detik)');
  }

  Future<void> _cancelAllBackgroundTasks() async {
    await BackgroundService.cancelAllTasks();
    _showSnackBar('Semua background task dibatalkan');
  }

  // UI Helper methods
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: color != null ? Colors.white : null,
          minimumSize: const Size(double.infinity, 48),
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduling Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionCard(
            title: '1. Timer Scheduling',
            icon: Icons.timer,
            color: Colors.blue,
            children: [
              Text(
                'Countdown: $_timerSeconds detik',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isTimerRunning ? null : _startTimer,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isTimerRunning ? _stopTimer : null,
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: '2. Local Notifications',
            icon: Icons.notifications,
            color: Colors.orange,
            children: [
              _buildButton(
                label: 'Notifikasi Sederhana',
                icon: Icons.message,
                onPressed: _showSimpleNotification,
              ),
              _buildButton(
                label: 'Notifikasi Terjadwal (5 detik)',
                icon: Icons.schedule,
                onPressed: _scheduleNotification,
              ),
              _buildButton(
                label: 'Batalkan Semua Notifikasi',
                icon: Icons.cancel,
                color: Colors.red,
                onPressed: _cancelAllNotifications,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: '3. Background Process (Isolate)',
            icon: Icons.memory,
            color: Colors.green,
            children: [
              if (_isolateResult.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _isolateResult,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              _buildButton(
                label: _isCalculating
                    ? 'Menghitung...'
                    : 'Hitung Faktorial (Isolate)',
                icon: Icons.calculate,
                onPressed: _isCalculating ? null : _runIsolateComputation,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Menghitung faktorial 20 tanpa freeze UI',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: '4. WorkManager (Background Task)',
            icon: Icons.work,
            color: Colors.purple,
            children: [
              _buildButton(
                label: 'One-Time Task (10 detik)',
                icon: Icons.play_circle,
                onPressed: _registerOneTimeTask,
              ),
              _buildButton(
                label: 'Periodic Task (15 menit)',
                icon: Icons.repeat_one,
                onPressed: _registerPeriodicTask,
              ),
              _buildButton(
                label: 'Sync Task dengan Data (5 detik)',
                icon: Icons.sync,
                onPressed: _registerSyncTask,
              ),
              _buildButton(
                label: 'Batalkan Semua Task',
                icon: Icons.cancel,
                color: Colors.red,
                onPressed: _cancelAllBackgroundTasks,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '💡 Background task akan mengirim notifikasi ketika selesai',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
