import 'package:client_flutter_master/utils/color_utils.dart';
import 'package:client_flutter_master/utils/images_utils.dart';
import 'package:client_flutter_master/utils/variable_utils.dart';
import 'package:client_flutter_master/view/login/login_screen.dart';
import 'package:client_flutter_master/view/order/my_orders.dart';
import 'package:client_flutter_master/view/profile/profile.dart';
import 'package:client_flutter_master/view/subscription/my_subscriptions.dart';
import 'package:client_flutter_master/view/support/support.dart';
import 'package:client_flutter_master/view/wallet/transactions.dart';
import 'package:client_flutter_master/view/wallet/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/icons_utils.dart';
import '../product_screens/product_category.dart';
import '../profile/address/my_addresses.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:octo_image/octo_image.dart';
class AccountFragment extends StatefulWidget {
  const AccountFragment({Key? key}) : super(key: key);
  @override
  State<AccountFragment> createState() => _AccountFragmentState();
}

class _AccountFragmentState extends State<AccountFragment>{
  String name="",mob="",email="";

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    getSP();
    super.initState();
  }

  void _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("Token");
    prefs.remove("Expiry");
    prefs.remove("Login");
    AnimatedSnackBar.material(
      duration: const Duration(seconds: 3),
      "Logout success",
      type: AnimatedSnackBarType.success,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    ).show(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
  void getSP() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name=prefs.getString("FNAME")!+" "+prefs.getString("LNAME")!;
      mob=prefs.getString("MOBILE")!;
      email=prefs.getString("EMAIL")!;
    });
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
              title: Text(VariableUtils.myAccount,
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
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 1,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ProfileScreen()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        width: _width,
                        child: Card(
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            color: Colors.white,
                            child: Padding(
                                padding: EdgeInsets.all(2),
                                child: ListTile(
                                    leading: CircleAvatar(
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
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(name,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          mob,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(email,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => ProfileScreen()));
                                      },
                                    )))),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductCategory()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        width: _width,
                        child: Card(
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFDEDEDE),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.menu,
                                      color: ColorUtils.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  VariableUtils.shopByCat,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      width: _width,
                      child: Card(
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          color: Colors.white,
                          child: Padding(
                              padding: EdgeInsets.all(2),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyAddresses()));
                                    },
                                    child: ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFDEDEDE),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.home_work,
                                            color: ColorUtils.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        VariableUtils.myAddress,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MySubscription()));
                                    },
                                    child: ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFDEDEDE),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.event_note,
                                            color: ColorUtils.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        VariableUtils.mySubscrip,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyOrders()));
                                    },
                                    child: ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFDEDEDE),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.history,
                                            color: ColorUtils.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        "Past Delivery",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WalletScreen()));
                                    },
                                    child: ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFDEDEDE),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.wallet,
                                            color: ColorUtils.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        VariableUtils.myWallet,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Transaction()));
                                    },
                                    child: ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFDEDEDE),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.currency_rupee,
                                            color: ColorUtils.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        VariableUtils.myTransact,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Support()));
                                    },
                                    child: ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFDEDEDE),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.support_agent,
                                            color: ColorUtils.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        "Help & Support",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ))),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        _logout();
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        width: _width,
                        child: Card(
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFDEDEDE),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.logout,
                                      color: ColorUtils.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  VariableUtils.logOut,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        VariableUtils.appVersion,
                        style: TextStyle(
                            color: Color(0xFF565656),
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                  ],
                )),
              )
            ])));
  }
}
