import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

abstract class AuthBase {
  User? get currentUser;
  Future<User?> signInAnonymously();
  Future<void> signOut();
  Stream<User?> authStateChanges();
  Future<User?> signInGoogle();
  Future<User?> signInWithFacebook();
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> createAccountWithEmailAndPassword(
      String email, String password);
}

class Auth implements AuthBase {
  User? get currentUser => FirebaseAuth.instance.currentUser;
  final _firebaseAuth = FirebaseAuth.instance;
 
  

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  Future<User?> signInAnonymously() async {
    final userCredentials = await _firebaseAuth.signInAnonymously();
    return userCredentials.user;
  }

  @override
  Future<User?> signInGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
            code: 'ERR_ID_NOT_FOUND',
            message: 'Error no se ha encontrado id de google');
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERR_ABORTED_BY_USER',
        message: 'Error registro cancelado por usuario',
      );
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final UserCredential = await _firebaseAuth.signInWithCredential(
        EmailAuthProvider.credential(email: email, password: password));
    return UserCredential.user;
  }

  Future<User?> createAccountWithEmailAndPassword(
      String email, String password) async {
    final UserCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return UserCredential.user;
  }

  @override
  Future<User?> signInWithFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        final UserCredential = await _firebaseAuth.signInWithCredential(
            FacebookAuthProvider.credential(accessToken!.token));
        break;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
            code: 'ERR_ABORTED_BY_USER',
            message: 'Error registro cancelado por usuario');
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
            code: 'ERR_FACEBOOK_LOGIN-FAIL',
            message: response.error!.developerMessage);
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    googleSignIn.signOut();
    final fbSignIn = FacebookLogin();
    await fbSignIn.logOut();
    await _firebaseAuth.signOut();
  }
}
