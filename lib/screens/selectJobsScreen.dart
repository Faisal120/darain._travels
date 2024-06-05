import 'package:android_intent/android_intent.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/getProfile.dart';
import 'package:darain_travels/screens/allJobScreen.dart';
import 'package:darain_travels/screens/profileCard.dart';
import 'package:darain_travels/screens/subscripptionScreen.dart';
import 'package:darain_travels/screens/supportScreen.dart';
import 'package:darain_travels/screens/uploadDocumentScreen.dart';
import 'package:darain_travels/screens/videosWebView.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../apiServices/apiService.dart';
import '../models/plan_validity_response.dart';
import '../widgets/app_bar.dart';
import '../widgets/shimmer_effects.dart';
import 'dashboardScreen.dart';
import 'jobNews.dart';
import 'myProfileScreen.dart';

class SelectJobsScreen extends StatefulWidget {
  @override
  State<SelectJobsScreen> createState() => _SelectJobsScreenState();
}

class _SelectJobsScreenState extends State<SelectJobsScreen> {
  bool loading = false, isPremiumUser= false, planExpired = false;
  GetProfile? getProfile;
  UserProfileCard? profileCard;
  String? imageUrl;
  PlanValidityRes? _validityRes;
  String? userId;

  var iconSvg = [
    'assets/images/job.svg',
    'assets/images/docus.svg',
    'assets/images/profile.svg',
    'assets/images/supp.svg',
    'assets/images/news.svg',
    'assets/images/video.svg',
  ];

  var iconText = [
    'Jobs',
    'Documents',
    'User Profile',
    'Support',
    'Currency Converter',
    'Videos'
  ];

  var bgColors = [
    const Color(0xffE7F6FF),
    const Color(0xffE7F2FF),
    const Color(0xffFFF5E7),
    const Color(0xffFFEFE7),
    const Color(0xffE7FBFF),
    const Color(0xffE7EFFF),
  ];

