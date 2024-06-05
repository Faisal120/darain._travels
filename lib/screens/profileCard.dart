import 'package:android_intent/android_intent.dart';
import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/getProfile.dart';
import 'package:darain_travels/screens/categoryScreen.dart';
import 'package:darain_travels/screens/loginScreen.dart';
import 'package:darain_travels/screens/splashScreen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:darain_travels/widgets/shimmer_effects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  GetProfile? getProfile;
  UserProfileCard? profileCard;
  String? imageUrl, dateOfBirth;
  DateTime? dob;


  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Card",
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(colors: [
                    Color(0xffE2F8FF),
                    Color(0xffD9FFF8),
                    Color(0xffFAFFFE)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  boxShadow: const [BoxShadow(color: grey, blurRadius: 20)]),
              child: getProfile?.data == null
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
                      child: ShimmerEffects().profileCardShimmerEffect(context),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 65,
                              decoration: BoxDecoration(
                                  color: mainTheme,
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(45),
                                      bottomRight: Radius.circular(45),
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  )),
                            ),
                            Container(
                              height: 100,
                              margin: const EdgeInsets.only(left: 32),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child:imageUrl == null || imageUrl=="NA" ? const GFAvatar(
                                        backgroundImage:
                                        AssetImage('assets/images/user.png'),
                                        shape: GFAvatarShape.circle,
                                        size: 50,
                                      ):
                                      GFAvatar(
                                        backgroundImage:
                                        NetworkImage(imageUrl!),
                                        shape: GFAvatarShape.circle,
                                        size: 50,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 16, top: 16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${profileCard?.name}',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '${profileCard?.email}',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 11,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            '${profileCard?.cCode} ${profileCard?.mobile}',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8),
                                    child: RichText(
                                        text: TextSpan(
                                            children: [
                                          const WidgetSpan(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Icon(
                                              Icons.male_rounded,
                                              color: mainTheme,
                                            ),
                                          )),
                                          TextSpan(
                                              text: '${profileCard?.gender}'),
                                        ],
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8),
                                    child: RichText(
                                        text: TextSpan(
                                            children: [
                                          const WidgetSpan(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Icon(
                                              Icons.location_on,
                                              color: mainTheme,
                                            ),
                                          )),
                                          TextSpan(
                                              text:
                                                  '${profileCard?.location}, ${profileCard?.nationality}',
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                              )),
                                        ],
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ))),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: RichText(
                                        text: TextSpan(
                                            children: [
                                          const WidgetSpan(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Icon(
                                              Icons.calendar_today,
                                              color: mainTheme,
                                            ),
                                          )),
                                          TextSpan(text: dateOfBirth),
                                        ],
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ))),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: RichText(
                                        text: TextSpan(
                                            children: [
                                          const WidgetSpan(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Icon(
                                              Icons.history_edu,
                                              color: mainTheme,
                                            ),
                                          )),
                                          TextSpan(
                                              text:
                                                  '${profileCard?.qualification}'),
                                        ],
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ))),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: RichText(
                              text: TextSpan(
                                  children: [
                                const WidgetSpan(
                                    child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(
                                    Icons.shopping_bag,
                                    color: mainTheme,
                                  ),
                                )),
                                TextSpan(
                                    text:
                                        'Indian Experience: ${profileCard?.indianExp}'),
                              ],
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: RichText(
                              text: TextSpan(
                                  children: [
                                const WidgetSpan(
                                    child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(
                                    Icons.shopping_bag,
                                    color: mainTheme,
                                  ),
                                )),
                                TextSpan(
                                    text:
                                        'Overseas Experience: ${profileCard?.overseasExp}'),
                              ],
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ))),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color(0xffD0F9FF),
                                Color(0xffADF0FF)
                              ]),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              border: Border.all(
                                  color: const Color(0xffADF0FF), width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const GFAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/socials.png'),
                                  shape: GFAvatarShape.circle,
                                  size: 30,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child:  Text(
                                          "Check jobs from 1000+ direct company in Gulf.",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child:  Text(
                                            "www.daraintravels.in",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                decoration: TextDecoration.underline,
                                                color: mainTheme),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        onTap: ()async{
                                          AndroidIntent intent = const AndroidIntent(
                                              action: 'action_view',
                                              data: "www.daraintravels.in"
                                          );
                                          await intent.launch();
                                          // final Uri url = Uri.parse('www.daraintravels.in');
                                          // if (!await launchUrl(url)) {
                                          // throw Exception('Could not launch $url');
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            Container(
              width: double.infinity,
              height: 45,
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: GFButton(
                shape: GFButtonShape.standard,
                color: mainTheme,
                text: 'Share Your Card',
                textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
                onPressed: () {
                 print("Share your card");
                },
              ),
            ),
            Container(
              width: double.infinity,
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
                  showCupertinoActionSheet();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future showCupertinoActionSheet() => showCupertinoModalPopup(context: context, builder: (_){
      return CupertinoTheme(
        data: const CupertinoThemeData(
            textTheme: CupertinoTextThemeData(primaryColor: Colors.white)
        ),
        child: CupertinoActionSheet(
          title: Text(
            "Are you sure want to Logout?",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: Colors.black, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                var prefs = await SharedPreferences.getInstance();
                prefs.setBool(SplashScreenState.LOGGED_IN, false);
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route route) => false);
              },
              child: Text(
                "Yes",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, color: Colors.red, fontSize: 14),
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
    // print("Pressed");
    //   AlertDialog(
    //   title: Text('Logout', style: GoogleFonts.poppins(
    //     fontSize: 14,
    //     fontWeight: FontWeight.w600,
    //     color: Colors.red,
    //   ),),
    //   content: Text('Are you sure want to logout?',style: GoogleFonts.poppins(
    //       fontSize: 14,
    //       fontWeight: FontWeight.w500,
    //       color: Colors.black,
    //   ),),
    //   actions: [
    //     GFButton(
    //       onPressed: () {},
    //       child: Text('No',style: GoogleFonts.poppins(
    //           fontSize: 14,
    //           fontWeight: FontWeight.w600,
    //           color: Colors.black,
    //       ),),
    //     ),
    //     GFButton(
    //       onPressed: () {},
    //       child: Text('Yes',style: GoogleFonts.poppins(
    //           fontSize: 14,
    //           fontWeight: FontWeight.w600,
    //           color: Colors.red
    //       ),),
    //     ),
    //   ],
    // );

  void _getUserProfile() async {
    BasicConstants.prefs = await SharedPreferences.getInstance();
    var userID = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
    print('userIddd: $userID');
    getProfile = await (ApiService().getProfile(context, userID!));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    profileCard = getProfile?.data;
    imageUrl = profileCard?.profileUrl;
    dob = profileCard?.dob;
    final DateFormat formatter = DateFormat('yyy/MM/dd');
    dateOfBirth = formatter
        .format(DateTime.parse(dob.toString()));
    print('Dob $dateOfBirth');
    print('imageUrl: $imageUrl');
    print('Name: ${profileCard?.name}');
  }

}
