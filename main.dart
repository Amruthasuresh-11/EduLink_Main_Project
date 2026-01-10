import 'package:flutter/material.dart';

// Importing our screen files from screens folder
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';


void main() {
  // This is the main starting point of the Flutter app
  runApp(const EduLinkApp());
}

// Main App Class
class EduLinkApp extends StatelessWidget {
  const EduLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App name
      title: 'EduLink',

      // Removes the debug banner ("DEBUG") shown in top-right corner
      debugShowCheckedModeBanner: false,

      // Theme settings for the app (main color)
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),

      // First page that will open when app starts
      initialRoute: '/login',

      // Route navigation between screens
      // We can use Navigator.pushNamed() with these names
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),

      },
    );
  }
}
