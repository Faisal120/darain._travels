import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apiServices/basicConstants.dart';
import '../models/notification_model.dart';
import '../widgets/app_bar.dart';

class NotificationScreen extends StatefulWidget{
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  NotificationModel? _notificationModel;
  List<NotificationList>? _list;
  bool loading = false;
  String userId = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sharedPreferences) {
      userId = (sharedPreferences.getString(BasicConstants.USER_ID))!;
      getNotifications();
    });
  }

  void getNotifications()async{
    setState(() {
      loading = true;
    });
    _notificationModel = await ApiService().getNotifications(userId??"");
    if(_notificationModel!.statusCode==202){
      setState(() {
        _list = _notificationModel!.data;
        loading= false;
      });
    }else if(_notificationModel!.statusCode == 200){
      setState(() {
        _list = [];
        loading= false;
      });
    }else{
      print("Something went wrong! ${_notificationModel?.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: const Text(''),
        backButton: false,
      ),
      body: loading ? const Center(child: CircularProgressIndicator()) :Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child:_list!.isEmpty? Center(
          child: Text("No Notification Found...!", style: GoogleFonts.poppins
            (
            fontSize: 16,
            color: mainTheme,
            fontWeight: FontWeight.bold,
          ),),
        ) : SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
              shrinkWrap: false,
              itemCount: _list!.length,
              scrollDirection: Axis.vertical,
              itemExtent: 102,
              itemBuilder: (context,index){
                return Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal:16, vertical: 8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(2,4),
                        blurRadius: 10,
                      )
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const GFAvatar(
                          backgroundImage: AssetImage("assets/images/logo.jpeg"),
                          size: 35,
                          shape: GFAvatarShape.circle,
                        ),
                        // Icon(Icons.info_outline_rounded, color: mainTheme, size: 45,),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${_list![index].body}", style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.black,
                              ),),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("07:00 PM", style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black,
                              ),)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
          }),
        ),
      ),
    );
  }
}