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

  @override
  void dispose() {
    _boxesController.dispose();
    _weightController.dispose();
    super.dispose();
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
          backgroundColor: const Color(0xFFF2F3F5),

          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const BackButton(color: Colors.black),
            title: const Text(
              'Mark as Packed',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            centerTitle: false,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: const Color(0xFFE0E0E0), height: 1),
            ),
          ),

          body: Column(
            children: [

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// ORDER INFO SUMMARY
                      const Text(
                        'ORDER INFO SUMMARY',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFDE8D8),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "Status: ${order["status"]}",
                                      style: const TextStyle(
                                        color: Color(0xFFD4611A),
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
                                      color: Colors.black,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Row(
                                    children: [
                                      const Icon(Icons.person,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),

                                      Text(
                                        address["name"] ?? "Customer",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 80,
                                height: 80,
                                color: const Color(0xFF4A7C6F),
                                child: const Icon(Icons.checkroom,
                                    color: Colors.white70, size: 40),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// ITEM CHECKLIST
                      const Text(
                        'ITEM CHECKLIST',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ...products.map<Widget>((product) {

                        String itemName = product["name"];

                        return _buildChecklistItem(itemName);

                      }).toList(),

                      const SizedBox(height: 24),

                      /// PACKAGING DETAILS
                      const Text(
                        'PACKAGING DETAILS',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [

                          Expanded(
                            child: _buildInputField(
                              label: 'Number of Boxes',
                              hint: 'e.g. 1',
                              controller: _boxesController,
                              keyboardType: TextInputType.number,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _buildInputField(
                              label: 'Package Weight (kg)',
                              hint: 'e.g. 1.5',
                              controller: _weightController,
                              keyboardType:
                              const TextInputType.numberWithOptions(
                                  decimal: true),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              /// BOTTOM BUTTON
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),

                child: Column(
                  children: [

                    SizedBox(
                      width: double.infinity,
                      height: 54,

                      child: ElevatedButton.icon(
                        onPressed: () async {

                          int boxes =
                              int.tryParse(_boxesController.text) ?? 1;

                          double weight =
                              double.tryParse(_weightController.text) ?? 0;

                          await databaseReference.child(widget.orderId).update({

                            "status": "packed",

                            "packingDetails": {
                              "boxes": boxes,
                              "weight": weight
                            }

                          });

                          //Get.to(() => const OrderConfirmed());
                          Get.to(() => OrderConfirmed(orderId: widget.orderId,));
                        },

                        icon: const Icon(Icons.local_shipping,
                            color: Colors.white, size: 20),

                        label: const Text(
                          'Confirm & Generate Shipping Label',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChecklistItem(String item) {

    final bool isChecked = _checkedItems[item] ?? false;

    return GestureDetector(
      onTap: () {
        setState(() {
          _checkedItems[item] = !isChecked;
        });
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Row(
          children: [

            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 24,
              height: 24,

              decoration: BoxDecoration(
                color: isChecked ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isChecked ? Colors.blue : const Color(0xFFCCCCCC),
                  width: 1.5,
                ),
              ),

              child: isChecked
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),

            const SizedBox(width: 14),

            Text(
              item,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          keyboardType: keyboardType,

          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,

            contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 16),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}