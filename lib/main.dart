import 'package:flutter/material.dart';
import 'view/loginView.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: loginView(),
    );
  }
}
