// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/apply_job_model.dart';
import 'package:darain_travels/models/getProfile.dart';
import 'package:darain_travels/models/jobDetailsModel.dart';
import 'package:darain_travels/screens/allJobScreen.dart';
import 'package:darain_travels/screens/subscripptionScreen.dart';
import 'package:darain_travels/screens/uploadDocumentScreen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:darain_travels/widgets/shimmer_effects.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmApplyScreen extends StatefulWidget {
  List<JobList> jobList;
  int index = 0;

  ConfirmApplyScreen(this.jobList, this.index, {super.key});

  @override
  State<ConfirmApplyScreen> createState() => _ConfirmApplyScreenState();
}

class _ConfirmApplyScreenState extends State<ConfirmApplyScreen> {
  late TextEditingController _noteController,
      _emailController,
      _mobileController;
  String? userID, passport;
  GetProfile? getProfile;
  UserProfileCard? profileCard;
  ApplyJob? _applyJob;
  bool applyLoading = false, loading = false, validated = false;
  String? name,
      email,
      mobile,
      gender,
      nationality,
      state,
      overseaWork,
      indianWork,
      imageUrl,
      errorText;

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  void _getUserProfile() async {
    loading = true;
    userID = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
    getProfile = await (ApiService().getProfile(context, userID!));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    profileCard = getProfile?.data;
    setState(() {
      initializeUserData();
      loading = false;
    });
    print('Name: ${profileCard?.name}');
  }

