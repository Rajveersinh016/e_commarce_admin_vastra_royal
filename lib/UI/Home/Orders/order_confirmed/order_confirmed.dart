import 'package:e_commarce_admin/UI/Home/Orders/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pdf/widgets.dart' as pw;

class OrderConfirmed extends StatefulWidget {
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

  final DatabaseReference orderRef =
  FirebaseDatabase.instance.ref().child("orders");

  final Color primaryColor = const Color(0xFF6C63FF);
  final Color bgColor = const Color(0xFFF5F6FA);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnim =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    _fadeAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// PDF GENERATION (UNCHANGED)
  Future<void> generateShippingLabel(Map order) async {
    final font =
    await rootBundle.load("lib/assets/fonts/Roboto-Regular.ttf");

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
                pw.Text("Vastra Royale",
                    style: pw.TextStyle(font: ttf, fontSize: 22)),
                pw.SizedBox(height: 20),
                pw.Text("Order ID: ${order["orderId"]}"),
                pw.Text("Customer: ${order["address"]["name"]}"),
                pw.SizedBox(height: 20),
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

    final bytes = await pdf.save();

    final file = File(
        "/storage/emulated/0/Download/label_${order["orderId"]}.pdf");

    await file.writeAsBytes(bytes);

    Get.snackbar("Success", "Label downloaded");
  }

  /// CARD
  Widget card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
      stream: orderRef.child(widget.orderId).onValue,
      builder: (context, snapshot) {

        if (!snapshot.hasData ||
            snapshot.data!.snapshot.value == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        Map order = snapshot.data!.snapshot.value as Map;
        Map address = order["address"] ?? {};
        List products = order["products"] ?? [];

        return Scaffold(
          backgroundColor: bgColor,

          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Order Confirmed',
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
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      children: [

                        /// SUCCESS ICON
                        ScaleTransition(
                          scale: _scaleAnim,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.check,
                                color: primaryColor, size: 50),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Order Confirmed!',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 20),

                        /// SUMMARY
                        card(
                          child: Column(
                            children: [
                              _row("Order ID", order["orderId"]),
                              _row("Customer", address["name"] ?? ""),
                              _row("Items",
                                  "${products.length} items"),
                              _row(
                                  "Weight",
                                  "${order["packingDetails"]?["weight"] ?? "-"} kg"),
                            ],
                          ),
                        ),

                        /// BARCODE
                        card(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Text("Tracking Barcode",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              BarcodeWidget(
                                barcode: Barcode.code128(),
                                data: order["orderId"],
                                width: double.infinity,
                                height: 80,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// BUTTONS
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {

                          await orderRef
                              .child(widget.orderId)
                              .update({"status": "shipped"});

                          DatabaseEvent event =
                          await orderRef
                              .child(widget.orderId)
                              .once();

                          Map order =
                          event.snapshot.value as Map;

                          await generateShippingLabel(order);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16),
                        ),
                        child: const Text("Print Shipping Label",style: TextStyle(color: Colors.white),),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.offAll(() => const Orders());
                        },
                        child: const Text("Back to Orders"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}