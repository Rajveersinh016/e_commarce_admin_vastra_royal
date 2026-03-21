import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminDashboardController extends GetxController {

  var totalOrders = 0.obs;
  var totalRevenue = 0.0.obs;
  var totalUsers = 0.obs;

  var weeklySales = <double>[].obs;

  final ordersRef = FirebaseDatabase.instance.ref("orders");
  final usersRef = FirebaseDatabase.instance.ref("users");

  @override
  void onInit() {
    super.onInit();
    listenOrders();
    listenUsers();
  }


  void listenOrders() {
    ordersRef.onValue.listen((event) {

      final data = event.snapshot.value;
      if (data == null) return;

      Map ordersMap = data as Map;

      int ordersCount = 0;
      double revenue = 0;

      List<double> last7Days = List.filled(7, 0);

      int today = DateTime.now().millisecondsSinceEpoch;

      ordersMap.forEach((key, value) {

        if (value == null) return;

        final order = Map<String, dynamic>.from(value);

        ordersCount++;
        double amount = (order['totalAmount'] ?? 0).toDouble();
        revenue += amount;


        int orderTime = order['orderTime'] ?? 0;

        int diffDays =
        ((today - orderTime) / (1000 * 60 * 60 * 24)).floor();

        if (diffDays >= 0 && diffDays < 7) {
          last7Days[6 - diffDays] += amount;
        }
      });

      totalOrders.value = ordersCount;
      totalRevenue.value = revenue;
      weeklySales.value = last7Days;
    });
  }


  void listenUsers() {
    usersRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data == null) return;

      Map usersMap = data as Map;
      totalUsers.value = usersMap.length;
    });
  }
}