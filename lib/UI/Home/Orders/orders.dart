import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'order_details/order_details.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {


  int selectedOrderFilter = 0;


  Widget _orderChip(String text, int index) {
    bool selected = selectedOrderFilter == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOrderFilter = index;
        });
      },
      child: Container(
        margin:EdgeInsets.only(right: 10),
        padding:EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                padding:EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  id,
                  style:TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding:EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
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

          SizedBox(height: 12),


          Text(
            name,
            style:TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),

          SizedBox(height: 4),


          Text(
            date,
            style:TextStyle(
                color: Colors.grey,
                fontSize: 12),
          ),

          SizedBox(height: 12),

          Divider(),

          SizedBox(height: 8),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style:TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              TextButton( onPressed: (){

                //Get.to(OrderDetails());
                Get.to(() => OrderDetails(orderId: id,));

              },
                child: Text(

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

  final DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child("orders");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title:Text(
          "ORDERS",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize:Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade300),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: 16),


            StreamBuilder(
              stream: ordersRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {

                if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return SizedBox();
                }

                Map orders = snapshot.data!.snapshot.value as Map;

                int todayOrders = 0;
                int pendingOrders = 0;

                DateTime now = DateTime.now();

                orders.forEach((key, value) {

                  // Count Pending Orders
                  if (value["status"] == "placed") {
                    pendingOrders++;
                  }

                  // Count Today's Orders
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
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 16, right: 8),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("TODAY'S ORDERS",
                                style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 6),
                            Text(
                              todayOrders.toString(),
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text("Realtime",
                                style: TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 16, left: 8),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("PENDING",
                                style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 6),
                            Text(
                              pendingOrders.toString(),
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text("Active",
                                style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 16),


            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:
              EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _orderChip("All Orders", 0),
                  _orderChip("Pending", 1),
                  _orderChip("Shipped", 2),
                  _orderChip("Delivered", 3),
                ],
              ),
            ),

            SizedBox(height: 16),


            StreamBuilder(
              stream: ordersRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {

                if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return Center(child: Text("No Orders"));
                }

                Map orders = snapshot.data!.snapshot.value as Map;

                List orderList = orders.values.toList();

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: orderList.length,
                  itemBuilder: (context, index) {

                    final order = orderList[index];

                    int itemCount = order["products"] != null
                        ? order["products"].length
                        : 0;

                    return _buildOrderCard(
                      id: order["orderId"],
                      name: order["address"]?["name"] ?? "Customer",
                      date: "$itemCount items",
                      price: "₹${order["totalAmount"]}",
                      status: order["status"].toUpperCase(),
                      statusColor: order["status"] == "placed"
                          ? Colors.orange
                          : order["status"] == "packed"
                          ? Colors.blue
                          : order["status"] == "delivered"
                          ? Colors.green
                          : Colors.grey,
                    );
                  },
                );
              },
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}