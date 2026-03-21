import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../Controller/admin_dashboard_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final adminDashboardController = Get.put(AdminDashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("lib/assets/images/profile.png"),
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello, Admin!",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Welcome back to your shop",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Good morning, James",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("Here's what's happening with Vastra Royale today.",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            SizedBox(height: 16),


            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Revenue",
                          style: TextStyle(color: Colors.grey)),
                      Icon(Icons.payments, color: Colors.amber),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Obx(() => Text(
                        "₹${adminDashboardController.totalRevenue.value.toStringAsFixed(0)}",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      )),
                      SizedBox(width: 10),
                      Text("+12%", style: TextStyle(color: Colors.green)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text("vs. last month",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            SizedBox(height: 16),


            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 16, right: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("TOTAL ORDERS",
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 6),
                        Obx(() => Text(
                          adminDashboardController.totalOrders.value.toString(),
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        )),
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
                        borderRadius: BorderRadius.circular(18)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("NEW CUSTOMERS",
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 6),
                        Obx(() => Text(
                          adminDashboardController.totalUsers.value.toString(),
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),


            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(18),
              height: 250,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sales Trends",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text("Last 7 Days",
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 20),

                Expanded(
                  child: Obx(() => BarChart(
                    BarChartData(
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),


                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              List days = ["M", "T", "W", "T", "F", "S", "S"];
                              return Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Text(
                                  days[value.toInt()],
                                  style: TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),


                      barGroups: List.generate(
                        adminDashboardController.weeklySales.length,
                            (index) {
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: adminDashboardController.weeklySales[index],
                                width: 12,
                                borderRadius: BorderRadius.circular(6),


                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange,
                                    Colors.deepOrange,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  )),
                )
                ],
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}