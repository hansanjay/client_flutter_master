import 'dart:convert';
import 'package:client_flutter_master/utils/const_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PastOrderService {
  final String url = '$baseUrl/delivery';

  Future<List<Order>> fetchPastOrders() async {
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
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic> ordersJson = responseBody['items'];
        return ordersJson.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load past orders');
      }
    } catch (e) {
      print('Exception caught in fetchOrdersForDate: $e');
      throw Exception('Failed to load orders');
    }
  }

  Future<Order> fetchOrderById(int id) async {
    try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("Token");
    String appId =
        '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

    final response = await http.get(Uri.parse('$url/$id'),headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-app-id-token': appId,
    },);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      return Order.fromJson(responseBody);
    } else {
      throw Exception('Failed to load order details');
    }
  }
    catch (e) {
      print('Exception caught in fetchOrdersForDate: $e');
      throw Exception('Failed to load orders');
    }}
}

class Order {
  final int id;
  final String orderDate;
  final String address;
  final double totalPrice;
  final String status;
  final List<OrderLine> lines;

  Order({
    required this.id,
    required this.orderDate,
    required this.address,
    required this.totalPrice,
    required this.status,
    required this.lines,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var list = json['lines'] as List;
    List<OrderLine> linesList = list.map((i) => OrderLine.fromJson(i)).toList();

    String address =
        "Default Address";

    return Order(
      id: json['id'],
      orderDate: json['orderDate'],
      address: address,
      totalPrice: linesList.fold(
          0, (sum, item) => sum + item.product.price * item.quantity),
      status: json['status'],
      lines: linesList,
    );
  }
}

class OrderLine {
  final Product product;
  final int quantity;

  OrderLine({
    required this.product,
    required this.quantity,
  });

  factory OrderLine.fromJson(Map<String, dynamic> json) {
    return OrderLine(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}

class Product {
  final int id;
  final double rating;
  final String title;
  final String description;
  final String features;
  final int unit;
  final String unitType;
  final double mrp;
  final String imageUrl;
  final String productClass;
  final String packagingType;
  final String category;
  final String brand;
  final double discount;
  final double price;
  final int brandId;
  final String shelfLife;
  final String unitDisplay;
  final String weightDisplay;
  final int weightG;
  final String type;
  final String returnPolicy;
  final String productGroup;
  final String? subCategory;
  final int lineId;
  final int distributorId;
  final int catalogId;

  Product({
    required this.id,
    required this.rating,
    required this.title,
    required this.description,
    required this.features,
    required this.unit,
    required this.unitType,
    required this.mrp,
    required this.imageUrl,
    required this.productClass,
    required this.packagingType,
    required this.category,
    required this.brand,
    required this.discount,
    required this.price,
    required this.brandId,
    required this.shelfLife,
    required this.unitDisplay,
    required this.weightDisplay,
    required this.weightG,
    required this.type,
    required this.returnPolicy,
    required this.productGroup,
    this.subCategory,
    required this.lineId,
    required this.distributorId,
    required this.catalogId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      rating: json['rating'],
      title: json['title'],
      description: json['description'],
      features: json['features'],
      unit: json['unit'],
      unitType: json['unit_type'],
      mrp: json['mrp'],
      imageUrl: json['image_url'],
      productClass: json['product_class'],
      packagingType: json['packaging_type'],
      category: json['category'],
      brand: json['brand'],
      discount: json['discount'],
      price: json['price'],
      brandId: json['brandId'],
      shelfLife: json['shelfLife'],
      unitDisplay: json['unitDisplay'],
      weightDisplay: json['weightDisplay'],
      weightG: json['weight_(g)'],
      type: json['type'],
      returnPolicy: json['returnPolicy'],
      productGroup: json['productGroup'],
      subCategory: json['subCategory'],
      lineId: json['lineId'],
      distributorId: json['distributorId'],
      catalogId: json['catalogId'],
    );
  }
}
