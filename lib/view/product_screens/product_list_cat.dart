import 'dart:convert';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:client_flutter_master/utils/const_utils.dart';
import 'package:client_flutter_master/view/general_screens/no_data_found.dart';
import 'package:client_flutter_master/view/general_screens/shimmer_product_list.dart';
import 'package:client_flutter_master/view/subscription/subscribe_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/product_model.dart';
import '../../services/cart_service.dart';
import '../../utils/color_utils.dart';
import '../../utils/variable_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../cart/cart_screen.dart';
class ProductListCat extends StatefulWidget {
  final String category;
  const ProductListCat({Key? key, required this.category}) : super(key: key);
  @override
  State<ProductListCat> createState() => _ProductListCatState();
}

class _ProductListCatState extends State<ProductListCat> {
  int _selectedIndex = 0;
  List<String> _tabs = [
    'All',
  ];
  bool showCounter = false, isLoading = true;
  int _counter = 1;
  String _selectedOption = 'Relevance';
  List<Product> _products = [];
  String _selectedSubcategory = 'All';
  final CartService _cartService = CartService();
  Map<String, int> _cartData = {};
  List<Product> productData = [];
  Future<void> fetchData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Token");
      String url = '$baseUrl/product/list';
      String appId =
          '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-app-id-token': appId
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _products.clear();
          _tabs.clear();
          _tabs.add('All');
          for (var product in data['products']) {
            productData.add(Product.fromJson(product));
            if (product['category'] == widget.category) {
              String subCategory = product['subCategory'] ?? 'All';
              if (!_tabs.contains(subCategory)) {
                _tabs.add(subCategory);
              }
              if (_selectedSubcategory == 'All' ||
                  subCategory == _selectedSubcategory) {
                _products.add(Product.fromJson(product));
              }
            }
          }
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
        isLoading = false;
      }
    } catch (e) {
      print('Error: $e');
      isLoading = false;
    }
  }

  void filterProductsBySubcategory(String subcategory) {
    setState(() {
      _selectedSubcategory = subcategory;
      fetchData();
    });
  }

  void sortProducts(String option) {
    setState(() {
      _selectedOption = option;
      if (_selectedOption == 'Price - Low to High') {
        _products.sort((a, b) => a.price.compareTo(b.price));
      } else if (_selectedOption == 'Price - High to Low') {
        _products.sort((a, b) => b.price.compareTo(a.price));
      }
    });
  }

  Future<void> addToCart(Product product1) async {
    try {
      await _cartService.addToCart(product1, 1);
      loadCartData();
    } catch (e) {
      print('Error adding to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add product to cart'),
        ),
      );
    }
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
  Future<void> loadCartData() async {
    _cartData.clear();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> cartData = json.decode(prefs.getString('cartData') ?? '{}');
      setState(() {
        _cartData = cartData.cast<String, int>();
      });
    } catch (e) {
      print('Error loading cart data: $e');
    }
  }
  bool isInCart(Product product) {
    return _cartData.containsKey(product.id.toString());
  }
  int getQuantityInCart(Product product) {
    return _cartData[product.id.toString()] ?? 0;
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
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    fetchData();
    loadCartData();
    super.initState();
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
              title: Text(widget.category,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500)),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            backgroundColor: Color(0xffE8E6EA),
            body: isLoading
                ? ShimmerProductList()
                : (_products.length > 0
                    ? Stack(children: [Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Material(
                              elevation: 1,
                              color: ColorUtils.white,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 15,right: 15,bottom: 10,top: 10),
                                          child: SizedBox(
                                            height: 30,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: _tabs.length,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedIndex = index;
                                                      filterProductsBySubcategory(
                                                          _tabs[index]);
                                                    });
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 0),
                                                    decoration: BoxDecoration(
                                                      color: _selectedIndex ==
                                                              index
                                                          ? Colors.black
                                                          : Colors.grey[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Text(
                                                      _tabs[index],
                                                      style: TextStyle(
                                                        color: _selectedIndex ==
                                                                index
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          height: 1,
                                        ),
                                        ListTile(
                                            leading: Text(
                                                _products.length.toString() +
                                                    " Products",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            trailing: Container(
                                              height: 30,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Sort By',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                    PopupMenuButton(
                                                      surfaceTintColor:
                                                          Colors.white,
                                                      padding: EdgeInsets.zero,
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
                                                      itemBuilder: (BuildContext
                                                              context) =>
                                                          [
                                                        PopupMenuItem(
                                                          child: RadioListTile(
                                                            title: Text(
                                                                'Price - Low to High'),
                                                            value:
                                                                'Price - Low to High',
                                                            groupValue:
                                                                _selectedOption,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _selectedOption =
                                                                    value
                                                                        .toString();
                                                                sortProducts(value
                                                                    .toString());
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          child: RadioListTile(
                                                            title: Text(
                                                                'Price - High to Low'),
                                                            value:
                                                                'Price - High to Low',
                                                            groupValue:
                                                                _selectedOption,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _selectedOption =
                                                                    value
                                                                        .toString();
                                                                sortProducts(value
                                                                    .toString());
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                      ]))),
                          SizedBox(height: 2),
                          Expanded(
                            child: ListView(
                              children:
                                  List.generate(_products.length, (index) {
                                var product = _products[index];
                                return InkWell(
                                  onTap: () async {},
                                  child: Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    child: Card(
                                      surfaceTintColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      color: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "$baseUrl/" +
                                                              product.imageUrl),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product.brand,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      product.title,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      product.weightDisplay,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: ColorUtils
                                                              .grey85),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "MRP:  ",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          '₹ ${product.price.toString()}',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              height: 1,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5.0,
                                                  right: 5.0,
                                                  top: 10.0),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  isInCart(product)?  CartStepperInt(
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
                                                                2,
                                                          ),
                                                          didChangeCount:
                                                              (count) {
                                                                setState(() {
                                                                  _counter = count;
                                                                  if (_counter > 0) {
                                                                    updateCart(product, _counter);
                                                                  } else {
                                                                    removeFromCart(product);
                                                                  }
                                                                });
                                                          },
                                                        )
                                                      : Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right:
                                                                        10.0),
                                                            child: Container(
                                                                height: 30,
                                                                child:
                                                                    OutlinedButton(
                                                                  child: Text(
                                                                    "Buy Once",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                        setState(() {
                                                                            addToCart(product);
                                                                        });
                                                                  },
                                                                )),
                                                          ),
                                                          flex: 2,
                                                        ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10.0),
                                                      child: Container(
                                                          height: 30,
                                                          child:
                                                              new OutlinedButton(
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor: MaterialStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .black),
                                                                  ),
                                                                  child: new Text(
                                                                      "Subscribe @ " +
                                                                          VariableUtils
                                                                              .rupee +
                                                                          product.price.toString(),
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              10)),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                SubscribeCart(id: product.id,)));
                                                                  })),
                                                    ),
                                                    flex: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          if(_cartData.length > 0)
                            SizedBox(height: 80,),
                        ],
                      ),
              Visibility(
              visible: _cartData.length>0 ? true : false,
              child: Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 70,
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
                      padding: const EdgeInsets.all(5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorUtils.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: ColorUtils.black),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => CartScreen(products: productData)));
                        },
                        child: Text(
                          "VIEW CART",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
            ])
                    : NoDataFound())));
  }
}