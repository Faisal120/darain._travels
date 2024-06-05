import 'package:darain_travels/screens/allJobScreen.dart';
import 'package:darain_travels/screens/dashboardScreen.dart';
import 'package:darain_travels/screens/notifications_screen.dart';
import 'package:darain_travels/screens/searchScreen.dart';
import 'package:darain_travels/screens/videosWebView.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget{
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
  }

  void getDeviceInfo()async{
    var deviceInfo = DeviceInfoPlugin();
    var androidDeviceInfo = await deviceInfo.androidInfo;
    print("Device id ${androidDeviceInfo.id}");
  }

  int pageIndex =0;
  final pages =[
    const DashBoardScreen(),
    AllJobsScreen(const [], "", ""),
    SearchScreen(),
    const VideoWebView(),
    NotificationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNav(context),
    );
  }

  Container buildMyNav(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(2,4),
            blurRadius: 10
          )
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
              Icons.home_filled,
              color: mainTheme,
              size: 30,
            )
                : const Icon(
              Icons.home_outlined,
              color: Colors.grey,
              size: 30,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
              Icons.work_rounded,
              color: mainTheme,
              size: 30,
            )
                : const Icon(
              Icons.work_outline_outlined,
              color: Colors.grey,
              size: 30,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            icon: pageIndex == 2
                ? const Icon(
              Icons.search_outlined,
              color: mainTheme,
              size: 30,
            )
                : const Icon(
              Icons.search_rounded,
              color: Colors.grey,
              size: 30,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 3;
              });
            },
            icon: pageIndex == 3
                ? const Icon(
              Icons.video_collection,
              color: mainTheme,
              size: 30,
            )
                : const Icon(
              Icons.video_collection_outlined,
              color: Colors.grey,
              size: 30,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 4;
              });
            },
            icon: pageIndex == 4
                ? const Icon(
              Icons.notifications_active_outlined,
              color: mainTheme,
              size: 30,
            )
                : const Icon(
              Icons.notifications_active,
              color: Colors.grey,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}