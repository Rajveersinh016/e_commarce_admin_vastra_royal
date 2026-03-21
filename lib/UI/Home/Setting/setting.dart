import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Login/login_screen.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {

  bool pushNotifications = true;
  bool maintenanceMode = false;

  final Color primaryColor = const Color(0xFF6C63FF);
  final Color bgColor = const Color(0xFFF5F6FA);

  /// 🔥 CARD
  Widget buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Icon(icon, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),

          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  /// TEXT FIELD
  Widget buildTextField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// DROPDOWN
  Widget buildDropdown(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: value,
        items: [
          "INR - Indian Rupee",
          "USD - US Dollar",
        ]
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) {},
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// LIST TILE
  Widget buildListTile(String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: Icon(Icons.arrow_forward_ios,
          size: 16, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Admin Settings",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Vastra Royale Pro",
              style: TextStyle(
                  fontSize: 12, color: primaryColor),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            buildCard(
              title: "Store Profile",
              icon: Icons.store,
              child: Column(
                children: [
                  buildTextField("Store Name", "Vastra Royale Main"),
                  buildTextField("Contact Email", "admin@vastraroyale.com"),
                  buildDropdown("Currency", "INR - Indian Rupee"),
                ],
              ),
            ),

            buildCard(
              title: "Payments & Taxes",
              icon: Icons.payments,
              child: Column(
                children: [
                  buildTextField("Tax ID / GSTIN", "Enter GSTIN"),
                  buildListTile("Payment Gateways", "Stripe, Razorpay"),
                  buildListTile("Payout Schedule", "Weekly"),
                ],
              ),
            ),

            buildCard(
              title: "Team Management",
              icon: Icons.people,
              child: Column(
                children: [
                  buildListTile("Manage Staff Accounts", "8 members"),
                  buildListTile("Roles & Permissions", "Manage access"),
                ],
              ),
            ),

            buildCard(
              title: "App Preferences",
              icon: Icons.settings,
              child: Column(
                children: [

                  SwitchListTile(
                    activeColor: primaryColor,
                    title: const Text("Push Notifications"),
                    subtitle: const Text("Order & inventory alerts"),
                    value: pushNotifications,
                    onChanged: (v) {
                      setState(() => pushNotifications = v);
                    },
                  ),

                  SwitchListTile(
                    activeColor: Colors.red,
                    title: const Text("Maintenance Mode",
                        style: TextStyle(color: Colors.red)),
                    subtitle: const Text("Disable storefront"),
                    value: maintenanceMode,
                    onChanged: (v) {
                      setState(() => maintenanceMode = v);
                    },
                  ),
                ],
              ),
            ),

            buildCard(
              title: "Support & Legal",
              icon: Icons.help,
              child: Column(
                children: [
                  buildListTile("Admin Guide", ""),
                  buildListTile("Privacy Policy", ""),
                  buildListTile("Terms of Service", ""),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Get.offAll(() => LoginScreen());
                },
                child: const Text(
                  "Log out",
                  style: TextStyle(
                      fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "LAST SAVED: TODAY AT 2:45 PM",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}