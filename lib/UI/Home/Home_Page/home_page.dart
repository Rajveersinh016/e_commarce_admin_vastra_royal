import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        //toolbarHeight: 80,
        automaticallyImplyLeading: false,

        title: Row(
          children: [


            Container(
              padding:EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child:CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("lib/assets/images/profile.png"),
              ),
            ),

            SizedBox(width: 12),


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, Admin!",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Welcome back to your shop",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),


      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [

            SizedBox(height: 20),


            Padding(
              padding:EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text(
                    "Good morning, James",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Here's what's happening with Vastra Royale today.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),


            Container(
              margin:EdgeInsets.symmetric(horizontal: 16),
              padding:  EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Text("Total Revenue",
                          style: TextStyle(color: Colors.grey)),
                      Icon(Icons.payments, color: Colors.amber),
                    ],
                  ),
                   SizedBox(height: 10),
                  Row(
                    children: [
                      Text("124,000",
                          style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Text("+12%",
                          style: TextStyle(color: Colors.green)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text("vs. last month",
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 10),
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 16),


            Row(
              children: [

                Expanded(
                  child: Container(
                    margin:EdgeInsets.only(left: 16, right: 8),
                    padding:EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text("TOTAL ORDERS",
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 6),
                        Text("1,240",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text("+5%", style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    margin:EdgeInsets.only(right: 16, left: 8),
                    padding:EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text("NEW CUSTOMERS",
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 6),
                        Text("450",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text("+8%", style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                ),

              ],
            ),

            SizedBox(height: 20),


            Container(
              margin:EdgeInsets.symmetric(horizontal: 16),
              padding:EdgeInsets.all(18),
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Sales Trends",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      Text("DETAILS",
                          style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text("Last 7 Days",
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: Image.asset("lib/assets/images/chart.png",fit: BoxFit.fill,),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 30),


          ],
        ) ,
      ),
    );
  }
}
