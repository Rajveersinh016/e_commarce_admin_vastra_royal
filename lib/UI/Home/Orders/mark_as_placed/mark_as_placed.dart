import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../order_confirmed/order_confirmed.dart';

class MarkAsPackedScreen extends StatefulWidget {
  final String orderId;

  const MarkAsPackedScreen({super.key, required this.orderId});

  @override
  State<MarkAsPackedScreen> createState() => _MarkAsPackedScreenState();
}

class _MarkAsPackedScreenState extends State<MarkAsPackedScreen> {

  final DatabaseReference databaseReference =
  FirebaseDatabase.instance.ref().child("orders");

  final TextEditingController _boxesController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  Map<String, bool> _checkedItems = {};

  final Color primaryColor = const Color(0xFF6C63FF);
  final Color bgColor = const Color(0xFFF5F6FA);

  @override
  void dispose() {
    _boxesController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  /// 🔥 CARD
  Widget card({required Widget child}) {
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
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseReference.child(widget.orderId).onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {

        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        Map order = snapshot.data!.snapshot.value as Map;
        Map address = order["address"] ?? {};
        List products = order["products"] ?? [];

        for (var p in products) {
          _checkedItems.putIfAbsent(p["name"], () => false);
        }

        return Scaffold(
          backgroundColor: bgColor,

          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Mark as Packed',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: Column(
            children: [

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [

                      /// ORDER INFO
                      card(
                        child: Row(
                          children: [

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "Status: ${order["status"]}",
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    "Order #${order["orderId"]}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    address["name"] ?? "Customer",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 10),

                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.inventory,
                                  color: primaryColor, size: 30),
                            )
                          ],
                        ),
                      ),

                      /// CHECKLIST
                      card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Item Checklist",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),

                            ...products.map<Widget>((p) {
                              return _checkItem(p["name"]);
                            }).toList(),
                          ],
                        ),
                      ),

                      /// PACKAGING
                      card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Packaging Details",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Expanded(
                                  child: _inputField(
                                      _boxesController, "Boxes"),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _inputField(
                                      _weightController, "Weight"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// BUTTON
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {

                          int boxes =
                              int.tryParse(_boxesController.text) ?? 1;

                          double weight =
                              double.tryParse(_weightController.text) ?? 0;

                          await databaseReference
                              .child(widget.orderId)
                              .update({
                            "status": "packed",
                            "packingDetails": {
                              "boxes": boxes,
                              "weight": weight
                            }
                          });

                          Get.to(() =>
                              OrderConfirmed(orderId: widget.orderId));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding:
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                            "Confirm & Generate Shipping Label",style: TextStyle(color: Colors.white),),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cancel"),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _checkItem(String item) {
    final isChecked = _checkedItems[item] ?? false;

    return GestureDetector(
      onTap: () {
        setState(() {
          _checkedItems[item] = !isChecked;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isChecked ? Icons.check_circle : Icons.circle_outlined,
              color: isChecked ? primaryColor : Colors.grey,
            ),
            const SizedBox(width: 10),
            Text(item),
          ],
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}