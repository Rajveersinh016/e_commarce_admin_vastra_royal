import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order_details/order_details.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  // ⭐ CHANGE: default filter = pending (placed)
  int selectedOrderFilter = 1;

  final DatabaseReference ordersRef =
  FirebaseDatabase.instance.ref().child("orders");


  // Convert filter index to database status
  String getSelectedStatus() {

    switch(selectedOrderFilter){

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


  // Friendly status text
  String getDisplayStatus(String status){

    switch(status){

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


  Widget _orderChip(String text, int index) {

    bool selected = selectedOrderFilter == index;

    return GestureDetector(

      onTap: () {

        setState(() {
          selectedOrderFilter = index;
        });

      },

      child: Container(

        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  Widget _buildOrderCard({
    required String id,
    required String name,
    required String date,
    required String price,
    required String status,
    required Color statusColor,
  }) {

    return Container(

      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Text(
                  id,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.15),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            name,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),

          const SizedBox(height: 4),

          Text(
            date,
            style: const TextStyle(
                color: Colors.grey,
                fontSize: 12),
          ),

          const SizedBox(height: 12),

          const Divider(),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Text(
                price,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),

              TextButton(
                onPressed: () {

                  //Get.to(() => OrderDetails(orderId: id));
                  Get.to(() => OrderDetails(
                    orderId: id,
                    status: status,
                  ));

                },

                child: const Text(
                  "View Details >",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(

        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "ORDERS",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade300),
        ),
      ),

      body: SingleChildScrollView(

        child: Column(

          children: [

            const SizedBox(height: 16),


            // ==========================
            // ORDER STATS
            // ==========================

            StreamBuilder(

              stream: ordersRef.onValue,

              builder: (context,
                  AsyncSnapshot<DatabaseEvent> snapshot) {

                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return const SizedBox();
                }

                Map orders =
                snapshot.data!.snapshot.value as Map;

                int todayOrders = 0;
                int pendingOrders = 0;
                int completedOrders = 0;

                DateTime now = DateTime.now();

                orders.forEach((key, value) {

                  String status = value["status"];

                  // pending
                  if (status == "placed" ||
                      status == "packed" ||
                      status == "shipped" ||
                      status == "out_for_delivery") {

                    pendingOrders++;

                  }

                  // completed
                  if (status == "delivered") {
                    completedOrders++;
                  }

                  int time = value["orderTime"];

                  DateTime orderDate =
                  DateTime.fromMillisecondsSinceEpoch(time);

                  if (orderDate.year == now.year &&
                      orderDate.month == now.month &&
                      orderDate.day == now.day) {

                    todayOrders++;

                  }

                });

                return Row(

                  children: [

                    _buildStatCard("TODAY", todayOrders, "Realtime",Colors.blue),

                    _buildStatCard("PENDING", pendingOrders, "Active",Colors.orange),

                    _buildStatCard("COMPLETED", completedOrders, "Delivered",Colors.green),

                  ],
                );
              },
            ),


            const SizedBox(height: 16),


            // ==========================
            // FILTER CHIPS
            // ==========================

            SingleChildScrollView(

              scrollDirection: Axis.horizontal,

              padding:
              const EdgeInsets.symmetric(horizontal: 16),

              child: Row(

                children: [

                  _orderChip("All Orders", 0),
                  _orderChip("New Orders", 1),
                  _orderChip("Ready to Ship", 2),
                  _orderChip("Shipped", 3),
                  _orderChip("Completed", 4),
                  _orderChip("Cancelled", 5),

                ],
              ),
            ),

            const SizedBox(height: 16),


            // ==========================
            // ORDER LIST
            // ==========================

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

                  if (selectedOrderFilter == 0) {

                    orderList.add(value);

                  } else if (value["status"] ==
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
                    order["products"] != null
                        ? order["products"].length
                        : 0;

                    return _buildOrderCard(

                      id: order["orderId"],

                      name: order["address"]?["name"] ??
                          "Customer",

                      date: "$itemCount items",

                      price: "₹${order["totalAmount"]}",

                      status:
                      getDisplayStatus(order["status"]),

                      statusColor:

                      order["status"] == "placed"
                          ? Colors.orange
                          : order["status"] == "packed"
                          ? Colors.blue
                          : order["status"] == "shipped"
                          ? Colors.purple
                          : order["status"] ==
                          "out_for_delivery"
                          ? Colors.teal
                          : order["status"] == "delivered"
                          ? Colors.green
                          : order["status"] == "cancelled"
                          ? Colors.red
                          : Colors.grey,
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }


  Widget _buildStatCard(String title, int value, String sub,Color subtitlecolor){

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(title,
                style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 6),

            Text(
              value.toString(),
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),

            Text(sub,
                style: TextStyle(color:subtitlecolor)),

          ],
        ),
      ),
    );
  }

}