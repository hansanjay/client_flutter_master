import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';
class CartService {
  static const String _cartKey = 'cartData';

  Future<void> addToCart(Product product, int quantity) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> cartData = await _getCartData(prefs);

      if (cartData.containsKey(product.id.toString())) {
        cartData[product.id.toString()] += quantity;
      } else {
        cartData[product.id.toString()] = quantity;
      }

      await prefs.setString(_cartKey, json.encode(cartData));
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<void> removeFromCart(Product product) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> cartData = await _getCartData(prefs);

      cartData.remove(product.id.toString());

      await prefs.setString(_cartKey, json.encode(cartData));
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }

  Future<Map<String, dynamic>> getCartItems() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await _getCartData(prefs);
    } catch (e) {
      print('Error getting cart items: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> _getCartData(SharedPreferences prefs) async {
    String? cartJson = prefs.getString(_cartKey);
    if (cartJson != null && cartJson.isNotEmpty) {
      return json.decode(cartJson);
    } else {
      return {};
    }
  }
}
