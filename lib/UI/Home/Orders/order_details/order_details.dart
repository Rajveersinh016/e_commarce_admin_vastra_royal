import 'package:e_commarce_admin/UI/Home/Orders/cancel_order/cancel_order.dart';
import 'package:e_commarce_admin/UI/Home/Orders/mark_as_placed/mark_as_placed.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Services/shiprocket_service.dart';
import '../order_confirmed/order_confirmed.dart';

class OrderDetails extends StatefulWidget {
  final String orderId;
  final String status;

  const OrderDetails({
    super.key,
    required this.orderId,
    required this.status,
  });

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  final DatabaseReference ordersRef =
  FirebaseDatabase.instance.ref().child("orders");

  final Color primaryColor = const Color(0xFF6C63FF);
  final Color bgColor = const Color(0xFFF5F6FA);

  ShiprocketService shiprocket = ShiprocketService();

  /// 🔥 COMMON CARD
  Widget cardWrapper({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
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
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Order #${widget.orderId}",
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: StreamBuilder(
        stream: ordersRef.child(widget.orderId).onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {

          if (!snapshot.hasData ||
              snapshot.data!.snapshot.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          Map order = snapshot.data!.snapshot.value as Map;
          List products = order["products"] ?? [];
          Map address = order["address"] ?? {};

          DateTime orderDate =
          DateTime.fromMillisecondsSinceEpoch(order["orderTime"]);

          return Column(
            children: [

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      /// 🔥 ORDER STATUS
                      cardWrapper(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Order Status",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Placed on ${orderDate.day}-${orderDate.month}-${orderDate.year}",
                                  style:
                                  const TextStyle(color: Colors.grey),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    order["status"].toUpperCase(),
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),

                      /// 🔥 CUSTOMER DETAILS
                      cardWrapper(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor:
                              primaryColor.withOpacity(0.1),
                              child: Icon(Icons.person,
                                  color: primaryColor),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(address["name"] ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${address["line1"]}, ${address["city"]}",
                                    style:
                                    const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "+91 ${address["phone"]}",
                                    style:
                                    const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      /// 🔥 ITEMS
                      cardWrapper(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Items (${products.length})",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),

                            Column(
                              children: products.map<Widget>((p) {
                                return Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        child: Image.network(
                                          p["image"],
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(p["name"]),
                                            Text(
                                              "Size: ${p["size"]} | ${p["color"]}",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text("x${p["quantity"]}"),
                                          Text("₹${p["price"]}")
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),

                      /// 🔥 PAYMENT
                      cardWrapper(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Amount"),
                            Text(
                              "₹${order["totalAmount"]}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 🔥 ACTION BUTTONS (UNCHANGED LOGIC)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    if (order["status"] == "placed")
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            bool success =
                                await shiprocket.getToken() != null;
                            if (success) {
                              Get.to(() => MarkAsPackedScreen(
                                  orderId: widget.orderId));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16),
                          ),
                          child: const Text("Mark as Packed",style: TextStyle(color: Colors.white),),
                        ),
                      ),

                    const SizedBox(height: 10),

                    if (order["status"] == "placed")
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Get.to(CancelOrder(
                                orderId: widget.orderId));
                          },
                          child: const Text("Cancel Order"),
                        ),
                      ),

                    if (order["status"] == "packed")
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(OrderConfirmed(
                                orderId: widget.orderId));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16),
                          ),
                          child:
                          const Text("Download Shipping Label",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}