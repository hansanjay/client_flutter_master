import 'dart:convert';
import 'package:client_flutter_master/utils/const_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription_model.dart';

class SubscriptionService {
   final String url = '$baseUrl/subscription';

  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("Token");
  }

  Future<String> _getAppId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';
  }

  Future<List<Subscription>> fetchSubscriptions(
      {int offset = 1, int limit = 5}) async {
    // List<Subscription>? cachedSubscriptions = await _getCachedSubscriptions();
    // if (cachedSubscriptions != null) {
    //   return cachedSubscriptions;
    // }
    return await _fetchSubscriptionsFromApi(offset, limit);
  }

  Future<List<Subscription>> _fetchSubscriptionsFromApi(
      int offset, int limit) async {
    String? token = await _getToken();
    String appId = await _getAppId();

    final response = await http.get(
      Uri.parse('$url?offset=$offset&limit=$limit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'x-app-id-token': appId,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Subscription> subscriptions = (data['items'] as List)
          .map((item) => Subscription.fromJson(item))
          .toList();
      // await _cacheSubscriptions(subscriptions);
      return subscriptions;
    } else {
      throw Exception('Failed to load subscriptions: ${response.body}');
    }
  }

  Future<Subscription> getSubscriptionById(int id) async {
    String? token = await _getToken();
    String appId = await _getAppId();

    final response = await http.get(
      Uri.parse('$url/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'x-app-id-token': appId,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Subscription.fromJson(data);
    } else {
      throw Exception('Failed to load subscription: ${response.body}');
    }
  }

  Future<void> pauseSubscription(
      int id, String selectedFromDate, String selectedToDate) async {
    String? token = await _getToken();
    String appId = await _getAppId();

    final Map<String, String> body = {
      "pause": selectedFromDate,
      "resume": selectedToDate
    };

    final response = await http.patch(
      Uri.parse('$url/$id/pause'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'x-app-id-token': appId
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to pause subscription: ${response.body}');
    }
  }

  Future<void> resumeSubscription(int subscriptionId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Token");
      String appId = '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

      final response = await http.get(
        Uri.parse('$url/$subscriptionId/resume'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-app-id-token': appId,
        },
      );

      if (response.statusCode == 200) {
        print('Subscription resumed successfully');
        // await _updateLocalCache();
      } else {
        throw Exception('Failed to resume subscription');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> createSubscription(
      {required int distributorId,
      required int productId,
      required int quantity,
      required int type,
      required int status,
      required String start,
      required var weekly,
      required var monthly}) async {
    try {
      String? token = await _getToken();
      String appId = await _getAppId();

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-app-id-token': appId,
        },
        body: jsonEncode({
          "distributor_id": distributorId,
          "product_id": productId,
          "quantity": quantity,
          "type": type,
          "status": status,
          "start": start,
          "day_of_week": weekly,
          "day_of_month": monthly
        }),
      );

      if (response.statusCode == 200) {
        print('Subscription created successfully');
        // await _updateLocalCache();
      } else {
        throw Exception('Failed to create subscription: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to create subscription: $e');
    }
  }

  Future<void> updateSubscription(int id, Map<String, dynamic> updates) async {
    String? token = await _getToken();
    String appId = await _getAppId();

    final response = await http.patch(
      Uri.parse('$url/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'x-app-id-token': appId,
      },
      body: jsonEncode(updates),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update subscription: ${response.body}');
    }

    // await _updateLocalCache();
  }

  Future<void> deleteSubscription(int id) async {
    String? token = await _getToken();
    String appId = await _getAppId();

    final response = await http.delete(
      Uri.parse('$url/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'x-app-id-token': appId
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete subscription: ${response.body}');
    }

    // await _updateLocalCache();
  }

  // Future<List<Subscription>?> _getCachedSubscriptions() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? cachedData = prefs.getString('cachedSubscriptions');
  //   if (cachedData != null) {
  //     List<dynamic> jsonData = jsonDecode(cachedData);
  //     return jsonData.map((item) => Subscription.fromJson(item)).toList();
  //   }
  //   return null;
  // }

  // Future<void> _cacheSubscriptions(List<Subscription> subscriptions) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('cachedSubscriptions',
  //       jsonEncode(subscriptions.map((item) => item.toJson()).toList()));
  // }
  //
  // Future<void> _updateLocalCache() async {
  //   List<Subscription> subscriptions = await _fetchSubscriptionsFromApi(1, 5);
  //   await _cacheSubscriptions(subscriptions);
  // }
}
