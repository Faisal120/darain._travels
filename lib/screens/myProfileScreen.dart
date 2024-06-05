import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/getProfile.dart';
import 'package:darain_travels/screens/editProfileScreen.dart';
import 'package:darain_travels/screens/educationScreen.dart';
import 'package:darain_travels/screens/experienceScreen.dart';
import 'package:darain_travels/screens/loginScreen.dart';
import 'package:darain_travels/screens/splashScreen.dart';
import 'package:darain_travels/screens/subscripptionScreen.dart';
import 'package:darain_travels/screens/uploadDocumentScreen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apiServices/apiService.dart';
import '../models/get_state_model.dart';
import '../widgets/app_bar.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  GetProfile? getProfile;
  UserProfileCard? profileCard;
  String? imageUrl;
  bool loading = false;
  GetStateModel? _getStateModel;
  List<AllStateList>? _stateList;

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  void _getUserProfile() async {
    setState(() {
      loading = true;
    });
    var userID = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
    getProfile = await (ApiService().getProfile(context, userID!));
    _getStateModel = await ApiService().getStateList(1);
    if (getProfile?.statusCode == 200) {
      setState(() {
        profileCard = getProfile?.data;
        imageUrl = profileCard?.profileUrl;
        _stateList = _getStateModel!.data;
        BasicConstants.prefs?.setString(BasicConstants.PROFILE_URL, getProfile!.data.profileUrl);
        print('imageUrl: $imageUrl');
        print('Name: ${profileCard?.name}');
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          appBar: AppBar(),
          title: const Text(''),
          backButton: true,
        ),
        body: SingleChildScrollView(
          child: loading ?
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: mainTheme),
                      const SizedBox(
                        height: 16,
                      ),
                      Text("Loading...", style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                      ),)
                    ],
                  ),
                ),
              )
              :Column(
            children: [
              // Container(
              //   margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              //   child: loading
              //       ? GFShimmer(
              //           showGradient: true,
              //           showShimmerEffect: true,
              //           shimmerEffectCount: 1,
              //           gradient: LinearGradient(
              //             begin: Alignment.bottomRight,
              //             end: Alignment.centerLeft,
              //             stops: const <double>[0, 0.3, 0.6, 0.9, 1],
              //             colors: [
              //               mainTheme.withOpacity(0.1),
              //               mainTheme.withOpacity(0.3),
              //               mainTheme.withOpacity(0.5),
              //               mainTheme.withOpacity(0.7),
              //               mainTheme.withOpacity(0.9),
              //             ],
              //           ),
              //           child: ShimmerEffects().viewProfileShimmer(context),
              //         )
              //       : Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             imageUrl == null || imageUrl == "NA"
              //                 ? const GFAvatar(
              //                     backgroundImage:
              //                         AssetImage('assets/images/user.png'),
              //                     shape: GFAvatarShape.circle,
              //                     size: 50,
              //                   )
              //                 : GFAvatar(
              //                     backgroundImage: NetworkImage(imageUrl!),
              //                     shape: GFAvatarShape.circle,
              //                     size: 50,
              //                   ),
              //             Expanded(
              //               child: Container(
              //                 margin: const EdgeInsets.fromLTRB(24, 0, 16, 0),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Text(
              //                       "${getProfile?.data.name}",
              //                       style: GoogleFonts.poppins(
              //                         color: Colors.black,
              //                         fontSize: 16,
              //                         fontWeight: FontWeight.w600,
              //                       ),
              //                     ),
              //                     Text(
              //                       "${getProfile?.data.email}",
              //                       style: GoogleFonts.poppins(
              //                         fontSize: 12,
              //                       ),
              //                     ),
              //                     Text(
              //                       "${getProfile?.data.cCode} ${getProfile?.data.mobile}",
              //                       style: GoogleFonts.poppins(
              //                         color: Colors.black,
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w600,
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             ),
              //             // Column(
              //             //   children: [
              //             //     SvgPicture.asset('assets/images/prem.svg',
              //             //         height: 15),
              //             //     Text(
              //             //       "Upgrade",
              //             //       style: GoogleFonts.poppins(fontSize: 10),
              //             //     )
              //             //   ],
              //             // )
              //           ],
              //         ),
              // ),
              // Container(
              //         width: double.infinity,
              //         height: 45,
              //         margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              //         child: GFButton(
              //           icon: const Icon(Icons.remove_red_eye_outlined,
              //               color: Colors.white),
              //           shape: GFButtonShape.standard,
              //           color: mainTheme,
              //           text: 'Get Profile Card',
              //           textStyle: GoogleFonts.poppins(
              //             fontWeight: FontWeight.w600,
              //           ),
              //           onPressed: () {
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => const ProfileCard()));
              //           },
              //         ),
              //       ),
              const Divider(
                height: 2,
                color: Colors.grey,
              ),
              InkWell(
                child: _listWidget(
                    1,
                    context,
                    const Icon(Icons.person_4_outlined, size: 30),
                    'Personal Information'),
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile(getProfile!, _stateList!)))
                      .then((value) => _getUserProfile());
                },
              ),
              const Divider(
                height: 2,
                color: Colors.grey,
              ),
              InkWell(
                child: _listWidget(1, context,
                    const Icon(Icons.menu_book_rounded, size: 30), 'Education'),
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EducationScreen(getProfile!)))
                      .then((value) => _getUserProfile());
                },
              ),
              const Divider(
                height: 2,
                color: Colors.grey,
              ),
              InkWell(
                child: _listWidget(
                    1,
                    context,
                    const Icon(Icons.work_outline_rounded, size: 30),
                    'Work Experience'),
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ExperienceScreen(getProfile!)))
                      .then((value) => _getUserProfile());
                  ;
                },
              ),
              const Divider(
                height: 2,
                color: Colors.grey,
              ),
              InkWell(
                child: _listWidget(
                    1,
                    context,
                    const Icon(Icons.contact_page_sharp, size: 30),
                    'Documents Upload'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadDocuments()));
                },
              ),
              const Divider(
                height: 2,
                color: Colors.grey,
              ),
              InkWell(
                child: _listWidget(1, context,
                    const Icon(Icons.logout_rounded, size: 30), 'Log out'),
                onTap: () {
                  showCupertinoActionSheet(context);
                },
              ),
              const Divider(
                height: 2,
                color: Colors.grey,
              ),
              InkWell(
                child: Container(
                  color: const Color(0xffFFFBF3),
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16.0, 8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset('assets/images/prem.svg'),
                        Text(
                          'Upgrade to Premium',
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const Icon(
                          Icons.chevron_right_outlined,
                          color: mainTheme,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SubscriptionDetails()));
                },
              ),
              const Divider(
                height: 2,
                color: Colors.grey,
              ),
            ],
          ),
        ));
  }
}

Future showCupertinoActionSheet(BuildContext context) =>
    showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return CupertinoTheme(
            data: const CupertinoThemeData(
                textTheme: CupertinoTextThemeData(primaryColor: Colors.white)),
            child: CupertinoActionSheet(
              title: Text(
                "Are you sure want to Logout?",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14),
                textAlign: TextAlign.center,
              ),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () async {
                    var prefs = await SharedPreferences.getInstance();
                    prefs.setBool(SplashScreenState.LOGGED_IN, false);
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (Route route) => false);
                  },
                  child: Text(
                    "Yes",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "No",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          );
        });

Widget _listWidget(
    int index, BuildContext context, Icon prefixIcon, String title) {
  return Container(
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
    height: 80,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        prefixIcon,
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const Icon(
          Icons.add_circle_outline,
          color: mainTheme,
          size: 30,
        )
      ],
    ),
  );
}
