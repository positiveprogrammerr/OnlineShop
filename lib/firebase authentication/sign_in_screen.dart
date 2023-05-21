// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/constants/color.dart';
import 'package:online_shop/firebase%20authentication/auth.dart';
import 'package:online_shop/firebase%20authentication/utils.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = 'sign_up';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSignIn = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _toggleAuthMode() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }

  Future<void> _submitForm() async {
    _validateForm(); // Manually validate the form fields

    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      try {
        if (_isSignIn) {
          await Authentication.signInWithEmailAndPassword(email, password);
        } else {
          await Authentication.registerWithEmailAndPassword(email, password);
        }

        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        String errorMessage = 'Authentication failed. Please try again later.';
        if (e is FirebaseException) {
          errorMessage = e.message!;
        }
         Utils.showSnackBar(errorMessage);
      }
    }
  }

  void _validateForm() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Utils.showSnackBar('Please enter your email and password.');
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd1ecfa),
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    'https://static.vecteezy.com/system/resources/previews/001/950/076/original/online-shopping-concept-smartphone-online-store-free-vector.jpg',
                    width: 250,
                    height: 250,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.bgColor,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      _isSignIn ? 'Sign In' : 'Sign Up',
                      style: const TextStyle(fontSize: 19.0),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: _toggleAuthMode,
                    child: Text(
                      _isSignIn
                          ? 'Don\'t have an account? Sign Up'
                          : 'Already have an account? Sign In',
                      style: const TextStyle(color: Colors.grey,fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
