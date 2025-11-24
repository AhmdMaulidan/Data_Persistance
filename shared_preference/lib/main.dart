import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preference/controllers/auth_controller.dart';
import 'package:shared_preference/controllers/note_controller.dart';
import 'package:shared_preference/database/db_helper.dart';
import 'package:shared_preference/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB();
  Get.put(AuthController());
  Get.put(NoteController());
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: AppPages.pages,
    ),
  );
}