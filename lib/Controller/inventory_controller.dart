import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class InventoryController extends GetxController {

  var products = <Map<String, dynamic>>[].obs;

  final DatabaseReference productRef =
  FirebaseDatabase.instance.ref("products");

  @override
  void onInit() {
    super.onInit();
    listenProducts();
  }

  void listenProducts() {
    productRef.onValue.listen((event) {

      final data = event.snapshot.value;
      if (data == null) return;

      Map<dynamic, dynamic> productMap = data as Map;

      List<Map<String, dynamic>> temp = [];

      productMap.forEach((key, value) {

        if (value == null) return;

        final product = Map<String, dynamic>.from(value);

        temp.add(product);
      });

      products.value = temp.reversed.toList(); // latest first
    });
  }
}