
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/app_bar.dart';

class VideoWebView extends StatefulWidget{
  const VideoWebView({super.key});

  @override
  State<VideoWebView> createState() => _VideoWebViewState();
}

class _VideoWebViewState extends State<VideoWebView> {
  late WebViewController webController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: const Text(''),
        backButton: true,
      ),
      body: Center(
        child:  WebView(
          initialUrl: "https://www.youtube.com/@DarainTravels/videos",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            webController = webViewController;
          },
    navigationDelegate: (NavigationRequest request) {
    if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          javascriptChannels: <JavascriptChannel>[
            // Create a JavascriptChannel for communication
            JavascriptChannel(
              name: 'paymentChannel',
              onMessageReceived: (JavascriptMessage message) {
              },
            ),
          ].toSet(),
        ),
      ),
    );
  }

  // WebViewController controller = WebViewController()
  // ..setJavaScriptMode(JavaScriptMode.unrestricted)
  // ..setBackgroundColor(const Color(0x00000000))
  // ..setNavigationDelegate(
  // NavigationDelegate(
  // onProgress: (int progress) {
  // // Update loading bar.
  //   const Center(child: CircularProgressIndicator());
  // },
  // onPageStarted: (String url) {},
  // onPageFinished: (String url) {},
  // onWebResourceError: (WebResourceError error) {},
  // onNavigationRequest: (NavigationRequest request) {
  // if (request.url.startsWith('https://www.youtube.com/')) {
  // return NavigationDecision.prevent;
  // }
  // return NavigationDecision.navigate;
  // },
  // ),
  // )
  // ..loadRequest(Uri.parse('https://www.youtube.com/@DarainTravels/videos'));
}