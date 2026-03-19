import 'dart:convert';
import 'package:http/http.dart' as http;

class ShiprocketService {

  // Replace with your Shiprocket email
  final String email = "bapub1910@gmail.com";

  // Paste regenerated API password here
  final String password = r"kgMzMKXvy1@2TEEP9wIq!s5Bc&By@Ijr";

  Future<String?> getToken() async {

    try {

      final response = await http.post(
        Uri.parse("https://apiv2.shiprocket.in/v1/external/auth/login"),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "email": email,
          "password": password
        }),
      );

      print("status code: ${response.statusCode}");
      print("response body: ${response.body}");


      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        String token = data["token"];

        print("Shiprocket Token: $token");

        return token;

      } else {

        print("Shiprocket Login Failed");
        print(response.body);

        return null;
      }

    } catch (e) {

      print("Error: $e");
      return null;

    }

  }


  Future<Map<String, dynamic>?> assignAWB({
    required String token,
    required int shipmentId,
  }) async {

    try {

      final response = await http.post(
        Uri.parse("https://apiv2.shiprocket.in/v1/external/courier/assign/awb"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "shipment_id": shipmentId
        }),
      );

      print("AWB STATUS: ${response.statusCode}");
      print("AWB RESPONSE: ${response.body}");

      if(response.statusCode == 200){
        return jsonDecode(response.body);
      }

      return null;

    } catch(e){
      print("AWB ERROR: $e");
      return null;
    }
  }


}