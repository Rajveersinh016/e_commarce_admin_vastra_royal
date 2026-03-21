import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'order_details/order_details.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  int selectedOrderFilter = 1;

  final Color primaryColor = const Color(0xFF6C63FF);
  final Color bgColor = const Color(0xFFF5F6FA);

  final DatabaseReference ordersRef =
  FirebaseDatabase.instance.ref().child("orders");

  String getSelectedStatus() {
    switch (selectedOrderFilter) {
      case 1:
        return "placed";
      case 2:
        return "packed";
      case 3:
        return "shipped";
      case 4:
        return "delivered";
      case 5:
        return "cancelled";
      default:
        return "";
    }
  }

  String getDisplayStatus(String status) {
    switch (status) {
      case "placed":
        return "New Order";
      case "packed":
        return "Ready to Ship";
      case "shipped":
        return "Shipped";
      case "out_for_delivery":
        return "Out for Delivery";
      case "delivered":
        return "Completed";
      case "cancelled":
        return "Cancelled";
      default:
        return status;
    }
  }

  /// 🔥 FILTER CHIP
  Widget _chip(String text, int index) {
    bool selected = selectedOrderFilter == index;

    return GestureDetector(
      onTap: () {
        setState(() => selectedOrderFilter = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
              )
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: selected ? Colors.white : Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  /// 🔥 ORDER CARD
  Widget _orderCard({
    required String id,
    required String name,
    required String date,
    required String price,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [

          /// TOP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: primaryColor)),

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status,
                    style: GoogleFonts.poppins(
                        color: statusColor, fontSize: 11)),
              )
            ],
          ),

          const SizedBox(height: 10),

          /// CUSTOMER
          Align(
            alignment: Alignment.centerLeft,
            child: Text(name,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600)),
          ),

          const SizedBox(height: 4),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(date,
                style: GoogleFonts.poppins(
                    color: Colors.grey, fontSize: 12)),
          ),

          const SizedBox(height: 10),
          const Divider(),

          /// BOTTOM
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(price,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),

              GestureDetector(
                onTap: () {
                  Get.to(() =>
                      OrderDetails(orderId: id, status: status));
                },
                child: Text("View",
                    style: GoogleFonts.poppins(
                        color: primaryColor,
                        fontWeight: FontWeight.w600)),
              )
            ],
          )
        ],
      ),
    );
  }

  /// 🔥 STAT CARD
  Widget _statCard(String title, int value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: const TextStyle(
                  color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 6),

            Text(
              value.toString(),
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Container(
              height: 4,
              width: 30,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// 🔥 HEADER
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text("Orders",
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              /// 🔥 STATS
              StreamBuilder(
                stream: ordersRef.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {

                  if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                    return const SizedBox();
                  }

                  Map orders = snapshot.data!.snapshot.value as Map;

                  int pending = 0;
                  int completed = 0;
                  int today = 0;

                  DateTime now = DateTime.now();

                  orders.forEach((key, value) {

                    /// ✅ COMPLETED
                    if (value["status"] == "delivered") {
                      completed++;
                    } else {
                      pending++;
                    }

                    /// ✅ TODAY FILTER
                    if (value["orderTime"] != null) {
                      DateTime orderDate = DateTime.fromMillisecondsSinceEpoch(
                          value["orderTime"]);

                      if (orderDate.year == now.year &&
                          orderDate.month == now.month &&
                          orderDate.day == now.day) {
                        today++;
                      }
                    }
                  });

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _statCard("Today", today, Colors.blue),
                        _statCard("Pending", pending, Colors.orange),
                        _statCard("Completed", completed, Colors.green),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              /// 🔥 FILTERS
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _chip("All", 0),
                    _chip("New", 1),
                    _chip("Packed", 2),
                    _chip("Shipped", 3),
                    _chip("Done", 4),
                    _chip("Cancel", 5),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// 🔥 ORDER LIST
              StreamBuilder(
                stream: ordersRef.onValue,
                builder: (context,
                    AsyncSnapshot<DatabaseEvent> snapshot) {

                  if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return const Center(child: Text("No Orders"));
                  }

                  Map orders =
                  snapshot.data!.snapshot.value as Map;

                  List orderList = [];

                  orders.forEach((key, value) {
                    if (selectedOrderFilter == 0 ||
                        value["status"] ==
                            getSelectedStatus()) {
                      orderList.add(value);
                    }
                  });

                  return ListView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemCount: orderList.length,
                    itemBuilder: (context, index) {
                      final order = orderList[index];

                      int itemCount =
                          order["products"]?.length ?? 0;

                      return _orderCard(
                        id: order["orderId"],
                        name:
                        order["address"]?["name"] ?? "Customer",
                        date: "$itemCount items",
                        price: "₹${order["totalAmount"]}",
                        status: getDisplayStatus(
                            order["status"]),
                        statusColor: primaryColor,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}