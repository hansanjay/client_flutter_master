import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/color_utils.dart';
import 'package:image_picker/image_picker.dart';
class RaiseTicket extends StatefulWidget {
  final String issueType;
  const RaiseTicket({Key? key, required this.issueType}) : super(key: key);

  @override
  State<RaiseTicket> createState() => _RaiseTicketState();
}

class _RaiseTicketState extends State<RaiseTicket> {
  String? _selectedIssue;
  TextEditingController body = TextEditingController();
  List<DropdownMenuItem<String>> orderMenuItems = [
    'Missing Items',
    'Damaged Items',
    'Wrong Items Received',
    'Payment Issues',
    'Not able to order',
    'Product Quality',
    'Others',
  ].map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();

  List<DropdownMenuItem<String>> paymentMenuItems = [
    'Payment Declined',
    'Double Charged',
    'Refund Not Received',
    'Payment Gateway Errors',
    'Others',
  ].map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
  List<DropdownMenuItem<String>> subscriptionMenuItems = [
    'Delivery Schedule Issues',
    'Quality Concerns',
    'Not able to order',
    'Subscription Modification',
    'Late Delivery',
    'Others',
  ].map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
  List<DropdownMenuItem<String>> walletMenuItems = [
    'Transaction Errors',
    'Payment Failures',
    'Refund issue',
    'Others',
  ].map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
  List<DropdownMenuItem<String>> othersMenuItems = [
    'Technical Issues',
    'Account',
    'Others',
  ].map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
  bool _isPermissionGranted = false;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    super.initState();
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        // _image = File(pickedFile.);
      } else {
        print('No image selected.');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text("Raise Ticket",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          backgroundColor: const Color(0xffE8E6EA),
          body: Material(
              elevation: 1,
              color: ColorUtils.white,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select appropriate option",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20),
                      if (widget.issueType == "Order")
                        DropdownButtonFormField<String>(
                            value: _selectedIssue,
                            hint: Text('Select an issue'),
                            onChanged: (value) {
                              setState(() {
                                _selectedIssue = value;
                              });
                            },
                            items: orderMenuItems)
                      else if (widget.issueType == "Payment")
                        DropdownButtonFormField<String>(
                            value: _selectedIssue,
                            hint: Text('Select an issue'),
                            onChanged: (value) {
                              setState(() {
                                _selectedIssue = value;
                              });
                            },
                            items: paymentMenuItems)
                      else if (widget.issueType == "Subscription")
                        DropdownButtonFormField<String>(
                            value: _selectedIssue,
                            hint: Text('Select an issue'),
                            onChanged: (value) {
                              setState(() {
                                _selectedIssue = value;
                              });
                            },
                            items: subscriptionMenuItems)
                      else if (widget.issueType == "Wallet")
                        DropdownButtonFormField<String>(
                            value: _selectedIssue,
                            hint: Text('Select an issue'),
                            onChanged: (value) {
                              setState(() {
                                _selectedIssue = value;
                              });
                            },
                            items: walletMenuItems)
                      else if (widget.issueType == "Others")
                        DropdownButtonFormField<String>(
                            value: _selectedIssue,
                            hint: Text('Select an issue'),
                            onChanged: (value) {
                              setState(() {
                                _selectedIssue = value;
                              });
                            },
                            items: othersMenuItems),
                      SizedBox(height: 20),
                      TextField(
                        controller: body,
                        decoration: InputDecoration(
                          hintText: 'Brief details of the issue',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: width,
                        height: 40,
                        padding: const EdgeInsets.all(0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorUtils.white,
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: ColorUtils.black),
                            ),
                          ),
                          onPressed: () {
                            _pickImage();
                          },
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(
                              Icons.file_upload_outlined,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Upload Image",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        width: width,
                        height: 40,
                        padding: const EdgeInsets.all(0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorUtils.black,
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: ColorUtils.black),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "SUBMIT REQUEST",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ))),
        ));
  }
}
