import 'package:cursoflutter/app/singin/landing_page.dart';
import 'package:cursoflutter/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pricy',
        theme: ThemeData(primarySwatch: Colors.green),
        home: LandingPage(auth: Auth()),
      );
  }
}
