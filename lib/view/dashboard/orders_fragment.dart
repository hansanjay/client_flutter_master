import 'package:client_flutter_master/utils/color_utils.dart';
import 'package:client_flutter_master/utils/const_utils.dart';
import 'package:client_flutter_master/view/general_screens/no_data_found.dart';
import 'package:client_flutter_master/view/order/modify_order.dart';
import 'package:client_flutter_master/view/order/orders.dart';
import 'package:client_flutter_master/view/subscription/my_subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cart_stepper/cart_stepper.dart';
import '../../models/order_model.dart';
import '../../services/order_service.dart';
import '../../utils/variable_utils.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

final today = DateUtils.dateOnly(DateTime.now());
late DateTime selectedDate;
int checkId=0;
class OrdersFragment extends StatefulWidget {
  const OrdersFragment({Key? key}) : super(key: key);
  @override
  State<OrdersFragment> createState() => _OrdersFragmentState();
}

class _OrdersFragmentState extends State<OrdersFragment> {
  bool currentDate = true;
  late Future<List<Order>> futureOrders;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    selectedDate = DateTime(today.year, today.month, today.day+1);
    refreshOrders();
    super.initState();
  }
  void refreshOrders() {
    setState(() {
      futureOrders = OrderService().fetchOrdersByDate(selectedDate);
    });
  }
  
  Future<void> _updateOrder(int orderId, int productId, int quantity) async {
    Map<String, dynamic> orderPayload = {
      'lines': [
        {'product_id': productId, 'quantity': quantity},
      ],
    };

    try {
      await OrderService().updateOrder(orderPayload, orderId);
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        "Order deleted successfully",
        type: AnimatedSnackBarType.success,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      refreshOrders();
    } catch (e) {
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        e.toString(),
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      print('Error updating order: $e');

    }
  }
  void gotosubsciption(){
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MySubscription()));
  }
  void gotomodify(int orderId,int lineId, DateTime dateTime){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ModifyOrder(orderId: orderId, lineId: lineId, dateTime: dateTime,)));
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
            title: Text("Orders",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.w500)),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          backgroundColor: Color(0xffE8E6EA),
          body: Column(children: [
            Material(
                elevation: 1,
                color: ColorUtils.white,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 5),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        HorizontalWeekCalendar(
                          weekStartFrom: WeekStartFrom.Monday,
                          activeBackgroundColor: Colors.black,
                          activeTextColor: Colors.white,
                          inactiveBackgroundColor: Colors.black.withOpacity(.2),
                          inactiveTextColor: Colors.white,
                          disabledTextColor: Colors.grey,
                          disabledBackgroundColor: Colors.grey.withOpacity(.2),
                          activeNavigatorColor: Colors.black,
                          inactiveNavigatorColor: Colors.grey,
                          monthColor: Colors.black,
                          onDateChange: (date) {
                            setState(() {
                              selectedDate = date;
                              futureOrders =
                                  OrderService().fetchOrdersByDate(date);
                            });
                          },
                          borderRadius: BorderRadius.circular(5),
                          showNavigationButtons: true,
                          monthFormat: "MMMM yyyy",
                          minDate:
                              DateTime(today.year, today.month, today.day),
                          maxDate:
                              DateTime(today.year, today.month, today.day + 31),
                          initialDate:
                              DateTime(today.year, today.month, today.day+1),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ))),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  FutureBuilder<List<Order>>(
                    future: futureOrders,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        checkId=0;
                        return Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: NoDataFound(),
                        );
                      } else {
                        final orders = snapshot.data!;
                        final orderLines =
                            orders.expand((order) => order.lines).toList();
                        checkId=orders[0].id;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: orderLines.length,
                          itemBuilder: (context, index) {
                            final orderLine = orderLines[index];
                            final product = orderLine.product;

                            return Container(
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
                                        children: [
                                          Text(
                                            "Order Type:",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            orderLine.subscriptionId == 0
                                                ? " Buy Once"
                                                : " Subscribed",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        height: 1,
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "$baseUrl/" +
                                                        product.imageUrl),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.brand ?? "",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                product.title ?? "",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                product.weightDisplay,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: ColorUtils.grey85),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                "Quantity: " +
                                                    orderLine.quantity
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: ColorUtils.grey85),
                                              ),
                                              SizedBox(height: 5),
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
                                                    "${VariableUtils.rupee}${product.mrp}",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                        Column(children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Divider(
                                            height: 1,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          if (orderLine.subscriptionId == 0)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  gotomodify(orders[0].id, orderLine.id, selectedDate);
                                                  // Navigator.push(context,  MaterialPageRoute(builder: (context) => ModifyOrder(orderId: orders[0].id, lineId: orderLine.id, dateTime: selectedDate,)));
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .calendar_month_outlined,
                                                      size: 15,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      VariableUtils.modify,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: 1.0,
                                                height: 10.0,
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                    _updateOrder(orders[0].id, orderLine.productId, 0);
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.delete_outline,
                                                      size: 13,
                                                      color: Colors.red,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      VariableUtils.delete
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.red,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                          else
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    gotosubsciption();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .calendar_month_outlined,
                                                        size: 15,
                                                        color: Colors.black,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        VariableUtils.modify,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ])
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ])))
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return ShowCategory();
                  });
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.black,
          ),
        ));
  }
}

