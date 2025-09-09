import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/homescreen.dart';
import 'viewmodels/home_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MFAR SuperApp',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      home: ChangeNotifierProvider(create: (context) => HomeViewModel(), child: const HomeScreen()),
    );
  }
}
