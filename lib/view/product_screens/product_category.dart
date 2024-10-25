import 'dart:convert';

import 'package:client_flutter_master/utils/const_utils.dart';
import 'package:client_flutter_master/utils/variable_utils.dart';
import 'package:client_flutter_master/view/product_screens/product_list_cat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class ProductCategory extends StatefulWidget {
  const ProductCategory({Key? key}) : super(key: key);
  @override
  State<ProductCategory> createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  List<Category> categories = [];
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    fetchData();
    super.initState();
  }
  Future<void> fetchData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Token");
      String url = '$baseUrl/product/list';
      String appId = '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

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
          categories = (data['categories'] as List)
              .where((item) => item['parentId'] == 1)
              .map((item) => Category(
              name: item['name'] ?? 'Unknown',
              imageUrl: item['categoryImage'] ?? ''))
              .toList();
        });

      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
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
            title: Text(VariableUtils.shopByCat,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.w500)),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          backgroundColor: Color(0xffE8E6EA),
          body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return CategoryItem(category: categories[index]);
            },
            padding: EdgeInsets.all(5),
          ),
        ));
  }
}

class Category {
  final String name;
  final String imageUrl;

  Category({required this.name, required this.imageUrl});
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProductListCat(category: category.name,)));
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(5.0),
                  image: DecorationImage(
                    image: NetworkImage("$baseUrl/"+category.imageUrl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only( top: 5),
                child: Center(child: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),)
                ),
              ),
            ],
          ),
        ));
  }
}
