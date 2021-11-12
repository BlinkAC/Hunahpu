import 'package:cursoflutter/services/auth.dart';
import 'package:flutter/material.dart';
import 'email_sigin_form.dart';

// ignore: camel_case_types
class signInWithEmailPage extends StatelessWidget {
  signInWithEmailPage({required this.auth});
  final AuthBase auth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar sesión con correo'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Card(
            child: EmailSiginForm(
              auth: auth,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
