import 'package:attendence_app/screens/auth/login_screen.dart';
import 'package:attendence_app/screens/auth/register_screen.dart';
import 'package:attendence_app/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showLogin = true;

  void _toogleView() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // buat ngasih tau kalo pertama kali user buka pastinya balom punya akun, dia akan melakukan register. nah ketika udh regis, maka dia sekarang statusnya adalah user baru
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {  // snapshot = kalo kita punya data dari third partdnjenfkncn 
          return HomeScreen();
        }

        return _showLogin
            ? LoginScreen(onRegisterTap: _toogleView)
            : RegisterScreen(onLoginTap: _toogleView);
      }
    );
  }
}