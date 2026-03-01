import 'package:flutter/material.dart';

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
              TextButton( onPressed: (){},
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


            Row(
              children: [
                Expanded(
                  child: Container(
                    margin:
                    EdgeInsets.only(left: 16, right: 8),
                    padding:EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child:Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text("TODAY'S ORDERS",
                            style:
                            TextStyle(color: Colors.grey)),
                        SizedBox(height: 6),
                        Text("128",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight:
                                FontWeight.bold)),
                        Text("+12%",
                            style:
                            TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin:
                    EdgeInsets.only(right: 16, left: 8),
                    padding:EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child:Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text("PENDING",
                            style:
                            TextStyle(color: Colors.grey)),
                        SizedBox(height: 6),
                        Text("42",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight:
                                FontWeight.bold)),
                        Text("Active",
                            style:
                            TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),
                ),
              ],
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


            _buildOrderCard(
              id: "#VR-8829",
              name: "Arjun Mehta",
              date: "Oct 24, 2023 • 2 items",
              price: "₹4,500.00",
              status: "SHIPPED",
              statusColor: Colors.blue,
            ),

            _buildOrderCard(
              id: "#VR-8828",
              name: "Priya Singh",
              date: "Oct 23, 2023 • 1 item",
              price: "₹2,100.00",
              status: "PENDING",
              statusColor: Colors.orange,
            ),

            _buildOrderCard(
              id: "#VR-8827",
              name: "Vikram Malhotra",
              date: "Oct 22, 2023 • 4 items",
              price: "₹12,850.00",
              status: "DELIVERED",
              statusColor: Colors.green,
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}