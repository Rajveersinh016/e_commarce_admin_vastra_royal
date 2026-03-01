import 'package:e_commarce_admin/Login/login_screen.dart';
import 'package:e_commarce_admin/auth_checker/auth_checker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../UI/Home/Bottom_Navigation/bottom_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
     super.initState();
     gotoHome();
  }

   void gotoHome(){
     Future.delayed(Duration(seconds: 3),(){
       Get.offAll(AuthChecker());
     });
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(image:AssetImage('lib/assets/images/splash.png'),fit: BoxFit.fill)
        ),
      )
        ,
    );
  }
}
