import 'package:darain_travels/utils/firebase_api.dart';
import 'package:darain_travels/utils/payment_demo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/splashScreen.dart';
import 'utils/myColors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: mainTheme,
        colorScheme: const ColorScheme.light().copyWith(primary: mainTheme.shade900),
      ),
      home: SplashScreen(),
    );
  }
}