  void initializeUserData() {
    gender = getProfile?.data.gender;
    name = getProfile?.data.name;
    print('name : $name');
    email = getProfile?.data.email;
    mobile = getProfile?.data.mobile;
    nationality = getProfile?.data.nationality;
    overseaWork = getProfile?.data.overseasExp.toString();
    indianWork = getProfile?.data.indianExp.toString();
    imageUrl = getProfile?.data.profileUrl;
    passport = getProfile?.data.passport;
    _noteController = TextEditingController();
    _emailController = TextEditingController(text: getProfile?.data.email);
    _mobileController = TextEditingController(text: getProfile?.data.mobile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text(
          "Confirm & Apply",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.125,
                  child: Stack(
                    children: [
                      Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 16.0, left: 16),
                              child: Text("Contact Info. (संपर्क जानकारी)",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: mainTheme,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                            child: getProfile?.data == null
                                ? GFShimmer(
                                    showGradient: true,
                                    showShimmerEffect: true,
                                    shimmerEffectCount: 1,
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomRight,
                                      end: Alignment.centerLeft,
                                      stops: const <double>[
                                        0,
                                        0.3,
                                        0.6,
                                        0.9,
                                        1
                                      ],
                                      colors: [
                                        mainTheme.withOpacity(0.1),
                                        mainTheme.withOpacity(0.3),
                                        mainTheme.withOpacity(0.5),
                                        mainTheme.withOpacity(0.7),
                                        mainTheme.withOpacity(0.9),
                                      ],
                                    ),
                                    child: ShimmerEffects()
                                        .viewProfileShimmer(context),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      imageUrl == null || imageUrl == "NA"
                                          ? const GFAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/images/user.png'),
                                              shape: GFAvatarShape.circle,
                                              size: 40,
                                            )
                                          : GFAvatar(
                                              backgroundImage:
                                                  NetworkImage(imageUrl!),
                                              shape: GFAvatarShape.circle,
                                              size: 40,
                                            ),
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              16, 0, 16, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${getProfile?.data.name}",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                "${getProfile?.data.qualification}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 16.0, left: 16),
                              child: Text("Email (ईमेल)*",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: mainTheme,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                                textAlignVertical: TextAlignVertical.bottom,
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                  enabled: false,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: mainTheme, width: 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      borderSide: BorderSide(
                                          color: mainTheme, width: 1)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1)),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 16.0, left: 16),
                              child: Text("Mobile (मोबाईल न0)*",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: mainTheme,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),

                          SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                textAlignVertical: TextAlignVertical.center,
                                controller: _mobileController,
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                                decoration: const InputDecoration(
                                  hintText: "Mobile No.",
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                  enabled: false,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: mainTheme, width: 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 1)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1)),
                                ),
                              ),
                            ),
                          ),

                          Container(
                            height: 120,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: DottedBorder(
                              radius: const Radius.circular(8),
                              color: grey,
                              borderType: BorderType.RRect,
                              strokeWidth: 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 80,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: const GFAvatar(
                                      backgroundImage:
                                          AssetImage('assets/images/cv.png'),
                                      shape: GFAvatarShape.standard,
                                      radius: 15,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          passport == "NA"
                                              ? "No Documents Uploaded"
                                              : "Documents Uploaded!",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          passport == "NA"
                                              ? "Atleast Passport should be uploaded!"
                                              : "Passport Uploaded!",
                                          textAlign: TextAlign.center,
                                          style:
                                              GoogleFonts.poppins(fontSize: 12),
                                        ),
                                        passport == "NA"
                                            ? GFButton(
                                                shape: GFButtonShape.pills,
                                                size: 25,
                                                text: 'Click here to Upload',
                                                icon: const Icon(
                                                    Icons
                                                        .keyboard_double_arrow_right_outlined,
                                                    color: mainTheme),
                                                textStyle: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: mainTheme,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                color: Colors.transparent,
                                                onPressed: () {
                                                  // panCard == "NA" ? uploadEduExp(context) : null;
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const UploadDocuments())).then(
                                                      (value) {
                                                    _getUserProfile();
                                                  });
                                                })
                                            : const SizedBox()
                                      ],
                                    ),
                                  ),

                                  // panCard == "NA" ? const SizedBox() : Column(
                                  //   children: [
                                  //     Expanded(
                                  //       child: InkWell(
                                  //         child: Container(
                                  //           width: 45,
                                  //           margin: const EdgeInsets.symmetric(
                                  //               vertical: 8, horizontal: 8),
                                  //           decoration: BoxDecoration(
                                  //               borderRadius: BorderRadius.circular(8),
                                  //               color:
                                  //               panCard != null ? mainTheme.shade100 : grey[100],
                                  //               border: Border.all(
                                  //                 color: panCard != null ? mainTheme : grey,
                                  //                 width: 1,
                                  //               )),
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.all(4.0),
                                  //             child: Container(
                                  //                 decoration: const BoxDecoration(
                                  //                     shape: BoxShape.circle, color: Colors.white),
                                  //                 child: Icon(Icons.remove_red_eye_outlined,
                                  //                     color: panCard != null
                                  //                         ? mainTheme
                                  //                         : Colors.black)),
                                  //           ),
                                  //         ),
                                  //         onTap: () {
                                  //           panCard != null
                                  //               ? Navigator.push(
                                  //               context,
                                  //               MaterialPageRoute(
                                  //                   builder: (context) =>
                                  //                       PDFOpener(_getProfile!.data.panCard!)))
                                  //               : null;
                                  //         },
                                  //       ),
                                  //     ),
                                  //     Expanded(
                                  //       child: InkWell(
                                  //         child: Container(
                                  //           width: 45,
                                  //           margin: const EdgeInsets.symmetric(
                                  //               vertical: 8, horizontal: 8),
                                  //           decoration: BoxDecoration(
                                  //               borderRadius: BorderRadius.circular(8),
                                  //               color:
                                  //               panCard != null ? Colors.red.shade200 : grey[100],
                                  //               border: Border.all(
                                  //                 color: panCard != null ? Colors.red : grey,
                                  //                 width: 1,
                                  //               )),
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.all(4.0),
                                  //             child: Container(
                                  //                 decoration: const BoxDecoration(
                                  //                     shape: BoxShape.circle, color: Colors.white),
                                  //                 child: Icon(Icons.delete,
                                  //                     color: panCard != null
                                  //                         ? Colors.red
                                  //                         : Colors.black)),
                                  //           ),
                                  //         ),
                                  //         onTap: () {
                                  //           panCard != null ? showCupertinoModalPopup(
                                  //               context: context,
                                  //               builder: (context) {
                                  //                 return buildActionSheet(context, 'pan_card',userID!);})
                                  //               : null;
                                  //           // cvResume!= null ? Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFOpener(_getProfile!.data.cv!))): null;
                                  //         },
                                  //       ),
                                  //     ),
                                  //   ],
                                  // )
                                ],
                              ),
                            ),
                          ),

                          // Container(
                          //   width: double.infinity,
                          //   decoration: const BoxDecoration(color: Colors.white),
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(top: 16.0, left: 16),
                          //     child: Text("Additional Information (अतिरिक्त जानकारी)",
                          //         style: GoogleFonts.poppins(fontSize: 14, color: mainTheme, fontWeight: FontWeight.w500)),
                          //   ),
                          // ),
                          // SizedBox(
                          //   width: double.infinity,
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: TextField(
                          //       textAlignVertical: TextAlignVertical.center,
                          //       controller: _noteController,
                          //       maxLines: 10,
                          //       keyboardType: TextInputType.multiline,
                          //       style: GoogleFonts.poppins(
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.w500),
                          //       decoration: InputDecoration(
                          //         hintText: "Cover Letter",
                          //         hintStyle: GoogleFonts.poppins(
                          //             fontSize: 14, fontWeight: FontWeight.w600),
                          //         focusedBorder: const OutlineInputBorder(
                          //             borderRadius: BorderRadius.all(Radius.circular(5)),
                          //             borderSide: BorderSide(color: mainTheme, width: 1)),
                          //         enabledBorder: const OutlineInputBorder(
                          //             borderRadius: BorderRadius.all(Radius.circular(5)),
                          //             borderSide: BorderSide(color: mainTheme, width: 1)),
                          //         disabledBorder: const OutlineInputBorder(
                          //             borderRadius: BorderRadius.all(Radius.circular(5)),
                          //             borderSide: BorderSide(color: Colors.grey, width: 1)),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: applyLoading
                                  ? const CircularProgressIndicator()
                                  : AnimatedContainer(
                                      duration: const Duration(seconds: 1),
                                      width: double.infinity,
                                      height: 45,
                                      alignment: Alignment.center,
                                      decoration:
                                          const BoxDecoration(color: mainTheme),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Confirm & Apply",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )),
                            ),
                            onTap: () {
                              // setState(() {
                              //   _noteController.text.isEmpty ? validated = true: validated = false;
                              //   validated ? errorText = 'Field is mandatory !': null;
                              // });
                              if (passport == null || passport == "NA") {
                                GFToast.showToast(
                                    "Please Upload your passport First!",
                                    context,
                                    toastPosition: GFToastPosition.BOTTOM);
                              } else {
                                applyForJob(
                                    context, _noteController.text.toString());
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void applyForJob(BuildContext context, String notes) async {
    setState(() {
      applyLoading = true;
    });
    _applyJob = await ApiService()
        .applyJob(userID!, widget.jobList[widget.index].jobId, context, notes);
    if (_applyJob?.statusCode == 200) {
      GFToast.showToast('Applied Successfully!', context,
          toastPosition: GFToastPosition.BOTTOM);
      setState(() {
        applyLoading = false;
        BasicConstants.prefs!.setBool(BasicConstants.ALREADY_APPLIED, true);
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AllJobsScreen(const [], "", "")));
    } else if (_applyJob?.statusCode == 403) {
      GFToast.showToast('Already Applied!', context,
          toastPosition: GFToastPosition.BOTTOM);
      print('Already Applied: ${_applyJob?.statusMessage}');
      setState(() {
        applyLoading = false;
        BasicConstants.prefs!.setBool(BasicConstants.ALREADY_APPLIED, true);
      });
    } else if (_applyJob?.statusCode == 402) {
      GFToast.showToast(
          'You\'re not eligible to apply, Please upgrade your plan!', context,
          toastPosition: GFToastPosition.BOTTOM);
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => const SubscriptionDetails()));
      setState(() {
        applyLoading = false;
      });
    } else {
      GFToast.showToast('${_applyJob?.statusMessage}', context,
          toastPosition: GFToastPosition.BOTTOM);
      setState(() {
        applyLoading = false;
      });
    }
  }
}
