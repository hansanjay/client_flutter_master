import 'dart:convert';
import 'package:client_flutter_master/models/profile_model.dart';
import 'package:client_flutter_master/services/profile_service.dart';
import 'package:client_flutter_master/utils/const_utils.dart';
import 'package:client_flutter_master/utils/icons_utils.dart';
import 'package:client_flutter_master/utils/variable_utils.dart';
import 'package:client_flutter_master/view/cart/cart_screen.dart';
import 'package:client_flutter_master/view/product_screens/product_list_brand.dart';
import 'package:client_flutter_master/view/product_screens/search_product.dart';
import 'package:client_flutter_master/view/profile/profile.dart';
import 'package:client_flutter_master/view/wallet/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../models/product_model.dart';
import '../../utils/color_utils.dart';
import '../../utils/images_utils.dart';
import '../product_screens/product_list_cat.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:octo_image/octo_image.dart';
class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);
  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  bool showCounter = false;
  String name="";
  List<Category1> categories = [];
  List<BrandCat> brands = [];
  List<Product> products = [];
  Future<void> fetchData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // String? cachedCategories = prefs.getString('cachedCategories');
      // String? cachedBrands = prefs.getString('cachedBrands');
      // String? cachedProducts = prefs.getString('cachedProducts');
      //
      // if (cachedCategories != null && cachedBrands != null && cachedProducts != null) {
      //   final List<dynamic> categoriesData = jsonDecode(cachedCategories);
      //   final List<dynamic> brandsData = jsonDecode(cachedBrands);
      //   final List<dynamic> productsData = jsonDecode(cachedProducts);
      //   setState(() {
      //     categories = categoriesData
      //         .map((item) => Category1.fromJson(item))
      //         .toList();
      //     brands = brandsData.map((item) => BrandCat.fromJson(item)).toList();
      //     products = productsData.map((item) => Product.fromJson(item)).toList();
      //   });
      //   return;
      // }

      String? token = prefs.getString("Token");
      String url = '$baseUrl/product/list';
      String appId = '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

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
                      .map((item) => Category1(
                      name: item['name'] ?? 'Unknown',
                      imageUrl: item['categoryImage'] ?? ''))
                      .toList();
                  brands = (data['brands'] as List)
                      .map((item) => BrandCat(
                      name: item['name'] ?? 'Unknown',
                      imageUrl: item['brandImage'] ?? ''))
                      .toList();

          for (var product in data['products']) {
            products.add(Product.fromJson(product));
          }
        });
        String categoriesJson = jsonEncode(categories.map((category) => category.toJson()).toList());
        String brandsJson = jsonEncode(brands.map((brand) => brand.toJson()).toList());
        String productsJson = jsonEncode(products.map((product) => product.toJson()).toList());

        prefs.setString('cachedCategories', categoriesJson);
        prefs.setString('cachedBrands', brandsJson);
        prefs.setString('cachedProducts', productsJson);
      } else {

        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  void fetchProfile() async {
    try {
      ProfileService profileService = ProfileService();
      Profile profile = await profileService.fetchProfile();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("FNAME", profile.firstName);
      prefs.setString("LNAME", profile.lastName);
      prefs.setString("MOBILE", profile.mobile);
      prefs.setString("EMAIL", profile.email);

      setState(() {
        name=profile.firstName +" "+profile.lastName;
      });
    } catch (e) {
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        "Error fetching profile",
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      print('Error fetching profile: $e');
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
    fetchProfile();
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
            leading: Padding(
                padding: EdgeInsets.only(left: 10,top: 8,bottom: 8),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()));
                  },
                  child:  CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: OctoImage(
                    height: 70,
                    image: AssetImage('assets/image/panda.png'),
                    progressIndicatorBuilder:
                    OctoProgressIndicator.circularProgressIndicator(),
                    imageBuilder: OctoImageTransformer.circleAvatar(),
                    errorBuilder: (context, ob, st) {
                      return IconsWidgets.deliveryMan;
                    },
                    fit: BoxFit.cover,
                  ),
                ),
                )),
            title: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WalletScreen()));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, ',
                        style: TextStyle(fontSize: 12.0, color: Colors.black87),
                      ),
                      SizedBox(width: 2),
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        VariableUtils.walletBalance+": ",
                        style: TextStyle(fontSize: 10.0, color: Colors.black87),
                      ),
                      SizedBox(width: 2),
                      Text(
                        '₹ 500',
                        style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.wallet,
                  color: Colors.black,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WalletScreen()));
                },
              ),
              SizedBox(width: 10,),
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartScreen(products: products)));
                },
              ),
            ],
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          // backgroundColor: Color(0xffE8E6EA),
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                height: 1,
              ),
              Material(
                  elevation: 1,
                  color: ColorUtils.white,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                readOnly: true,
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => SearchProduct()),
                                  // );
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  hintText: VariableUtils.searchHint,
                                  border: OutlineInputBorder(

                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ]))),
              Container(
                width: _width,
                height: 50,
                color: Colors.orange[50],
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    IconsWidgets.deliveryMan,
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: VariableUtils.dlvryTimeTxt1,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: VariableUtils.dlvryTimeTxt2,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: VariableUtils.dlvryTimeTxt3,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 150,
                      ),
                      items: imageSliders,
                    ),
                  ),
                  Container(
                      width: _width,
                      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                      height: 50,
                      color: Colors.orange[50],
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            VariableUtils.shopByCat.toUpperCase(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    width: _width,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return CategoryItem1(category: categories[index]);
                      },
                      padding: EdgeInsets.all(5),
                    ),
                  ),
                  Container(
                      width: _width,
                      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                      height: 50,
                      color: Colors.orange[50],
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            VariableUtils.shopByPlrBrnd,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),

                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: brands.length,
                      itemBuilder: (context, index) {
                        return BrandCatItem(brandcat1: brands[index]);
                      },
                      padding: EdgeInsets.all(5),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Center(
                    child: MadeWithLove(),
                  ),
                  const SizedBox(height: 50),
                ],
              )))
            ],
          )
        ));
  }
}

final List<Widget> imageSliders = VariableUtils.imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Image.network(item, fit: BoxFit.fill, width: 1000.0)),
          ),
        ))
    .toList();

class Category1 {
  final String name;
  final String imageUrl;

  Category1({required this.name, required this.imageUrl});

  factory Category1.fromJson(Map<String, dynamic> json) {
    return Category1(
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

class CategoryItem1 extends StatelessWidget {
  final Category1 category;

  CategoryItem1({required this.category});

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

class BrandCat {
  final String name;
  final String imageUrl;

  BrandCat({required this.name, required this.imageUrl});

  factory BrandCat.fromJson(Map<String, dynamic> json) {
    return BrandCat(
      name: json['name'] ?? 'Unknown',
      imageUrl: json['brandImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brandImage': imageUrl,
    };
  }
}
class BrandCatItem extends StatelessWidget {
  final BrandCat brandcat1;

  BrandCatItem({required this.brandcat1});


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
                MaterialPageRoute(builder: (context) => ProductListBrand(brand: brandcat1.name,)));
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
                    image: NetworkImage("$baseUrl/"+brandcat1.imageUrl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only( top: 5),
                child: Center(child: Text(
                  brandcat1.name,
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
class MadeWithLove extends StatelessWidget {
  const MadeWithLove({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      VariableUtils.madeWithLv,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
