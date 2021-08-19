
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yellow_class/authentication/loginscreen.dart';
import 'package:yellow_class/home.dart';

class Authenticate extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return MyHomePage(title: 'Yellow Class');
    } else {
      return LoginScreen();
    }
  }
}