class Category {
  final String name;
  final String imageUrl;

  Category({required this.name, required this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] ?? 'Unknown',
      imageUrl: json['categoryImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'categoryImage': imageUrl,
    };
  }
}

class CategoryItem extends StatelessWidget {
  final Category category;
  CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (ctx) {
                  return ProductListModal(
                    category: category.name
                  );
                });
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  image: DecorationImage(
                    image: NetworkImage("$baseUrl/" +
                        category.imageUrl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Center(
                    child: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                )),
              ),
            ],
          ),
        ));
  }
}

class ShowCategory extends StatefulWidget {

  @override
  _ShowCategoryState createState() => _ShowCategoryState();
}

class _ShowCategoryState extends State<ShowCategory> {
  int countModal = 0;
  List<Category> categories = [];
  Future<void> fetchCategories() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String? cachedCategories = prefs.getString('cachedCategories');

      if (cachedCategories != null) {
        final List<dynamic> categoriesData = jsonDecode(cachedCategories);

        setState(() {
          categories =
              categoriesData.map((item) => Category.fromJson(item)).toList();
        });
        return;
      }

      String? token = prefs.getString("Token");
      String url = '$baseUrl/product/list';
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
        final data = jsonDecode(response.body);

        setState(() {
          categories = (data['categories'] as List)
              .where((item) => item['parentId'] == 1)
              .map((item) => Category(
                  name: item['name'] ?? 'Unknown',
                  imageUrl: item['categoryImage'] ?? ''))
              .toList();
        });
        String categoriesJson = jsonEncode(
            categories.map((category) => category.toJson()).toList());

        prefs.setString('cachedCategories', categoriesJson);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 20),
            ListTile(
              title: Text(
                'Select product category',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.close, size: 30),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryItem(category: categories[index]);
                },
                padding: EdgeInsets.all(5),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final int id;
  final String title;
  final String brand;
  final String imageUrl;
  final String weightDisplay;
  final double price;

  Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.imageUrl,
    required this.weightDisplay,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      brand: json['brand'],
      imageUrl: json['image_url'],
      weightDisplay: json['weightDisplay'],
      price: json['price'].toDouble(),
    );
  }
}

class ProductListModal extends StatefulWidget {
  final String category;
  const ProductListModal({Key? key, required this.category}) : super(key: key);

  @override
  _ProductListModalState createState() => _ProductListModalState();
}

