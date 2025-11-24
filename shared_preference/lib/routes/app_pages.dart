import 'package:get/get.dart';
import 'package:shared_preference/views/home_page.dart';
import 'package:shared_preference/views/login_page.dart';
import 'package:shared_preference/views/note_form_page.dart';

class AppPages {
  static final pages = [
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(
      name: '/home',
      page: () => HomePage(),
      children: [
        GetPage(name: '/note_form', page: () => NoteFormPage()),
        GetPage(name: '/note_form/:id', page: () => NoteFormPage()),
      ],
    ),
  ];
}