import 'dart:convert';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:client_flutter_master/utils/color_utils.dart';
import 'package:client_flutter_master/utils/const_utils.dart';
import 'package:client_flutter_master/utils/variable_utils.dart';
import 'package:client_flutter_master/view/dashboard/dashboard.dart';
import 'package:client_flutter_master/view/general_screens/no_data_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product_model.dart';
import '../../services/cart_service.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:http/http.dart' as http;
class CartScreen extends StatefulWidget {
  final List<Product> products;
  const CartScreen({Key? key, required this.products}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Product> cartProducts = [];
  double totalPrice = 0;
  Map<String, dynamic> cartData={};
  final CartService _cartService = CartService();
  late DateTime selectedDate;
  final today = DateUtils.dateOnly(DateTime.now());
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    loadCartData();
    selectedDate=DateTime(today.year, today.month, today.day+1);
  }

  Future<void> loadCartData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      cartData=
      json.decode(prefs.getString('cartData') ?? '{}');
      setState(() {
        cartProducts = getProductsFromCart(cartData);
        totalPrice = calculateTotalPrice(cartProducts);
      });
      print(cartData.toString());
    } catch (e) {
      print('Error loading cart data: $e');
    }
  }

  List<Product> getProductsFromCart(Map<String, dynamic> cartData) {
    List<Product> products = [];
    cartData.forEach((productId, quantity) {
      Product? product = widget.products.firstWhere(
            (product) => product.id == int.parse(productId)
      );
      if (product != null) {
        products.add(product);
      }
    });
    return products;
  }

  double calculateTotalPrice(List<Product> products) {
    double total = 0;
    for (var product in products) {
      total += product.price*getQuantityInCart(product);
    }
    return total;
  }
  Future<void> removeFromCart(Product product1) async {
    try {
      await _cartService.removeFromCart(product1);
      loadCartData();
    } catch (e) {
      print('Error removing from cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove product from cart'),
        ),
      );
    }
  }
  int getQuantityInCart(Product product) {
    return cartData[product.id.toString()] ?? 0;
  }
  Future<void> updateCart(Product product, int quantity) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> cartData = json.decode(prefs.getString('cartData') ?? '{}');

      cartData[product.id.toString()] = quantity;

      await prefs.setString('cartData', json.encode(cartData));
      loadCartData();
    } catch (e) {
      print('Error updating cart: $e');
    }
  }
  Future<void> _createNewOrder() async {
    List<Map<String, dynamic>> orderLines = cartProducts
        .map((product) => {
      'product_id': product.id,
      'quantity': cartData[product.id.toString()],
    })
        .toList();

    Map<String, dynamic> orderPayload = {
      'orderDate': selectedDate.toString().substring(0, 10),
      'lines': orderLines,
    };

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Token");
      String appId =
          '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

      final response = await http.post(
        Uri.parse('$baseUrl/order'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-app-id-token': appId,
        },
        body: jsonEncode(orderPayload),
      );

      if (response.statusCode == 200) {
        prefs.remove("cartData");
        AnimatedSnackBar.material(
          duration: const Duration(seconds: 5),
          "Order created successfully",
          type: AnimatedSnackBarType.success,
          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        ).show(context);
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Dashboard()));
        Navigator.pop(context);
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      print('Error creating order: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(VariableUtils.cart,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500)),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            backgroundColor: Color(0xffE8E6EA),
            body: cartData.length<=0 ? NoDataFound() : Stack(children: [
              Column(children: [
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Material(
                                  elevation: 1,
                                  color: ColorUtils.white,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            leading: Icon(
                                              Icons.shopping_cart_outlined,
                                              color: ColorUtils.black,
                                              size: 20,
                                            ),
                                            title: Text(
                                              VariableUtils.itemsIYCart,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          ListView.separated(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                Product product=cartProducts[index];
                                                return ListTile(
                                                    title: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          product.title,
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 10),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              product.weightDisplay,
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: ColorUtils
                                                                      .black2D),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    leading: Container(
                                                      width:
                                                      5,
                                                      height: 5,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    trailing: Container(
                                                        width: 180,
                                                        height: 30,
                                                        child: Row(children: [
                                                          CartStepperInt(
                                                            value:  getQuantityInCart(product),
                                                            size: 25,
                                                            style:
                                                            CartStepperStyle(
                                                              foregroundColor:
                                                              Colors.black,
                                                              activeForegroundColor:
                                                              Colors.black,
                                                              activeBackgroundColor:
                                                              Colors.white,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black),
                                                              radius: const Radius
                                                                  .circular(20),
                                                              elevation: 0,
                                                              buttonAspectRatio:
                                                              1.2,
                                                            ),
                                                            didChangeCount:
                                                                (count) {
                                                              setState(() {
                                                                if (count > 0) {
                                                                  updateCart(product, count);
                                                                } else {
                                                                  removeFromCart(product);
                                                                }
                                                              });
                                                            },
                                                          ),
                                                          SizedBox(width: 20),
                                                          Text(
                                                            "₹ "+product.price.toString(),
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ])));
                                              },
                                              separatorBuilder: (context, index) =>
                                                  Divider(
                                                    thickness: 1,
                                                    color: Colors.black12,
                                                  ),
                                              itemCount: cartProducts.length)
                                        ],
                                      ))),
                              SizedBox(
                                height: 10,
                              ),
                              Material(
                                  elevation: 1,
                                  color: ColorUtils.white,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            leading: Icon(
                                              Icons.text_snippet_outlined,
                                              color: ColorUtils.black,
                                              size: 20,
                                            ),
                                            title: Text(
                                              VariableUtils.paymentDtl,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            leading: Text(
                                              VariableUtils.itemTtl,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            trailing: Text(
                                              "₹ "+totalPrice.toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 0.5,
                                          ),
                                          ListTile(
                                            leading: Text(
                                              VariableUtils.deliveryFee,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            trailing: Text(
                                              "₹ 20",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 0.5,
                                          ),
                                          ListTile(
                                            leading: Text(
                                              VariableUtils.toPay,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            trailing: Text(
                                              "₹ "+(totalPrice+20).toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))),
                              SizedBox(
                                height: 100,
                              ),
                            ])))
              ]),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 90,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      width: _width,
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorUtils.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: ColorUtils.black),
                          ),
                        ),
                        onPressed: () {
                          _createNewOrder();
                        },
                        child: Text(
                          "PLACE ORDER",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ])));
  }
}