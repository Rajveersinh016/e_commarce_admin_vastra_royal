import 'package:e_commarce_admin/Login/login_controller/login_controller.dart';
import 'package:e_commarce_admin/Profile_setup/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Colors/colors.dart';
import '../UI/Home/Bottom_Navigation/bottom_navigation.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final AuthController authController = Get.put(AuthController());


  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool passwordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,


      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      body: ListView(
        children: [

          const SizedBox(height: 20),


          Center(
            child: Container(
              height: Get.height * 0.07,
              width: Get.width * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Appcolor.logo_bg,
              ),
              child: Center(
                child: Text(
                  'VR',
                  style: TextStyle(
                    color: Appcolor.logo_text,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              'Welcome Back',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),

          const Center(
            child: Text(
              'Login to continue to Vastra Royale',
              style: TextStyle(color: Colors.grey),
            ),
          ),

          const SizedBox(height: 30),

          /// EMAIL FIELD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text('EMAIL ADDRESS',
                    style: TextStyle(color: Appcolor.text_main)),

                const SizedBox(height: 5),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.email_outlined,
                        color: Appcolor.hint_text),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// PASSWORD FIELD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text('PASSWORD',
                    style: TextStyle(color: Appcolor.text_main)),

                const SizedBox(height: 5),

                TextField(
                  controller: passwordController,
                  obscureText: passwordHidden,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.lock_outline,
                        color: Appcolor.hint_text),
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordHidden = !passwordHidden;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// FORGOT PASSWORD
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  if(emailController.text.trim().isEmpty){
                    Get.snackbar("Error", "Enter email to reset password",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,);
                  }else{
                    authController.forgotpassword(emailController.text);
                  }


                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// LOGIN BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: authController.isLoading.value
                   ? null
                    : (){
                  authController.login(emailController.text, passwordController.text);
                }
                ,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child:authController.isLoading.value
                 ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),




          const SizedBox(height: 30),
        ],
      ),
    );
  }
}