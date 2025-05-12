import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_house/ui/pages/admin_dashboard.dart';
import 'package:project_house/ui/pages/home_page.dart';

import 'firebase_options.dart';
import 'package:project_house/ui/pages/start_page.dart';
import 'package:project_house/ui/pages/login_page.dart';
import 'package:project_house/ui/pages/signup_page.dart';
import 'package:project_house/ui/pages/kosan_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext contextP) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => StartPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
        '/admin': (context) => DashboardAdmin(),
        '/kosan': (context) => KosanListPage(),
      },
    );
  }
}
