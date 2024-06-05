// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/functionalities/appFunctionalities.dart';
import 'package:darain_travels/models/banner_response.dart';
import 'package:darain_travels/models/dashboard_response.dart';
import 'package:darain_travels/models/employer_response.dart';
import 'package:darain_travels/models/getFeaturedCountry.dart';
import 'package:darain_travels/models/getProfile.dart';
import 'package:darain_travels/screens/allJobScreen.dart';
import 'package:darain_travels/screens/feature_country_job_screen.dart';
import 'package:darain_travels/screens/jobDetailScreen.dart';
import 'package:darain_travels/screens/selectJobsScreen.dart';
import 'package:darain_travels/screens/subscripptionScreen.dart';
import 'package:darain_travels/screens/top_employers_screen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:darain_travels/widgets/app_bar.dart';
import 'package:darain_travels/widgets/scrolling_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apiServices/basicConstants.dart';
import '../models/jobDetailsModel.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {

  JobDetailsModel? _jobDetails;
  JobDetailsModel? _top5jobDetails;
  DashboardResponse? _dashboardResponse;
  GetProfile? getProfile;
  List<String> categories = [];
  UserProfileCard? profileCard;
  List<JobList> jobList = [];
  List<JobList> top5JobList = [];
  List<JobList> sorted5JobList = [];
  bool loading = false;
  bool featuredLoading = false;
  String? userID, imageUrl, cv, idProof, passport, visa, pan;
  String newsStatus = "No latest News yet...";

  DateTime? currentBackPressedTime;
  int? carouselIndex = 0;


  List<BannersData>? banners;
  List<JobData>? recentJob;
  List<Update>? update;
  List<JobData>? featureJob;
  List<FeatureEmployer>? featureEmployer;
  List<FeatureCountry>? featureCountry;
  bool isPremiumUser = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      BasicConstants.prefs = sp;
      userID = sp.getString(BasicConstants.USER_ID);
      if (userID != null) {
        _getDashboardData(userID!);
        _getUserProfile(userID!);
        _getJobDetails(userID!);
      }
      setState(() {});
    });
  }

  // void _getEmployer()async{
  //   setState(() {
  //     loading = true;
  //   });
  //   _employerResponse = await ApiService().getEmployer();
  //   if(_employerResponse!.statusCode==200){
  //     setState(() {
  //       _employerList = _employerResponse!.data;
  //       loading = false;
  //     });
  //   }
  // }

  // void _getFeaturedCountry()async{
  //   setState(() {
  //     loading = true;
  //   });
  //   _featuredCountry = await ApiService().getFeaturedCountries();
  //   if(_employerResponse!.statusCode==200){
  //     setState(() {
  //       _featuredCountryList = _featuredCountry!.data;
  //       loading = false;
  //     });
  //   }
  // }

  void _getUserProfile(String userID) async {
    print('userDashID: $userID');
    getProfile = await (ApiService().getProfile(context, userID));
    profileCard = getProfile?.data;
    categories = getProfile!.cat;

    print('Profile Data: ${profileCard?.cv}');
    imageUrl = profileCard?.profileUrl;
    cv = profileCard?.cv;
    idProof = profileCard?.idProof;
    passport = profileCard?.passport;
    visa = profileCard?.visa;
    pan = profileCard?.panCard;
    setState(() {
      BasicConstants.prefs?.setString(BasicConstants.PASSPORT_URL, passport!);
      // isPremiumUser =
      // BasicConstants.prefs!.getBool(BasicConstants.IS_PREMiUM_USER)!;
      if (getProfile?.data.profileUrl != null) {
        BasicConstants.prefs?.setString(
            BasicConstants.PROFILE_URL, getProfile!.data.profileUrl);
      }
      BasicConstants.prefs
          ?.setString(BasicConstants.USER_NAME, getProfile!.data.name);
      BasicConstants.prefs
          ?.setString(BasicConstants.PLAN_ID, getProfile!.data.plan);
      if(getProfile!.data.plan=="PLN451890394"){
        setState(() {
          BasicConstants.prefs?.setBool(BasicConstants.IS_PREMiUM_USER, false);
          isPremiumUser = false;
        });
      }else{
        setState(() {
          BasicConstants.prefs?.setBool(BasicConstants.IS_PREMiUM_USER, true);
          isPremiumUser= true;
        });
      }
      BasicConstants.prefs?.setStringList(BasicConstants.ALL_CATS, categories);
    });
    print(
        'cv: $cv, idProof; $idProof, passport: $passport, visa: $visa, pan: $pan');
    print('imageUrl: $imageUrl');
    print('Name: ${profileCard?.name}');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillpop(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainTheme,
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
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isPremiumUser? Image.asset("assets/images/verified.png",height: 22, width: 22, fit: BoxFit.fill,):const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      '${profileCard?.name}',
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
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GFCarousel(
                        height: 200,
                        items: _dashboardResponse!.banners!.map(
                          (e) {
                            return GestureDetector(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0)),
                                    child: Image.network("${e.filePath}",
                                        width: MediaQuery.of(context).size.width,
                                        fit: BoxFit.fill),
                                  ),
                                ),
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> const SubscriptionDetails()));
                              },
                            );
                          },
                        ).toList(),
                        onPageChanged: (index) {
                          setState(() {
                            index;
                          });
                        },
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 2),
                        hasPagination: true,
                        activeIndicator: mainTheme,
                        passiveIndicator: Colors.white,
                        passiveDotBorder: Border.all(color: mainTheme, width: 1),
                        enlargeMainPage: true,
                        pagerSize: 10,
                      ),
                      Container(
                        height: 60,
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade500,
                                  offset: const Offset(3, 4),
                                  blurRadius: 12)
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Latest",
                                        style: GoogleFonts.poppins(
                                          color: mainTheme,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Image.asset(
                                          "assets/images/speaker_icon.png"),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    "Update",
                                    style: GoogleFonts.poppins(
                                      color: mainTheme,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              width: 1,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Marquee(
                                  text: "$newsStatus  |",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  scrollAxis: Axis.horizontal,
                                  //scroll direction
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  velocity: 30.0,
                                  //speed
                                  pauseAfterRound: const Duration(seconds: 1),
                                  startPadding: 10.0,
                                  blankSpace: 10,

                                  accelerationDuration:
                                      const Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration:
                                      const Duration(milliseconds: 500),
                                  decelerationCurve: Curves.easeOut,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Recent Jobs",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            InkWell(
                              child: Text(
                                "See all",
                                style: GoogleFonts.poppins(
                                  color: mainTheme,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllJobsScreen(const [], "", "")));
                              },
                            ),
                          ],
                        ),
                      ),
                      loading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : GFCarousel(
                              height: 360,
                              items: sorted5JobList.map(
                                (joblist) {
                                  return InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.shade700,
                                                  offset: const Offset(3, 5),
                                                  blurRadius: 8)
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5.0)),
                                          child: Image.network(joblist.jobImg,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => JobDetails(
                                                  jobList: sorted5JobList,
                                                  index: carouselIndex!)));
                                    },
                                  );
                                },
                              ).toList(),
                              onPageChanged: (index) {
                                setState(() {
                                  carouselIndex = index;
                                  print("index $carouselIndex");
                                });
                              },
                              // autoPlay: true,
                              // autoPlayInterval: const Duration(seconds: 2),
                              // hasPagination: true,
                              // activeIndicator: mainTheme,
                              enlargeMainPage: true,
                            ),
                      // Container(
                      //   height: MediaQuery.of(context).size.height * 0.38,
                      //   margin: const EdgeInsets.all(8),
                      //   child: GridView.builder(
                      //       itemCount: iconSvg.length,
                      //       physics: const ScrollPhysics(),
                      //       gridDelegate:
                      //           const SliverGridDelegateWithFixedCrossAxisCount(
                      //         crossAxisCount: 3,
                      //         childAspectRatio: 0.80,
                      //       ),
                      //       itemBuilder: (context, index) {
                      //         return InkWell(
                      //           child: Column(
                      //             children: [
                      //               Container(
                      //                 decoration: BoxDecoration(
                      //                     color: bgColors[index],
                      //                     borderRadius: BorderRadius.circular(10)),
                      //                 height: 90,
                      //                 width: 90,
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.all(16.0),
                      //                   child: SvgPicture.asset(iconSvg[index]),
                      //                 ),
                      //               ),
                      //               Container(
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.all(8.0),
                      //                   child: Text(
                      //                     textAlign: TextAlign.center,
                      //                     iconText[index],
                      //                     style: const TextStyle(
                      //                         color: Colors.black,
                      //                         fontSize: 12,
                      //                         fontWeight: FontWeight.bold),
                      //                   ),
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //           onTap: () {
                      //             Navigator.push(context,
                      //                 MaterialPageRoute(builder: (context) {
                      //               return _screens[index];
                      //             })).then((value) => setState((){
                      //               _getUserProfile(userID!);
                      //             }));
                      //           },
                      //         );
                      //         // child: SvgPicture.asset('assets/images/jobs.svg', fit: BoxFit.fill),
                      //       }),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Top Employers on Darain",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            InkWell(
                              child: Text(
                                "See all",
                                style: GoogleFonts.poppins(
                                  color: mainTheme,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TopEmployersScreen(
                                                _dashboardResponse!
                                                    .featureEmployer!)));
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: 140,
                          width: MediaQuery.of(context).size.width,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, mainAxisExtent: 180),
                            itemCount:
                                _dashboardResponse!.featureEmployer!.length,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4)),
                                          border: Border.all(
                                              color: Colors.grey, width: 1)),
                                      child: Image.network(
                                          "${_dashboardResponse!.featureEmployer![index].logo}",
                                          height: 50,
                                          width: 150),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Jobs by location",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),

                            // InkWell(
                            //   child: Text(
                            //     "See all",
                            //     style: GoogleFonts.poppins(
                            //       color: mainTheme,
                            //       fontWeight: FontWeight.w600,
                            //       fontSize: 14,
                            //     ),
                            //   ),
                            //   onTap: () {
                            //     // Navigator.push(
                            //     //     context,
                            //     //     MaterialPageRoute(
                            //     //         builder: (context) => TopEmployersScreen()));
                            //   },
                            // ),
                          ],
                        ),
                      ),
                      Container(
                          height: 170,
                          margin: const EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              itemCount:
                                  _dashboardResponse!.featureCountry!.length,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4)),
                                            border: Border.all(
                                                color: Colors.grey, width: 1),
                                          ),
                                          child: Image.network(
                                            "${_dashboardResponse!.featureCountry![index].countryImg}",
                                            height: 80,
                                            width: 100,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "${_dashboardResponse!.featureCountry![index].countryName}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        // Text(
                                        //   "${_dashboardResponse!.featureCountry![index].jobCount} jobs",
                                        //   style: GoogleFonts.poppins(
                                        //     fontSize: 14,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FeaturedCountryJobs(
                                                    _dashboardResponse!
                                                        .featureCountry![index]
                                                        .id,
                                                    userID,
                                                    "")));
                                  },
                                );
                              })),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Featured Jobs",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            InkWell(
                              child: Text(
                                "See all",
                                style: GoogleFonts.poppins(
                                  color: mainTheme,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllJobsScreen(const [], "", "")));
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      jobList.isEmpty
                          ? Center(
                              child: Text(
                                "No Featured Jobs...",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : featuredLoading
                              ? const CircularProgressIndicator()
                              : ListView.builder(
                                  itemCount: jobList.length,
                                  itemBuilder: (context, index) {
                                    return _getJobs(
                                        context,
                                        jobList[index].title,
                                        jobList[index].catName,
                                        jobList[index].jobType,
                                        jobList[index].location,
                                        jobList[index].salary.toString(),
                                        jobList[index].description,
                                        jobList[index].createdAt,
                                        index,
                                        jobList[index].img);
                                  },
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _getJobs(
      BuildContext context,
      String title,
      String category,
      String jobType,
      String location,
      String salary,
      String description,
      DateTime formattedDate,
      int index,
      String img) {
    // final formatCurrency = new NumberFormat.compactCurrency(
    //     locale: "en_US", name: 'Rupee', symbol: '₹ ');
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(2, 4),
                blurRadius: 10,
              )
            ],
            border: Border.all(color: grey, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    image: NetworkImage(img),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          title,
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                            color: grey,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Text(
                            location,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4),
                        child: Text(
                          '${DateFormat('yyyy-MM-dd').format(formattedDate)}',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GFAvatar(
                        shape: GFAvatarShape.circle,
                        size: 15,
                        child: SvgPicture.asset('assets/images/shareBg.svg'),
                      ),
                    ),
                    onTap: () => AppFunctionalities()
                        .shareItems(context, jobList, index)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                  child: RichText(
                      text: TextSpan(children: [
                    const WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: Icon(
                          Icons.desktop_mac_rounded,
                          size: 18,
                        ),
                      ),
                    ),
                    TextSpan(
                        text: jobType,
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 12))
                  ])),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                  child: RichText(
                      text: TextSpan(children: [
                    const WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: Icon(
                          Icons.format_list_bulleted_outlined,
                          size: 18,
                        ),
                      ),
                    ),
                    TextSpan(
                        text: 'Categories: $category',
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 12))
                  ])),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                        child: RichText(
                            text: TextSpan(children: [
                          const WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                              child: Icon(
                                Icons.attach_money_rounded,
                                size: 18,
                              ),
                            ),
                          ),
                          TextSpan(
                              text: 'Salary Scale: $salary',
                              style: GoogleFonts.poppins(
                                  color: Colors.black, fontSize: 12))
                        ])),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GFButton(
                        type: GFButtonType.outline2x,
                        shape: GFButtonShape.pills,
                        color: mainTheme,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JobDetails(
                                      jobList: jobList, index: index)));
                        },
                        child: Row(
                          children: [
                            Text(
                              "Job Details",
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: mainTheme),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Icon(Icons.arrow_forward_ios_rounded,
                                  color: mainTheme, size: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _getJobDetails(String userID) async {
    setState(() {
      featuredLoading = true;
    });
    BasicConstants.prefs = await SharedPreferences.getInstance();
    _jobDetails = (await ApiService().getFeaturedJob(context, userID));
    print('Featured Jobs Count ${_jobDetails?.count}');
    if (_jobDetails!.count > 0) {
      jobList = _jobDetails!.jobs;
      print('Featured Jobs: ${jobList[0].catName}');
      setState(() {
        featuredLoading = false;
      });
    } else {
      GFToast.showToast('Error: ${_jobDetails!.statusCode}', context,
          toastPosition: GFToastPosition.BOTTOM);
      setState(() {
        featuredLoading = false;
      });
    }
  }

  void _getDashboardData(String userID) async {
    setState(() {
      loading = true;
    });
    BasicConstants.prefs = await SharedPreferences.getInstance();
    _dashboardResponse = await ApiService().getDashboardData(context, userID);
    // print('Dashboard Data Code ${_dashboardResponse!.statusCode}');
    if (_dashboardResponse != null) {
      setState(() {
        newsStatus = _dashboardResponse!.update![0].desc!;
        // jobList = _dashboardResponse!.featureJob;
        _getRecentJobs(userID);
        loading = false;
      });
    } else {
      GFToast.showToast('Error: ${_dashboardResponse}', context, toastPosition: GFToastPosition.BOTTOM);
      setState(() {
        loading = false;
      });
    }
  }

  void _getRecentJobs(String userID) async {
    // setState(() {
    //   loading = true;
    // });
    List<String> selectedCats = [];
    _top5jobDetails = (await ApiService()
        .getJobDetails(context, userID, "", selectedCats, "", "", ""));
    setState(() {
      top5JobList = _top5jobDetails!.jobs;
      sorted5JobList = top5JobList.take(5).toList();
      loading = false;
    });
  }

  Future<bool> onWillpop() {
    DateTime now = DateTime.now();
    if (currentBackPressedTime == null ||
        now.difference(currentBackPressedTime!) > const Duration(seconds: 2)) {
      currentBackPressedTime = now;
      GFToast.showToast('Press again to exit!', context, toastPosition: GFToastPosition.BOTTOM);
      return Future.value(false);
    }
    // FlutterExitApp.exitApp(iosForceExit: true);
    return Future.value(true);
  }
}
