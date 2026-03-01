import 'package:e_commarce_admin/Login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../UI/Home/Bottom_Navigation/bottom_navigation.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return BottomNavigation();
    } else {
      return LoginScreen();
    }
  }
}