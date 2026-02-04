import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/homemodel.dart';
import 'view/home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HomePageProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Homepage(),
    );
  }
}
