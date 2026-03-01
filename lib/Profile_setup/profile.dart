import 'dart:io';

import 'package:e_commarce_admin/Login/login_controller/login_controller.dart';
import 'package:e_commarce_admin/UI/Home/Bottom_Navigation/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  Widget buildField(
      String label,
      String hint, {
        bool lock = false,
        int maxLines = 1,
        TextEditingController? controller,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(label,
              style:
              const TextStyle(fontWeight: FontWeight.w600)),

          const SizedBox(height: 6),

          TextField(
            controller: controller,
            maxLines: maxLines,
            //readOnly: lock,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: const Color(0xfff1f2f4),
              suffixIcon:
              lock ? const Icon(Icons.lock, size: 18) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  final addresscontroller = TextEditingController();
  final biocontroller = TextEditingController();

  final AuthController authController = Get.put(AuthController());


  File? image_file;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(
         source: ImageSource.gallery
    );

    if(pickedFile != null){
      setState(() {
        image_file = File(pickedFile.path);
      });
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f5f7),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: const [

            SizedBox(width: 8),
            Text(
              "VASTRA ROYALE",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text("ADMIN PANEL"),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [


            Container(
              padding:EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [


                  Text(
                    "Welcome to Vastra Royale Admin",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Your journey begins here. Let's complete your professional profile setup.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),

                  SizedBox(height: 30),


                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child:CircleAvatar(
                          backgroundImage: image_file !=null
                              ? FileImage(image_file!)
                              : AssetImage('lib/assets/images/Man.png') as ImageProvider

                        )
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),



                  SizedBox(height: 25),


                  buildField("Full Name *", "Enter your full name",controller: namecontroller),


                  buildField("Professional Email",
                      "admin@vastraroyale.com",
                      lock: true,
                      controller: emailcontroller,
                  ),


                  buildField("Phone Number *", "+91 9773227698",controller: phonecontroller),


                  buildField("Office/Business Address",
                      "Suite 402, Royale Plaza",controller: addresscontroller),


                  buildField(
                    "Bio / Role Description",
                    "Briefly describe your responsibilities...",
                    maxLines: 4,
                    controller: biocontroller
                  ),

                   SizedBox(height: 20),

                   Divider(),

                   SizedBox(height: 10),

                  Row(
                    children:[
                      Icon(Icons.info, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "You can update these details later in settings.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 25),


                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                         EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        authController.saveProfile(
                            name: namecontroller.text,
                            email: emailcontroller.text,
                            phone: phonecontroller.text,
                            address:addresscontroller.text,
                            bio:biocontroller.text
                        );
                        Get.to(
                            () => BottomNavigation(),
                            transition: Transition.rightToLeft,
                            duration: Duration(seconds: 1),
                        );
                      },
                      child:  Text(
                        "Complete Setup",
                        style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),


          ],
        ),
      ),
    );
  }



  }
