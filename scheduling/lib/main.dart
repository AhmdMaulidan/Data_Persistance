import 'package:flutter/material.dart';
import 'package:scheduling/screen/home_page.dart';
import 'package:scheduling/services/background_service.dart';
import 'package:scheduling/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize notification service
  await NotificationService().initialize();
  // Initialize background service
  await BackgroundService.initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scheduling Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
