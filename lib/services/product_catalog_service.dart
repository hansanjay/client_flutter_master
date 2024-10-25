import 'package:client_flutter_master/utils/const_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProductService {

  static Future<Product?> getProductById(int id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Token");
      String? appId = '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';
      final String url = '$baseUrl/product';
      final response = await http.get(
        Uri.parse('$url/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-app-id-token': appId,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Failed to fetch product');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
