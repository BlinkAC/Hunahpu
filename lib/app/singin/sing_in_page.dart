import 'package:cursoflutter/app/singin/email_sigin_page.dart';
import 'package:cursoflutter/common%20widgets/custom_elevated_button.dart';
import 'package:cursoflutter/services/auth.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class SingInPage extends StatelessWidget {
  SingInPage({required this.auth});
  final AuthBase auth;
  Future<void> _singInAnnonymous() async {
    try {
     await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _singInWithGoogle() async {
    try {
      await auth.signInGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _singInWithFacebook() async {
    try {
    await auth.signInWithFacebook();
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => signInWithEmailPage(auth: auth),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verificador de precios'),
        elevation: 2,
      ),
      body: _singInContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _singInContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Iniciar sesión',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 48,
          ),
          CustomElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Image.network(
                      'https://www.paderborn-meinestadt.de/wp-content/uploads/2016/07/Facebook-Logo-Paderborn.png'),
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.all(4),
                ),
                // Image.network(
                //     'https://www.paderborn-meinestadt.de/wp-content/uploads/2016/07/Facebook-Logo-Paderborn.png'),
                Text(
                  'Iniciar sesión con Facebook',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                // Opacity(
                //   opacity: 0.0,
                //   child: Image.network(
                //       'https://www.paderborn-meinestadt.de/wp-content/uploads/2016/07/Facebook-Logo-Paderborn.png'),
                // )
              ],
            ),
            color: Color(0xFF334D92),
            radius: 4.0,
            onPressed: _singInWithFacebook,
          ),
          SizedBox(height: 8.0),
          CustomElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Image.network(
                      'https://imagepng.org/wp-content/uploads/2019/08/google-icon.png'),
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.all(4),
                ),
                // Image.network(
                //     'https://imagepng.org/wp-content/uploads/2019/08/google-icon.png'),
                Text(
                  'Iniciar sesión con Google',
                  style: TextStyle(color: Colors.black87, fontSize: 15),
                ),
                // Opacity(
                //   opacity: 0.0,
                //   child: Image.network(
                //       'https://imagepng.org/wp-content/uploads/2019/08/google-icon.png'),
                // )
              ],
            ),
            color: Colors.white,
            radius: 4.0,
            onPressed:  _singInWithGoogle,
          ),
          SizedBox(height: 8.0),
          CustomElevatedButton(
            child: Text(
              'Iniciar sesión con Correo',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            color: Colors.teal.shade700,
            radius: 4.0,
            onPressed: ()=>_signInWithEmail(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'o',
            style: TextStyle(fontSize: 14, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          CustomElevatedButton(
            child: Text(
              'Ingrese de forma anonima',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            color: Colors.lime.shade600,
            radius: 4.0,
            onPressed: _singInAnnonymous,
          ),
        ],
      ),
    );
  }
}
