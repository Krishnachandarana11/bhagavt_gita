import 'package:bhagavat_gita/provider/language.dart';
import 'package:bhagavat_gita/view/Details/Details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view/HomePage/HomePage.dart';
import 'view/HomePage/splash.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashScreen(),
        'Home': (context) => HomePage(),
        'Detail': (context) => DetailPage(),
      },
    );
  }
}
