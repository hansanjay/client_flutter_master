import 'package:client_flutter_master/models/profile_model.dart';
import 'package:client_flutter_master/services/profile_service.dart';
import 'package:client_flutter_master/utils/color_utils.dart';
import 'package:client_flutter_master/utils/variable_utils.dart';
import 'package:client_flutter_master/view/profile/address/add_address.dart';
import 'package:client_flutter_master/view/profile/address/edit_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
class MyAddresses extends StatefulWidget {
  const MyAddresses({Key? key}) : super(key: key);
  @override
  State<MyAddresses> createState() => _MyAddressesState();
}

class _MyAddressesState extends State<MyAddresses> {
  var addressList = [];
  String name = "", mob = "";
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    fetchAddress();
    getSP();
    super.initState();
  }

  void fetchAddress() async {
    try {
      ProfileService profileService = ProfileService();
      Profile profile = await profileService.fetchProfile();
      setState(() {
        addressList = profile.addressList;
      });
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  void getSP() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("FNAME")! + " " + prefs.getString("LNAME")!;
      mob = prefs.getString("MOBILE")!;
    });
  }
  Future<void> _deleteAddress(int id) async {
    try {
      await ProfileService().deleteAddress(id);
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        "Address deleted successfully",
        type: AnimatedSnackBarType.success,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => MyAddresses()));
      fetchAddress();
    } catch (e) {
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        e.toString(),
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
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
              title: Text(VariableUtils.myAddress,
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
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddAddress()));
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
                            child: ListTile(
                              leading: Icon(
                                Icons.add,
                                color: ColorUtils.black,
                                size: 20,
                              ),
                              title: Text(
                                VariableUtils.addAddress,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 0.5,
                          width: 90,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          VariableUtils.savedAddress,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 0.5,
                          width: 90,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(addressList.length, (index) {
                        return InkWell(
                          onTap: () async {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditAddress(
                                        id: addressList[index].id)));
                          },
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (addressList[index].isDefault)
                                      Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 20),
                                            decoration: BoxDecoration(
                                              color: Colors.lightGreenAccent[200],
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              "Default",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                        ],
                                      ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        if (!addressList[index].isDefault)
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              size: 30,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              _deleteAddress(addressList[index].id);
                                            },
                                          )
                                      ],
                                    ),
                                    Text(
                                      addressList[index].line1 +
                                          ", " +
                                          addressList[index].line2 +
                                          ", " +
                                          addressList[index].line3 +
                                          ", " +
                                          addressList[index].city +
                                          ", " +
                                          addressList[index].stateName,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      VariableUtils.phoneNumber + " " + mob,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                )),
              )
            ])));
  }
}
