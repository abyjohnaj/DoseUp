import 'package:doseup/pages/login_page.dart';
import 'package:doseup/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:doseup/pages/dashboard_page.dart';
import 'package:doseup/pages/landingpage.dart';
import 'package:doseup/pages/prescription_page.dart';
import 'package:doseup/pages/search_page.dart';
import 'package:doseup/pages/forum_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zgmllotafouympynfkzq.supabase.co',
    anonKey: 'sb_publishable_9GyvR_ujU8PSyswCu4iQmw_UN9mNI1v',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DoseUp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: LandingPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/search': (context) => const SearchPage(),
        '/prescription': (context) => const PrescriptionPage(),
        '/forum': (context) => const ForumPage(),
      },
    );
  }
}