class _ProductListModalState extends State<ProductListModal> {
  int _selectedIndex = 0;
  List<String> _tabs = ['All'];
  bool isLoading = true;
  List<Product> _products = [];
  String _selectedSubcategory = 'All';
  Map<int, int> _productQuantities = {};
  bool showButton = false;
  void filterProductsBySubcategory(String subcategory) {
    setState(() {
      _selectedSubcategory = subcategory;
      fetchProducts();
    });
  }

  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
    });

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
        // print('Data fetched successfully: $data');

        setState(() {
          _products.clear();
          _tabs.clear();
          _tabs.add('All');
          for (var productData in data['products']) {
            if (productData['category'] == widget.category) {
              String subCategory = productData['subCategory'] ?? 'All';
              if (!_tabs.contains(subCategory)) {
                _tabs.add(subCategory);
              }
              if (_selectedSubcategory == 'All' ||
                  subCategory == _selectedSubcategory) {
                Product product = Product(
                  id: productData['id'],
                  title:
                      productData['title'] != null ? productData['title'] : "",
                  brand:
                      productData['brand'] != null ? productData['brand'] : "",
                  imageUrl: productData['image_url'] != null
                      ? productData['image_url']
                      : "",
                  weightDisplay: productData['weightDisplay'] != null
                      ? productData['weightDisplay']
                      : "",
                  price: productData['price'] != null
                      ? productData['price'].toDouble()
                      : 0.0,
                );
                _products.add(product);
                _productQuantities[product.id] = 0;
              }
            }
          }

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  void _updateQuantity(int productId, int quantity) {
    setState(() {
      _productQuantities[productId] = quantity;
    });
  }

  Future<void> _createNewOrder() async {
    List<Map<String, dynamic>> orderLines = _products
        .where((product) => _productQuantities[product.id]! > 0)
        .map((product) => {
              'product_id': product.id,
              'quantity': _productQuantities[product.id],
            })
        .toList();

    Map<String, dynamic> orderPayload = {
      'orderDate': selectedDate.toString().substring(0, 10),
      'lines': orderLines,
    };

    try {
      await OrderService().createOrder(orderPayload);
      Navigator.pop(context);
      Navigator.pop(context);
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        "Order created successfully",
        type: AnimatedSnackBarType.success,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Orders(date: selectedDate,)));
    } catch (e) {
      print('Error creating order: $e');
    }
  }

  Future<void> _updateOrder() async {
    List<Map<String, dynamic>> orderLines = _products
        .where((product) => _productQuantities[product.id]! > 0)
        .map((product) => {
      'product_id': product.id,
      'quantity': _productQuantities[product.id],
    })
        .toList();

    Map<String, dynamic> orderPayload = {
      'lines': orderLines,
    };


    try {
      await OrderService().updateOrder(orderPayload, checkId);
      Navigator.pop(context);
      Navigator.pop(context);
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        "Order modified successfully",
        type: AnimatedSnackBarType.success,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Orders(date: selectedDate,)));
    } catch (e) {
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        e.toString(),
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      print('Error updating order: $e');

    }
  }
  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: SafeArea(
            top: false,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Stack(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        ListTile(
                          title: Text(
                            'Add products to order',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.close, size: 30),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Material(
                          elevation: 1,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(15),
                                  child: SizedBox(
                                    height: 40,
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
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: _selectedIndex == index
                                                  ? Colors.black
                                                  : Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              _tabs[index],
                                              style: TextStyle(
                                                color: _selectedIndex == index
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _products.length,
                            itemBuilder: (context, index) {
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
                                          SizedBox(height: 5),
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
                                              SizedBox(width: 15),
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
                                                  SizedBox(height: 3),
                                                  Text(
                                                    product.title,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    product.weightDisplay,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  SizedBox(height: 3),
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
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 5.0,
                                                right: 5.0,
                                                top: 10.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                _productQuantities[
                                                            product.id]! >
                                                        0
                                                    ? CartStepperInt(
                                                        value:
                                                            _productQuantities[
                                                                    product
                                                                        .id] ??
                                                                0,
                                                        size: 25,
                                                        style: CartStepperStyle(
                                                          foregroundColor:
                                                              Colors.black,
                                                          activeForegroundColor:
                                                              Colors.black,
                                                          activeBackgroundColor:
                                                              Colors.white,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                          radius: const Radius
                                                              .circular(20),
                                                          elevation: 0,
                                                          buttonAspectRatio:
                                                              2.5,
                                                        ),
                                                        didChangeCount:
                                                            (count) {
                                                          setState(() {
                                                            _updateQuantity(
                                                                product.id,
                                                                count);
                                                            if (_productQuantities
                                                                    .length >
                                                                0) {
                                                              showButton = true;

                                                            } else {
                                                              showButton =
                                                                  false;

                                                            }
                                                          });
                                                        },
                                                      )
                                                    : Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 10.0),
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
                                                                          12),
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _productQuantities[
                                                                        product
                                                                            .id] = 1;
                                                                    if (_productQuantities
                                                                            .length >
                                                                        0) {
                                                                      showButton =
                                                                          true;
                                                                    } else {
                                                                      showButton =
                                                                          false;
                                                                    }
                                                                  });
                                                                },
                                                              )),
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
                            },
                          ),
                        )
                      ],
                    ),
                    Visibility(
                      visible: showButton,
                      child: Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 60,
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
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorUtils.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                        color: ColorUtils.black),
                                  ),
                                ),
                                onPressed: () {
                                  print("CheckId: "+checkId.toString());
                                  if(checkId<=0){
                                    _createNewOrder();
                                  }
                                  else
                                    {
                                      _updateOrder();
                                    }
                                },
                                child: Text(
                                  "Place Order",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ])),
      ),
    );
  }
}
