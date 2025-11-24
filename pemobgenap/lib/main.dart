import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pemobgenap/view/bmi_home_page.dart';
import 'package:pemobgenap/view/detail_history_page.dart';
import 'package:pemobgenap/view/history_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BMI Calculator GetX',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => BmiHomePage()),
        GetPage(name: '/history', page: () => HistoryPage()),
        GetPage(name: '/history/:index', page: () => DetailHistoryPage()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
