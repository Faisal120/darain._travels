import 'dart:async';

import 'package:darain_travels/models/dashboard_response.dart';
import 'package:darain_travels/screens/dashboardScreen.dart';
import 'package:darain_travels/screens/payment_failure_screen.dart';
import 'package:darain_travels/screens/payment_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/subscription_plans.dart';

class PaymentWebView extends StatefulWidget {
  final String initialUrl;
  List<PlanList> planList;
  int index;
  Color planBackground, planButtonColor;

  PaymentWebView(this.planList, this.index, this.planBackground, this.planButtonColor,{required this.initialUrl});

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Gateway'),
      ),
      body: WebView(
        initialUrl: widget.initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
        },
        onPageStarted: (String url) {
          print("Page Url $url");
          if (url.contains(
              "https://admin.daraintravels.in/phonepe/payment/callback/success")) {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentSuccessScreen(widget.planList, widget.index, widget.planBackground, widget.planButtonColor)));
          }else if(url.contains("https://admin.daraintravels.in/phonepe/payment/callback/error")){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentFailureScreen()));
          }else{
            print("Otherwise url = $url");
          }
        },
        navigationDelegate: (request) {
          print("Console URL ${request.url}");
          if (request.url.startsWith(
              "https://mercury-uat.phonepe.com/transact/simulator?token")) {
            print("Payment Success");
          }
          return NavigationDecision.navigate;
        },
        javascriptChannels: <JavascriptChannel>[
          // Create a JavascriptChannel for communication
          JavascriptChannel(
            name: 'paymentChannel',
            onMessageReceived: (JavascriptMessage message) {
              if (message.message == "PaymentSuccessful") {
                // Close the WebView
                _webViewController.evaluateJavascript("window.close();");
                // Navigate to a success screen
                print("Payment Got Success");
              }
            },
          ),
        ].toSet(),
      ),
    );
  }
}
