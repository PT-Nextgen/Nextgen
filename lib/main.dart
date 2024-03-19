import 'package:flutter/material.dart';
import 'package:nextgen_app/pages/main_page.dart';
import 'package:nextgen_app/pages/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? initScreen;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nextgen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: initScreen == 1
          ? const MainPage(url: 'https://nextgen.co.id/')
          : const OnboardingPage(),
    );
  }
}
