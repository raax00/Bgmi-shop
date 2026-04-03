import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/auth_screen.dart';
import 'screens/main_navigation.dart';
// import 'firebase_options.dart'; // Uncomment this after running flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase (Make sure to pass options if testing on web/iOS)
  await Firebase.initializeApp(); 
  runApp(const DreamStoreApp());
}

class DreamStoreApp extends StatelessWidget {
  const DreamStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dream Store',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF2F2F7), // Premium iOS Light Gray
        primaryColor: Colors.black,
        fontFamily: '.SF Pro Display',
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CupertinoActivityIndicator(radius: 20)));
          }
          if (snapshot.hasData) {
            return const MainNavigation();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
