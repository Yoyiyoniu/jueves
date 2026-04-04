import 'package:flutter/material.dart';
import 'package:jueves/home/home_page.dart';
import 'package:jueves/theme/nothing_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JUEVES',
      theme: NothingTheme.darkTheme(),
      home: const HomePage(),
    );
  }
}
