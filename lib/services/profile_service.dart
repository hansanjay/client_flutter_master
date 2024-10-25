import 'dart:convert';
import 'package:client_flutter_master/utils/const_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';

class ProfileService {
  final String url = '$baseUrl/customer/profile';
  final String addressUrl = '$baseUrl/customer/address';
  Future<Profile> fetchProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Token");
      String appId =
          '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-app-id-token': appId,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Profile.fromJson(data);
      } else {
        print("Error: "+response.body.toString());
        throw Exception('Failed to fetch profile');
      }
    } catch (e) {
      print('Error in fetchProfile: $e');
      throw Exception('Failed to fetch profile');
    }
  }

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Token");
      String appId = '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

      final response = await http.patch(
        Uri.parse('$url'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-app-id-token': appId,
        },
        body: jsonEncode(profileData),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully');
      } else {
        throw Exception('Failed to update profile: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  Future<void> addAddress(Map<String, dynamic> addressData) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Token");
      String appId = '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

      final response = await http.post(
        Uri.parse('$addressUrl'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-app-id-token': appId,
        },
        body: jsonEncode(addressData),
      );

      if (response.statusCode == 200) {
        print('Address added successfully');
      } else {
        throw Exception('Failed to add address: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error adding address: $e');
    }
  }

  Future<void> updateAddress(Map<String, dynamic> addressData) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Token");
      String appId = '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

      final response = await http.patch(
        Uri.parse('$addressUrl'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-app-id-token': appId,
        },
        body: jsonEncode(addressData),
      );

      if (response.statusCode == 200) {
        print('Address updated successfully');
      } else {
        throw Exception('Failed to update address: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error updating address: $e');
    }
  }
  Future<Map<String, dynamic>> fetchAddressById(int addressId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Token");
      String appId = '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

      final response = await http.get(
          Uri.parse('$addressUrl/$addressId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
            'x-app-id-token': appId,
          }
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to fetch address: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching address: $e');
    }
  }

  Future<void> deleteAddress(int addressId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Token");
      String appId = '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

      final response = await http.delete(
          Uri.parse('$addressUrl/$addressId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
            'x-app-id-token': appId,
          }
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete address: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error deleting address: $e');
    }
  }
}
