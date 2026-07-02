import 'package:flutter/material.dart';

import '../features/home/home_screen.dart';

class SoccerApp extends StatelessWidget {
  const SoccerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soccer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
