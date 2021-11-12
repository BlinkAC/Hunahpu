import 'package:cursoflutter/final_pages/home.dart';
import 'package:cursoflutter/app/singin/sing_in_page.dart';
import 'package:cursoflutter/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return SingInPage(
              auth: auth,
            );
          }
          return HomePage();
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        );
      },
    );
  }
}
