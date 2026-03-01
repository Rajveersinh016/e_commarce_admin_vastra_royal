import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'Add_New_Product/add_new_product.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {

  int selectedFilter = 0;

  Widget _filterChip(String text, int index) {
    bool selected = selectedFilter == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = index;
        });
      },
      child: Container(
        margin:EdgeInsets.only(right: 10),
        padding:EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300)
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
      margin:EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding:EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [


          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(category,
                        style: TextStyle(
                            color: Colors.grey, fontSize: 12)),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding:EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                                color: statusColor,
                                fontSize: 11),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(stock,
                            style:TextStyle(color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(price,
                        style:TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),


          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon:Icon(Icons.more_vert),
              onPressed: () {},
            ),
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: Colors.grey.shade500,
            ),
          ),
          title: Center(child: Text("INVENTORY",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
        ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [

            SizedBox(height: 20),


            Padding(
              padding:EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding:EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300)
                ),
                child: Row(
                  children: [
                     Icon(Icons.search, color: Colors.grey),
                     SizedBox(width: 8),
                     Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search luxury collections...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            SizedBox(height: 16),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.to(
                          () =>AddProductScreen(),
                           transition: Transition.rightToLeft,
                           duration: const Duration(milliseconds: 500),
                  );

                  // navigate or action here
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xffd4af37), Color(0xffc9a227)],
                    ),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "ADD NEW PRODUCT",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),


            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _filterChip("All Items", 0),
                  _filterChip("Suits", 1),
                  _filterChip("Gowns", 2),
                  _filterChip("Blazers", 3),
                ],
              ),
            ),

            SizedBox(height: 20),


            Padding(
              padding:EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text("Inventory Overview",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("128 PRODUCTS",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            SizedBox(height: 16),


            _buildProductCard(
              image: "lib/assets/images/Man.png",
              title: "Navy Slim Fit Suit",
              category: "MENSWEAR • SUITS",
              status: "ACTIVE",
              stock: "12 in stock",
              price: "450.00",
              statusColor: Colors.blue,
            ),

            _buildProductCard(
              image: "lib/assets/images/Woman.png",
              title: "Velvet Evening Gown",
              category: "WOMENSWEAR • GOWNS",
              status: "LOW STOCK",
              stock: "2 in stock",
              price: "890.00",
              statusColor: Colors.orange,
            ),

            _buildProductCard(
              image: "lib/assets/images/Royal_suit.png",
              title: "Charcoal Blazer",
              category: "MENSWEAR • BLAZERS",
              status: "OUT OF STOCK",
              stock: "0 in stock",
              price: "210.00",
              statusColor: Colors.red,
            ),

            _buildProductCard(
              image: "lib/assets/images/Woman.png",
              title: "Silk Royal Gown",
              category: "BRIDAL • GOWNS",
              status: "ACTIVE",
              stock: "5 in stock",
              price: "1,250.00",
              statusColor: Colors.blue,
            ),

            const SizedBox(height: 30),

          ],
        )
      ),
    );
  }
}
