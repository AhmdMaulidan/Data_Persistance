import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preference/controllers/auth_controller.dart';
import 'package:shared_preference/routes/app_pages.dart';

void main() {
  testWidgets('Login Page Smoke Test', (WidgetTester tester) async {
    // Setup controllers that the UI depends on.
    Get.put(AuthController());

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/login',
        getPages: AppPages.pages,
      ),
    );

    // Verify that the login page is shown.
    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget); // Expect one text field for the username
    expect(find.byType(ElevatedButton), findsOneWidget); // Expect a login button
  });
}
