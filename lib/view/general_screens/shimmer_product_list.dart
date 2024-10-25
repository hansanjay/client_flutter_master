import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class ShimmerProductList extends StatelessWidget {
  const ShimmerProductList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.white,
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 20,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        width: double.infinity,
                        height: 20,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        width: double.infinity,
                        height: 20,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        width: double.infinity,
                        height: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}