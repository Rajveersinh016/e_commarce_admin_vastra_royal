import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Controller/inventory_controller.dart';
import 'Add_New_Product/add_new_product.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  int selectedFilter = 0;

  final inventoryController = Get.put(InventoryController());

  /// 🔹 FILTER CHIP
  Widget _filterChip(String text, int index) {
    bool selected = selectedFilter == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF6C63FF)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
              )
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// 🔥 PRODUCT CARD (UPGRADED)
  Widget _buildProductCard({
    required String image,
    required String title,
    required String category,
    required String status,
    required String stock,
    required String price,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [

          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image(
              image: image.startsWith("http")
                  ? NetworkImage(image)
                  : AssetImage(image) as ImageProvider,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          /// DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(category,
                    style: GoogleFonts.poppins(
                        color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 6),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.poppins(
                            color: statusColor, fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(stock,
                        style: GoogleFonts.poppins(
                            color: Colors.grey, fontSize: 12)),
                  ],
                ),

                const SizedBox(height: 6),

                Text(price,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF6C63FF),
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),

          /// MENU
          Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// 🔥 HEADER
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text("Inventory",
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              /// 🔍 SEARCH BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search products...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// 🔥 ADD PRODUCT BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Get.to(() => AddProductScreen(),
                        transition: Transition.rightToLeft);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text("Add New Product",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// FILTERS
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _filterChip("All", 0),
                    _filterChip("Suits", 1),
                    _filterChip("Gowns", 2),
                    _filterChip("Blazers", 3),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// TITLE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("All Products",
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                    Obx(() => Text(
                      "${inventoryController.products.length}",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    )),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// PRODUCT LIST
              Obx(() => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: inventoryController.products.length,
                itemBuilder: (context, index) {
                  final product =
                  inventoryController.products[index];

                  String title = product['name'] ?? "No Name";
                  String category =
                      product['category'] ?? "Category";

                  int stock = product['totalStock'] ?? 0;
                  double price =
                  (product['price'] ?? 0).toDouble();

                  String status;
                  Color statusColor;

                  if (stock == 0) {
                    status = "OUT";
                    statusColor = Colors.red;
                  } else if (stock <= 5) {
                    status = "LOW";
                    statusColor = Colors.orange;
                  } else {
                    status = "ACTIVE";
                    statusColor = const Color(0xFF6C63FF);
                  }

                  String image = "";
                  if (product['images'] != null) {
                    var imagesMap = product['images'] as Map;
                    if (imagesMap.isNotEmpty) {
                      var firstKey = imagesMap.keys.first;
                      var imageList = imagesMap[firstKey];
                      if (imageList != null &&
                          imageList.isNotEmpty) {
                        image = imageList[0];
                      }
                    }
                  }

                  return _buildProductCard(
                    image: image.isEmpty
                        ? "lib/assets/images/Man.png"
                        : image,
                    title: title,
                    category: category,
                    status: status,
                    stock: "$stock",
                    price: "₹${price.toStringAsFixed(0)}",
                    statusColor: statusColor,
                  );
                },
              )),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}