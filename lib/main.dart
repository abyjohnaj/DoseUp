import 'package:doseup/landingpage.dart';
import 'package:doseup/search_page.dart';
import 'package:doseup/compare_page.dart';
import 'package:doseup/shortage_report_page.dart';
import 'package:doseup/chatbot_page.dart';
import 'package:doseup/prescription_reader_page.dart';
import 'package:flutter/material.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LandingPage(),
      routes: {
        '/landing': (context) => const LandingPage(),
        '/search': (context) => const SearchPage(),
        '/compare': (context) => const ComparePage(),
        '/shortage': (context) => const ShortageReportPage(),
        '/chatbot': (context) => const ChatbotPage(),
        '/prescription': (context) => const PrescriptionReaderPage(),
      },
    );
  }
}