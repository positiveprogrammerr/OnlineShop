import 'package:firebase_auth/firebase_auth.dart';


class Authentication {
  static FirebaseAuth _auth = FirebaseAuth.instance;

 static Future<void> registerWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error registering user: $e');
      throw e; // Rethrow the exception to handle it in the calling code
    }
  }

  static Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error signing in: $e');
      throw e; // Rethrow the exception to handle it in the calling code
    }
  }

  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
