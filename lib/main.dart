import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:movie_buzz/routes/app_route_config.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(
    fileName: ".env",
  );

  sleep(const Duration(seconds: 2));
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter().router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFFFFD700),
          secondary: Color(0xFF000000),
          surface: Color(0xFF121212),
          background: Color(0xFF000000),
          error: Color(0xFFCF6679),
          onPrimary: Color(0xFF000000),
          onSecondary: Color(0xFFFFFFFF),
          onSurface: Color(0xFFFFFFFF),
          onBackground: Color(0xFFFFFFFF),
          onError: Color(0xFF000000),
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
          bodyMedium: TextStyle(color: Color(0xFFFFFFFF)),
          bodySmall: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        fontFamily: 'Rubik',
      ),
    );
  }
}
