import 'dart:convert';
import 'package:client_flutter_master/utils/const_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
class OrderService {
  final String url = '$baseUrl/order';
  Future<List<Order>> fetchOrdersByDate(DateTime date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("Token");
    String appId =
        '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';
    try {
      final response = await http.get(
        Uri.parse('$url'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-app-id-token': appId,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('items')) {
          final List<dynamic> items = responseData['items'];
          final List<Order> orders =
          items.map((json) => Order.fromJson(json)).toList();

          final List<Order> ordersForDate = orders
              .where((order) =>
          order.orderDate.year == date.year &&
              order.orderDate.month == date.month &&
              order.orderDate.day == date.day)
              .toList();

          ordersForDate.sort((a, b) => a.orderDate.compareTo(b.orderDate));

          return ordersForDate;
        } else {
          print("Error: "+response.body.toString());
          throw Exception(
              'Invalid response data format: Missing "items" field');
        }
      } else {
        print("Error: "+response.body.toString());
        throw Exception(
            'Failed to load orders: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception caught in fetchOrdersForDate: $e');
      throw Exception('Failed to load orders');
    }
  }

  Future<OrderDetail> fetchOrderDetailById(int orderId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("Token");
    String appId =
        '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

    final response = await http.get(
      Uri.parse('$url/order/$orderId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'x-app-id-token': appId,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final orderDetail = OrderDetail.fromJson(data);

      return orderDetail;
    } else {
      throw Exception('Failed to load order details');
    }
  }

  Future<OrderDetail> fetchLineOrderDetailById(int orderId,int lineId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("Token");
    String appId =
        '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

    final response = await http.get(
      Uri.parse('$url/$orderId/line/$lineId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'x-app-id-token': appId,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final orderDetail = OrderDetail.fromJson(data);

      return orderDetail;
    } else {
      throw Exception('Failed to load order details');
    }
  }
  Future<void> createOrder(Map<String, dynamic> orderPayload) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Token");
      String appId =
          '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

      final response = await http.post(
        Uri.parse('$url'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-app-id-token': appId,
        },
        body: jsonEncode(orderPayload),
      );

      if (response.statusCode == 200) {
        print('Order created successfully');
      } else {
        print("Error: "+response.body.toString());
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  Future<void> updateOrder(Map<String, dynamic> orderPayload,int id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Token");
      String appId =
          '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

      final response = await http.patch(
        Uri.parse('$url/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-app-id-token': appId,
        },
        body: jsonEncode(orderPayload),
      );

      if (response.statusCode == 200) {
        print('Order updated successfully');
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
