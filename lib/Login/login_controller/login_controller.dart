import 'package:e_commarce_admin/Profile_setup/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../UI/Home/Bottom_Navigation/bottom_navigation.dart';

class AuthController extends GetxController {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  var isLoggedIn = false.obs;
  var isLoading = false.obs;




  Future<void> login(String email, String password) async {

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    try {
      isLoading.value = true;

      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (userCredential.user != null) {

        String uid = userCredential.user!.uid;


        DataSnapshot snapshot =
        await dbRef.child("admins").child(uid).get();

        if (snapshot.exists) {
          Get.offAll(() => BottomNavigation());
        } else {
          Get.offAll(() => const Profile());
        }

        Get.snackbar(
          "Success",
          "Login Successful",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

    } on FirebaseAuthException catch (e) {

      String message = "Login Failed";

      if (e.code == 'user-not-found') {
        message = "No user found";
      } else if (e.code == 'wrong-password') {
        message = "Incorrect password";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email";
      }

      Get.snackbar(
        "Error",
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

    } finally {
      isLoading.value = false;
    }
  }




  Future<void> forgotpassword(String email) async {

    if (email.isEmpty) {
      Get.snackbar("Error", "Enter email to reset password");
      return;
    }

    try {

      await _auth.sendPasswordResetEmail(email: email.trim());

      Get.snackbar(
        "Reset Email sent",
        "Check your email to reset password",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } on FirebaseAuthException catch (e) {

      String message = "Error";

      if (e.code == 'user-not-found') {
        message = "No user found";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email";
      }

      Get.snackbar(
        "Error",
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }




  Future<void> saveProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String bio,
  }) async {

    if (name.isEmpty || phone.isEmpty) {
      Get.snackbar("Error", "Fill required fields");
      return;
    }

    try {

      isLoading.value = true;

      String uid = _auth.currentUser!.uid;


      await dbRef.child("admins").child(uid).set({
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "bio": bio,
        "profileCompleted": true,
        "createdAt": DateTime.now().toString(),
      });

      Get.offAll(() => BottomNavigation());

      Get.snackbar(
        "Success",
        "Profile Completed",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } catch (e) {

      Get.snackbar("Error", e.toString());

    } finally {
      isLoading.value = false;
    }
  }

}