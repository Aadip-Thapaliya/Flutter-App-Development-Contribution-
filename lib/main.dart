import 'package:flutter/material.dart';
import 'package:stockmarket/splashscreen.dart';

void main() => runApp(DippayApp());

class DippayApp extends StatelessWidget {
  const DippayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreen(), debugShowCheckedModeBanner: false);
  }
}
