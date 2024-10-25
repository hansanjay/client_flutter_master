import 'package:flutter/material.dart';

import '../../utils/variable_utils.dart';
import '../profile/address/add_address.dart';
import '../profile/address/edit_address.dart';

class CartModal extends StatelessWidget {
  const CartModal({Key? key});

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
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
                  VariableUtils.selectAddress,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Icons.close, size: 30),
                onTap: () => Navigator.of(context).pop(),
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddAddress()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: _width,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    color: Colors.white,
                    child: ListTile(
                      leading: Icon(
                        Icons.add,
                        color: Colors.black,
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
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 0.5,
                    width: 90,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 10),
                  Text(
                    VariableUtils.savedAddress,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 0.5,
                    width: 90,
                    color: Colors.grey,
                  ),
                ],
              ),
              ListView(
                shrinkWrap: true,
                physics:
                NeverScrollableScrollPhysics(),
                children: List.generate(2, (index) {
                  return InkWell(
                    onTap: () async {

                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      child: Card(
                        surfaceTintColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              7),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    VariableUtils.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                    },
                                  )
                                ],
                              ),
                              Text(
                                VariableUtils.address,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                VariableUtils.phoneNumber + " 9405961281",
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
              SizedBox(height: 20,)
            ],
          ),
        ),
    );
  }
}
