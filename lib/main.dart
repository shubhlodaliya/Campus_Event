import 'package:flutter/material.dart';
// import 'screen/login_page.dart';
import 'screen/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Event Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splash(), // Start with the LoginPage
    );
  }
}
