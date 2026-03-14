import 'package:e_commarce_admin/UI/Home/Orders/cancel_order/cancel_order.dart';
import 'package:e_commarce_admin/UI/Home/Orders/mark_as_placed/mark_as_placed.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          "Order #${widget.orderId}", //  dynamic order id
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      //  STREAMBUILDER WILL LOAD ORDER DATA FROM FIREBASE
      body: StreamBuilder(


        stream: ordersRef.child(widget.orderId).onValue,

        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {


          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Divider(),


                      Padding(
                        padding: const EdgeInsets.all(16),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,

                              children: [

                                const Text(
                                  "ORDER STATUS",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),

                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  child: Text(
                                    order["status"]
                                        .toUpperCase(), //  dynamic status
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(height: 10),


                            Text(
                              "Placed on ${orderDate.day}-${orderDate.month}-${orderDate.year}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),

                          ],
                        ),
                      ),

                      const Divider(height: 6),


                      Padding(
                        padding: const EdgeInsets.all(16),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text(
                              "Customer Details",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [

                                const CircleAvatar(
                                  radius: 30,
                                  child: Icon(Icons.person),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [


                                      Text(
                                        address["name"] ?? "Customer",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),

                                      const SizedBox(height: 4),


                                      Text(
                                        "${address["line1"]}, ${address["line2"]}, ${address["city"]}",
                                        style: const TextStyle(
                                            color: Colors.grey),
                                      ),

                                      const SizedBox(height: 4),


                                      Text(
                                        "+91 ${address["phone"]}",
                                        style: const TextStyle(
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),

                      const Divider(height: 6),


                      Padding(
                        padding: const EdgeInsets.all(16),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Items (${products.length})",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 16),

                            Column(
                              children: products.map<Widget>((product) {

                                return ListTile(

                                  leading: Image.network(
                                    product["image"],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),

                                  title: Text(product["name"]),

                                  subtitle: Text(
                                      "Size: ${product["size"]} | Color: ${product["color"]}"),

                                  trailing: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text("x${product["quantity"]}"),
                                      Text("₹${product["price"]}")
                                    ],
                                  ),
                                );

                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 6),


                      Padding(
                        padding: const EdgeInsets.all(16),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text(
                              "Payment Summary",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,

                              children: [

                                const Text("Total Amount"),

                                Text(
                                  "₹${order["totalAmount"]}", //  dynamic total
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    // ⭐ SHOW ONLY IF ORDER IS NEW
                    if(order["status"] == "placed")
                      SizedBox(
                        height: 50,
                        width: 350,
                        child: ElevatedButton.icon(

                          onPressed: () {

                            Get.to(
                              MarkAsPackedScreen(orderId: widget.orderId),
                            );

                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          icon: const Icon(Icons.inventory_2,color: Colors.white),
                          label: const Text(
                            "Mark as Packed",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                    const SizedBox(height: 10),

                    // ⭐ CANCEL ONLY WHEN ORDER IS NEW
                    if(order["status"] == "placed")
                      SizedBox(
                        height: 50,
                        width: 350,
                        child: ElevatedButton.icon(

                          onPressed: () {

                            Get.to(CancelOrder(orderId: widget.orderId));

                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          icon: const Icon(Icons.cancel,color: Colors.white),
                          label: const Text(
                            "Cancel Order",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                    // ⭐ DOWNLOAD LABEL ONLY WHEN PACKED
                    if(order["status"] == "packed")
                      SizedBox(
                        height: 50,
                        width: 350,
                        child: ElevatedButton.icon(

                          onPressed: () {

                            // go to label screen
                            Get.to(
                              OrderConfirmed(orderId: widget.orderId),
                            );

                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          icon: const Icon(Icons.local_shipping,color: Colors.white),
                          label: const Text(
                            "Download Shipping Label",
                            style: TextStyle(color: Colors.white),
                          ),
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