import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/authanticationscreen/login_screen.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: checkIfLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // أثناء التحميل
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            // إذا تم التحقق
            final isLoggedIn = snapshot.data ?? false;
            return isLoggedIn ? MainScreen() : Loginscreen();
          }
        },
      ),
    );
  }
}
