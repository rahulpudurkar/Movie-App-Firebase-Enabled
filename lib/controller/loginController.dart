import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movielist/view/signInView.dart';
import 'package:movielist/view/home.dart';

class loginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signIn(BuildContext context) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await _saveUserIdInCache(userCredential.user?.uid);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => home()),
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        String errorMessage;

        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'Invalid email format';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password';
            break;
          case 'user-not-found':
            errorMessage = 'No user found with this email';
            break;
          case 'user-disabled':
            errorMessage = 'This user account has been disabled';
            break;
          default:
            errorMessage = 'Failed to sign in: ${e.message}';
            break;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in: $e')),
        );
      }
    }
  }

  void goToSignUp(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => signInView()));
  }

  Future<void> _saveUserIdInCache(String? userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(userId ?? 'dcnj');
    await prefs.setString('userId', userId ?? '');
  }
}
