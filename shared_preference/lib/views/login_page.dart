import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preference/controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  final emailC = TextEditingController();
  final passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailC,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passC,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.login(emailC.text, passC.text);
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}