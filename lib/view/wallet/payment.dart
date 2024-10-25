// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:share/share.dart'; // Import share package for sharing
// import 'package:webview_flutter/webview_flutter.dart';
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final GlobalKey<WebViewControllerState> webviewKey =
//   GlobalKey<WebViewControllerState>(); // Key for accessing webview controller
//   late WebViewController _controller; // WebViewController instance
//
//   @override
//   void initState() {
//     super.initState();
//     // Ensure `webview_flutter` is added to your `pubspec.yaml` dependencies
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Payment WebView'),
//         ),
//         body: WebView(
//           key: webviewKey,
//           initialUrl: "https://xxxxxxxx.in/order/payment/45feb849dc05f910fc0aee992fd5be82",
//           javascriptMode: JavascriptMode.unrestricted,
//           onWebViewCreated: (WebViewController controller) async {
//             _controller = controller;
//             await controller.addJavascriptInterface(
//                 MyWebviewInterface(context, controller), 'AndroidInterface');
//           },
//           onUrlRequest: (NavigationRequest request) {
//             if (request.url.startsWith("upi:")) {
//               launch(request.url); // Use url_launcher to open UPI intent
//               return NavigationDecision.prevent; // Prevent default navigation
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class MyWebviewInterface {
//   final BuildContext context;
//   final WebViewController controller;
//
//   MyWebviewInterface(this.context, this.controller);
//
//   void handleMessage(String message) {
//     var data = jsonDecode(message);
//     switch (data['function']) {
//       case 'paymentResponse':
//         String txnStatus = data['txnStatus'];
//         String orderId = data['orderId'];
//         String txnId = data['txnId'];
//         // Handle payment response here (txnStatus, orderId, txnId)
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//                 "Status: $txnStatus, Order ID: $orderId, Txn ID: $txnId"),
//           ),
//         );
//         break;
//       case 'paymentError':
//         String errorMessage = data['errorMessage'];
//         // Handle payment error here (errorMessage)
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Error: $errorMessage"),
//           ),
//         );
//         break;
//       case 'shareImage':
//         String imageDataURL = data['imageDataURL'];
//         // Handle image sharing here (imageDataURL)
//         shareImage(imageDataURL);
//         break;
//       default:
//         print("Unknown function: ${data['function']}");
//     }
//   }
//
//   // Function to share image using share package
//   void shareImage(String imageDataURL) {
//     String imageData = imageDataURL.replace("data:image/png;base64,", "");
//     final bytes = Base64Decoder().convert(imageData);
//     final list = bytes.toList();
//     Share.share('QR Code Image',
//         shareContent: ShareContent(bytes: list, mimeType: 'image/png'));
//   }
// }
//
// // Call launch function from url_launcher package to open UPI intent
// void launch(String url) async {
//   if (await canLaunch(url)) {
//     await launchUrl(Uri.parse(url));
//   } else {
//     throw 'Could not launch $url';
//   }
// }
