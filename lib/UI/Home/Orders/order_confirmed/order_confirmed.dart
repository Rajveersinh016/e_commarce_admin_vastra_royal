import 'package:e_commarce_admin/UI/Home/Orders/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'dart:io';

// ⭐ CHANGE: barcode + firebase + pdf imports
import 'package:barcode_widget/barcode_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class OrderConfirmed extends StatefulWidget {

  // ⭐ CHANGE: receive orderId from previous screen
  final String orderId;

  const OrderConfirmed({super.key, required this.orderId});

  @override
  State<OrderConfirmed> createState() => _OrderConfirmedState();
}

class _OrderConfirmedState extends State<OrderConfirmed>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  // ⭐ CHANGE: Firebase reference
  final DatabaseReference orderRef =
      FirebaseDatabase.instance.ref().child("orders");

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnim = CurvedAnimation(
        parent: _controller, curve: Curves.elasticOut);

    _fadeAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  // ⭐ CHANGE: function to generate shipping label PDF
  Future<void> generateShippingLabel(Map order) async {

    final font = await rootBundle.load("lib/assets/fonts/Roboto-Regular.ttf");

    final ttf = pw.Font.ttf(font);

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {

          return pw.Container(
            padding: const pw.EdgeInsets.all(20),

            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [

                pw.Text(
                  "Vastra Royale",
                  style: pw.TextStyle(font: ttf, fontSize: 22),
                ),

                pw.SizedBox(height: 20),

                pw.Text("Order ID: ${order["orderId"]}"),
                pw.Text("Customer: ${order["address"]["name"]}"),
                pw.Text("Phone: ${order["address"]["phone"] ?? ""}"),

                pw.SizedBox(height: 20),

                // ⭐ CHANGE: barcode in label
                pw.BarcodeWidget(
                  barcode: pw.Barcode.code128(),
                  data: order["orderId"],
                  width: 250,
                  height: 80,
                ),
              ],
            ),
          );
        },
      ),
    );

    // ⭐ CHANGE: download file to device
    final bytes = await pdf.save();

// ⭐ safer download directory
    Directory directory = Directory("/storage/emulated/0/Download");

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    final file = File(
      "${directory.path}/shipping_label_${order["orderId"]}.pdf",
    );

    await file.writeAsBytes(bytes);

// ⭐ debug print
    print("PDF saved at: ${file.path}");

    Get.snackbar("Success", "Shipping label downloaded");
  }



  @override
  Widget build(BuildContext context) {

    // ⭐ CHANGE: StreamBuilder to load order data dynamically
    return StreamBuilder(
      stream: orderRef.child(widget.orderId).onValue,

      builder: (context, snapshot) {

        if (!snapshot.hasData ||
            snapshot.data!.snapshot.value == null) {

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ⭐ CHANGE: Firebase order data
        Map order = snapshot.data!.snapshot.value as Map;
        Map address = order["address"] ?? {};
        List products = order["products"] ?? [];

        return Scaffold(
          backgroundColor: const Color(0xFFF2F3F5),

          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const BackButton(color: Colors.black),

            title: const Text(
              'Order Confirmed',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),


          body: Column(
            children: [

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),

                  child: FadeTransition(
                    opacity: _fadeAnim,

                    child: Column(
                      children: [

                        const SizedBox(height: 24),

                        // success icon
                        ScaleTransition(
                          scale: _scaleAnim,
                          child: Container(
                            width: 100,
                            height: 100,

                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F4EA),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                  Colors.green.withOpacity(0.15),
                                  blurRadius: 20,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),

                            child: const Icon(
                              Icons.check_rounded,
                              color: Color(0xFF2E7D32),
                              size: 56,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Order Confirmed!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'The order has been successfully packed\nand label generated.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 28),


                        // ============================
                        // ORDER SUMMARY CARD
                        // ============================

                        Container(
                          width: double.infinity,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(16),
                          ),

                          padding: const EdgeInsets.all(20),

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              // ⭐ CHANGE: dynamic order id
                              _buildSummaryRow(
                                  Icons.tag,
                                  'Order ID',
                                  order["orderId"]),

                              const SizedBox(height: 12),

                              // ⭐ CHANGE: dynamic customer
                              _buildSummaryRow(
                                  Icons.person_outline,
                                  'Customer',
                                  address["name"] ?? ""),

                              const SizedBox(height: 12),

                              // ⭐ CHANGE: dynamic items
                              _buildSummaryRow(
                                  Icons.inventory_2_outlined,
                                  'Items',
                                  "${products.length} items"),

                              const SizedBox(height: 12),

                              // ⭐ CHANGE: dynamic weight
                              _buildSummaryRow(
                                  Icons.scale_outlined,
                                  'Weight',
                                  "${order["packingDetails"]?["weight"] ?? "-"} kg"),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),


                        // ============================
                        // BARCODE CARD
                        // ============================

                        Container(
                          width: double.infinity,

                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF0F8),
                            borderRadius:
                            BorderRadius.circular(16),
                          ),

                          padding: const EdgeInsets.all(20),

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              const Text(
                                'Tracking Barcode',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // ⭐ CHANGE: barcode generation
                              BarcodeWidget(
                                barcode: Barcode.code128(),
                                data: order["orderId"],
                                width: 250,
                                height: 80,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),


              // ============================
              // BOTTOM BUTTONS
              // ============================

              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(
                    16, 12, 16, 28),

                child: Column(
                  children: [

                    // ⭐ CHANGE: generate shipping label
                    SizedBox(
                      width: double.infinity,
                      height: 54,

                      child: ElevatedButton.icon(
                        onPressed: () async {

                          DatabaseEvent event =
                          await orderRef
                              .child(widget.orderId)
                              .once();

                          Map order =
                          event.snapshot.value as Map;

                          await generateShippingLabel(order);
                        },

                        icon: const Icon(Icons.print),

                        label:
                        const Text("Print Shipping Label"),

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF1E3A8A),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 54,

                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.offAll(() => const Orders());
                        },

                        icon: const Icon(Icons.list_alt),

                        label: const Text("Back to Orders"),

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFFD4611A),
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



  // reusable row widget
  Widget _buildSummaryRow(
      IconData icon,
      String label,
      String value,
      ) {

    return Row(
      children: [

        Icon(icon, size: 18, color: Colors.grey),

        const SizedBox(width: 10),

        Text(label,
            style: const TextStyle(
                fontSize: 13,
                color: Colors.grey)),

        const Spacer(),

        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
      ],
    );
  }
}