  final _screens = [
    AllJobsScreen(const [], "", ""),
    const UploadDocuments(),
    const MyProfile(),
    const SupportScreen(),
    const JobNews(),
    const VideoWebView(),
  ];

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  void _getUserProfile() async {
    setState(() {
      loading = true;
    });
    userId = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
    isPremiumUser = BasicConstants.prefs!.getBool(BasicConstants.IS_PREMiUM_USER)!;
    getProfile = await (ApiService().getProfile(context, userId!));
    if (getProfile?.statusCode == 200) {

      setState(() {
        profileCard = getProfile?.data;
        imageUrl = profileCard?.profileUrl;
        print('imageUrl: $imageUrl');
        print('Name: ${profileCard?.name}');
        if(isPremiumUser){
          getPlannValidity2(userId!);
        }
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainTheme,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: InkWell(
          child: Text(
            "Darain Travels",
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                    builder: (context) => const DashBoardScreen()),
                (route) => false);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: loading
                  ? GFShimmer(
                      showGradient: true,
                      showShimmerEffect: true,
                      shimmerEffectCount: 1,
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.centerLeft,
                        stops: const <double>[0, 0.3, 0.6, 0.9, 1],
                        colors: [
                          mainTheme.withOpacity(0.1),
                          mainTheme.withOpacity(0.3),
                          mainTheme.withOpacity(0.5),
                          mainTheme.withOpacity(0.7),
                          mainTheme.withOpacity(0.9),
                        ],
                      ),
                      child: ShimmerEffects().viewProfileShimmer(context),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        imageUrl == null || imageUrl == "NA"
                            ? const GFAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/user.png'),
                                shape: GFAvatarShape.circle,
                                size: 50,
                              )
                            : GFAvatar(
                                backgroundImage: NetworkImage(imageUrl!),
                                shape: GFAvatarShape.circle,
                                size: 50,
                              ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(24, 0, 16, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${getProfile?.data.name}",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "${getProfile?.data.email}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "${getProfile?.data.cCode} ${getProfile?.data.mobile}",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        isPremiumUser? Column(
                          children: [
                            InkWell(
                              child: Image.asset('assets/images/verified.png',
                                  height: 32, width: 32,fit: BoxFit.fill,),
                              onTap: (){
                                getPlannValidity(userId!);
                              },
                            ),
                            Text(
                              "Premium",
                              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
                            )
                          ],
                        ):SizedBox()
                      ],
                    ),
            ),
            Container(
              width: double.infinity,
              height: 55,
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: GFButton(
                icon: const Icon(Icons.workspace_premium,
                    color: Colors.white),
                shape: GFButtonShape.standard,
                color: isPremiumUser? planExpired? mainTheme : Colors.grey : Colors.grey,
                text: 'Upgrade Premium',
                textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
                onPressed: () {
                 isPremiumUser ? planExpired ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SubscriptionDetails())) : null :
                 Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context) => const SubscriptionDetails()));
                },
              ),
            ),
            const Divider(
              height: 2,
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.38,
              margin: const EdgeInsets.all(8),
              child: GridView.builder(
                  itemCount: iconSvg.length,
                  physics: const ScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.80,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: bgColors[index],
                                borderRadius: BorderRadius.circular(10)),
                            height: 90,
                            width: 90,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SvgPicture.asset(iconSvg[index]),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                textAlign: TextAlign.center,
                                iconText[index],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return _screens[index];
                        })).then((value) => setState(() {
                              _getUserProfile();
                            }));
                      },
                    );
                    // child: SvgPicture.asset('assets/images/jobs.svg', fit: BoxFit.fill),
                  }),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              width: 120,
              height: 45,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: GFButton(
                shape: GFButtonShape.standard,
                color: Colors.red,
                text: 'Logout',
                icon: const Icon(Icons.logout, color: Colors.white,),
                textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
                onPressed: () {
                  showCupertinoActionSheet(context);
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Follow us on Social Media",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Image.asset(
                    "assets/images/whatsapp.png",
                    width: 40,
                    height: 40,
                  ),
                  onTap: () async {
                    AndroidIntent intent = const AndroidIntent(
                        action: 'action_view',
                        data: "https://wa.me/message/R2FV2NE45MKXO1");
                    await intent.launch();
                  },
                ),
                const SizedBox(
                  width: 16,
                ),
                InkWell(
                  child: Image.asset(
                    "assets/images/instagram.png",
                    width: 40,
                    height: 40,
                  ),
                  onTap: () async {
                    AndroidIntent intent = const AndroidIntent(
                        action: 'action_view',
                        data: "https://instagram.com/daraintravelss");
                    await intent.launch();
                  },
                ),
                const SizedBox(
                  width: 16,
                ),
                InkWell(
                  child: Image.asset(
                    "assets/images/youtube.png",
                    width: 40,
                    height: 40,
                  ),
                  onTap: () async {
                    AndroidIntent intent = const AndroidIntent(
                        action: 'action_view',
                        data: "https://www.youtube.com/@DarainTravels/videos");
                    await intent.launch();
                  },
                ),
                const SizedBox(
                  width: 16,
                ),
                InkWell(
                  child: Image.asset(
                    "assets/images/telegram.png",
                    width: 40,
                    height: 40,
                  ),
                  onTap: () async {
                    AndroidIntent intent = const AndroidIntent(
                        action: 'action_view',
                        data: "https://t.me/daraintravels");
                    await intent.launch();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void getPlannValidity( String userID) async {
    setState(() {
      loading = true;
    });
    _validityRes = await ApiService().getPlanValidity(userID);
    if (_validityRes?.statusCode == 202 || _validityRes?.statusCode == 200) {
      setState(() {
        var currentDate = DateTime.now();
        if (currentDate.isAfter(_validityRes!.date!)|| _validityRes!.jobLeft! <= 0) {
          print("Plan got expired");
          planExpired = true;
        } else {
          print("Plan is Valid");
          planExpired = false;
        }
        _showMyDialog();
        loading = false;
      });
    }
  }

  void getPlannValidity2( String userID) async {
    setState(() {
      loading = true;
    });
    _validityRes = await ApiService().getPlanValidity(userID);
    if (_validityRes?.statusCode == 202 || _validityRes?.statusCode == 200) {
      setState(() {
        var currentDate = DateTime.now();
        if (currentDate.isAfter(_validityRes!.date!)|| _validityRes!.jobLeft! <= 0) {
          print("Plan got expired");
          planExpired = true;
        } else {
          print("Plan is Valid");
          planExpired = false;
        }
        loading = false;
      });
    }
  }

  void _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Subscription Details :",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black),
            ),
          ),
          content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  planExpired ? Text(
                    "Your Plan has been Expired!",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ): SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Plan Name:",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        _validityRes!.planName!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Activation Date:",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        DateFormat("dd/MM/yyyy").format(_validityRes!.activeDate!),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      //2024-10-26
                      //2023-10-26 18:45:26
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Valid Till:",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        DateFormat("dd/MM/yyyy").format(_validityRes!.date!),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Jobs:",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        _validityRes!.totalAvJob.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Applied Jobs:",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        _validityRes!.totalApplied.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Jobs Left:",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        _validityRes!.jobLeft.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
      },
    );
  }
}
