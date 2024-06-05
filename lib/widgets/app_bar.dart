import 'package:darain_travels/screens/dashboardScreen.dart';
import 'package:darain_travels/screens/selectJobsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apiServices/basicConstants.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final Text title;
  final bool backButton;

  const CustomAppBar(
      {super.key,
      required this.appBar,
      required this.title,
      required this.backButton});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height * 1.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String? userName, imageUrl, planId;
  bool isPremiumUser = false;

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  void initializeData() async {
    BasicConstants.prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = BasicConstants.prefs?.getString(BasicConstants.USER_NAME);
      imageUrl = BasicConstants.prefs?.getString(BasicConstants.PROFILE_URL);
      planId = BasicConstants.prefs?.getString(BasicConstants.PLAN_ID);
      isPremiumUser = BasicConstants.prefs!.getBool(BasicConstants.IS_PREMiUM_USER)!;
      print('imageUr: $imageUrl, $planId, $isPremiumUser');
    });
    debugPrint('username: $userName');
  }

  @override
  SafeArea build(BuildContext context) {
    return SafeArea(
        child: AppBar(
      toolbarHeight: 120,
      flexibleSpace: SvgPicture.asset('assets/images/appbar.svg', fit: BoxFit.cover),
      title: InkWell(
        child: Text(
          "Darain Travels",
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        onTap: () {
          Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => const DashBoardScreen()), (route) => false,);
        },
      ),
      automaticallyImplyLeading: widget.backButton ? true : false,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              isPremiumUser? Image.asset("assets/images/verified.png",height: 30, width: 30, fit: BoxFit.fill,):const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  '$userName',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              InkWell(
                child: imageUrl == null || imageUrl == "NA"
                    ? const GFAvatar(
                      backgroundImage:
                          AssetImage('assets/images/user.png'),
                      shape: GFAvatarShape.circle,
                      size: 25,
                      backgroundColor: Colors.green,
                    )
                    : GFAvatar(
                      backgroundImage: NetworkImage(imageUrl!),
                      shape: GFAvatarShape.circle,
                      size: 25,
                      backgroundColor: Colors.green,
                    ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectJobsScreen()));
                },
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
