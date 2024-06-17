import 'package:control_estacionamiento/app/view/home_page.dart';
import 'package:control_estacionamiento/app/view/login.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff008800);
    return MaterialApp(
      title: 'Control Estacionamiento',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: primary).copyWith(
          surface: const Color(0xffffffff)
        ),
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Inter',
          displayColor: const Color(0xff000000)
        ),

       useMaterial3: true,
      ),
      home: const LoginView(title: 'Login'),
    );
  }
}