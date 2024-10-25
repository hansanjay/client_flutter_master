import 'package:client_flutter_master/services/profile_service.dart';
import 'package:client_flutter_master/utils/color_utils.dart';
import 'package:client_flutter_master/utils/variable_utils.dart';
import 'package:client_flutter_master/view/profile/address/my_addresses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/helpers.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class EditAddress extends StatefulWidget {
  final int id;
  const EditAddress({Key? key, required this.id}) : super(key: key);
  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController line1 = TextEditingController();
  TextEditingController line2 = TextEditingController();
  TextEditingController line3 = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  bool isDefault = false, isLoading = false;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    fetchAddress();
    super.initState();
  }

  void editAddress() async {
    try {
      final Map<String, dynamic> addressData = {
        'id': widget.id,
        'line1': line1.text.toString(),
        'line2': line2.text.toString(),
        'line3': line3.text.toString(),
        'pin_code': pincode.text.toString(),
        'state_name': state.text.toString(),
        'country': "India",
        'city': city.text.toString(),
        'short_name': "home",
        'geo_tag': null,
        'is_default': isDefault
      };

      print("Edited Address: " + addressData.toString());

      await ProfileService().updateAddress(addressData);
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        "Address updated successfully",
        type: AnimatedSnackBarType.success,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyAddresses()));
    } catch (e) {
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        e.toString(),
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
    }
  }

  Future<void> fetchAddress() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await ProfileService().fetchAddressById(widget.id);
      setState(() {
        line1.text = response['line1'].toString();
        line2.text = response['line2'].toString();
        line3.text = response['line3'].toString();
        pincode.text = response['pin_code'].toString();
        city.text = response['city'].toString();
        state.text = response['state_name'].toString();
        isDefault = response['is_default'];

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching subscription: $e');
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyAddresses()));
                },
              ),
              title: Text("Edit Address",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500)),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            backgroundColor: Colors.white,
            body: Column(children: [
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 1,
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: line1,
                              decoration: InputDecoration(
                                labelText: 'House No, Building Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your plot/flat number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: line2,
                              decoration: InputDecoration(
                                labelText: 'Road Name, Area, Colony',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your colony/area';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: line3,
                              decoration: InputDecoration(
                                labelText: 'Landmark',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter nearby landmark';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: pincode,
                              decoration: InputDecoration(
                                labelText: 'Pincode',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your pincode';
                                }
                                if (!isNumeric(value)) {
                                  return 'Pincode must be a number';
                                }
                                if (value.length != 6) {
                                  return 'Pincode must be 6 digits long';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: city,
                              decoration: InputDecoration(
                                labelText: 'City',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your city';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: state,
                              decoration: InputDecoration(
                                labelText: 'State',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your state name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Checkbox(
                                  value: isDefault,
                                  onChanged: (newValue) {
                                    setState(() {
                                      isDefault = newValue!;
                                    });
                                  },
                                ),
                                Text('Default Address'),
                              ],
                            ),
                            SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              child: Container(
                                width: _width,
                                height: 50,
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
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
                                    editAddress();
                                  },
                                  child: Text(
                                    "EDIT ADDRESS",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
              )
            ])));
  }
}
