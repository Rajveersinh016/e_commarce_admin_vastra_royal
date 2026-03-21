import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Controller/admin_dashboard_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final controller = Get.put(AdminDashboardController());

  final Color primaryColor = const Color(0xFF6C63FF);
  final Color bgColor = const Color(0xFFF5F6FA);

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
                    const CircleAvatar(
                      radius: 22,
                      backgroundImage:
                      AssetImage("lib/assets/images/profile.png"),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hello, Admin 👋",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold)),
                        Text("Welcome back",
                            style: GoogleFonts.poppins(
                                color: Colors.grey, fontSize: 12)),
                      ],
                    )
                  ],
                ),
              ),

              /// TITLE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Dashboard",
                    style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// 🔥 REVENUE CARD (FIXED SIZE)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF5A54E8)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Total Revenue",
                        style: GoogleFonts.poppins(
                            color: Colors.white70)),

                    const SizedBox(height: 10),

                    Obx(() => Text(
                      "₹${controller.totalRevenue.value.toStringAsFixed(0)}",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),

                    const SizedBox(height: 6),

                    Text("Updated just now",
                        style: GoogleFonts.poppins(
                            color: Colors.white70)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// 🔥 STATS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _statCard(
                          "Orders", controller.totalOrders),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                          "Customers", controller.totalUsers),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🔥 CHART (FIXED)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(18),
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Sales Overview",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold)),

                    Text("Last 7 Days",
                        style: GoogleFonts.poppins(
                            color: Colors.grey, fontSize: 12)),

                    const SizedBox(height: 20),

                    Expanded(
                      child: Obx(() {

                        List<double> data = List.filled(7, 0);

                        for (int i = 0;
                        i < controller.weeklySales.length &&
                            i < 7;
                        i++) {
                          data[i] = controller.weeklySales[i];
                        }

                        return BarChart(
                          BarChartData(
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false),

                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget:
                                      (value, meta) {
                                    const days = [
                                      "M",
                                      "T",
                                      "W",
                                      "T",
                                      "F",
                                      "S",
                                      "S"
                                    ];
                                    return Padding(
                                      padding:
                                      const EdgeInsets.only(
                                          top: 6),
                                      child: Text(
                                        days[value.toInt()],
                                        style: const TextStyle(
                                            fontSize: 10),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                  sideTitles:
                                  SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles:
                                  SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles:
                                  SideTitles(showTitles: false)),
                            ),

                            barGroups: List.generate(7, (index) {
                              double value = data[index];

                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: value < 50
                                        ? (value == 0 ? 0 : 50)
                                        : value,
                                    width: 14,
                                    borderRadius:
                                    BorderRadius.circular(6),
                                    color: primaryColor,
                                  ),
                                ],
                              );
                            }),
                          ),
                          swapAnimationDuration:
                          const Duration(milliseconds: 300),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 STAT CARD
  Widget _statCard(String title, RxInt value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 6),
          Obx(() => Text(
            value.value.toString(),
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )),
        ],
      ),
    );
  }
}