import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/functionalities/appFunctionalities.dart';
import 'package:darain_travels/models/jobDetailsModel.dart';
import 'package:darain_travels/screens/jobDetailScreen.dart';
import 'package:darain_travels/screens/notes_history_screen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notes_message_response.dart';

class AppliedJobScreen extends StatefulWidget {
  @override
  State<AppliedJobScreen> createState() => _AppliedJobScreenState();
}

class _AppliedJobScreenState extends State<AppliedJobScreen> {
  JobDetailsModel? _appliedJobList;
  List<JobList> appliedJob = [];
  String? userID;
  bool loading = false, showMessages= false, notesLoading = false;
  NotesMessages? _notesMessages;
  List<Message>? _message;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    BasicConstants.prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
      _getAppliedJobDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : appliedJob.isEmpty
          ? Center(
          child: Text(
            'No Applied Jobs...!',
            style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ))
          : Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ListView.builder(
          itemCount: appliedJob.length,
          itemBuilder: (context, index) {
            return _getJobs(
              context,
              appliedJob[index].title,
              appliedJob[index].catName,
              appliedJob[index].noOfJob,
              appliedJob[index].location,
              appliedJob[index].salary.toString(),
              appliedJob[index].description,
              appliedJob[index].formattedDate,
              index,
              appliedJob[index].img,
              appliedJob[index].appStatusName,
            );
          },
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }

  Widget _getJobs(BuildContext context,
      String title,
      String category,
      int jobType,
      String location,
      String salary,
      String description,
      DateTime formattedDate,
      int index,
      String? img,
      String appStatusName) {
    // final formatCurrency = new NumberFormat.compactCurrency(
    //     locale: "en_US", name: 'Rupee', symbol: '₹ ');
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2,4),
                  blurRadius: 10
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
                    image: NetworkImage(img!),
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
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       left: 8.0, right: 8.0, top: 4),
                      //   child: Text(
                      //     DateFormat('yyyy-MM-dd').format(formattedDate),
                      //     style: GoogleFonts.poppins(fontSize: 12),
                      //   ),
                      // ),
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
                  onTap: () =>
                      AppFunctionalities()
                          .shareItems(context, appliedJob, index),
                ),
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
                              Icons.cases_rounded,
                              size: 18,
                            ),
                          ),
                        ),
                        TextSpan(
                            text: 'No. Of Jobs: $jobType',
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: GFButton(
                        type: GFButtonType.outline2x,
                        shape: GFButtonShape.pills,
                        color: mainTheme,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NotesHistoryScreen(_appliedJobList!.jobs[index].id.toString()),
                                  settings: RouteSettings(
                                      arguments: appliedJob[index])));
                        },
                        child:RichText(
                            text: TextSpan(children: [
                              WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: Icon(
                                    Icons.timelapse,
                                    size: 18,
                                    color: appStatusName == "Rejected"
                                        ? Colors.red
                                        : appStatusName == "Selected"
                                        ? Colors.blue
                                        : appStatusName == "Applied"
                                        ? mainTheme
                                        : Colors.green,
                                  ),
                                ),
                              ),
                              TextSpan(
                                  text: 'Status: $appStatusName',
                                  style: GoogleFonts.poppins(
                                      color: appStatusName == "Rejected"
                                          ? Colors.red
                                          : appStatusName == "Selected"
                                          ? Colors.blue
                                          : appStatusName == "Applied"
                                          ? mainTheme
                                          : Colors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ])),
                      ),
                    ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //
                    //     appliedJob[index].statusNote == ""
                    //         ? SizedBox()
                    //         : Row(
                    //       children: [
                    //         InkWell(
                    //           child: Padding(
                    //             padding: const EdgeInsets.fromLTRB(44, 0, 0, 0),
                    //             child: Text("View Note",
                    //               style: GoogleFonts.poppins(
                    //                 fontSize: 12,
                    //                 fontWeight: FontWeight.w600,
                    //                 color: mainTheme,
                    //                 decoration: TextDecoration.underline,
                    //               ),),
                    //           ),
                    //           onTap: () {
                    //             getNotes(_appliedJobList!.jobs[index].id.toString());
                    //              _showMyDialog(index);
                    //           },
                    //         ),
                    //         appliedJob[index].statusNote != "" ? Container(
                    //           margin: EdgeInsets.symmetric(horizontal: 1),
                    //           height: 10,
                    //           width: 10,
                    //           decoration: BoxDecoration(
                    //               color: Colors.red,
                    //               shape: BoxShape.circle
                    //           ),
                    //         ) : SizedBox()
                    //       ],
                    //     ),
                    //   ],
                    // ),
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
                                  builder: (context) =>
                                      JobDetails(
                                          jobList: appliedJob, index: index),
                                  settings: RouteSettings(
                                      arguments: appliedJob[index])));
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
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // void _showMyDialog(int index) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Note :", style: GoogleFonts.poppins(
  //             fontWeight: FontWeight.w600,
  //             fontSize: 16,
  //             color: Colors.black
  //         ),),
  //         content: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   "${appliedJob[index].statusNote}",
  //                   style: GoogleFonts.poppins(
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w500,
  //                       color: Colors.black,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 16,
  //                 ),
  //                 InkWell(
  //                   child: Text(
  //                     showMessages?"Read less":"Read more",
  //                     style: GoogleFonts.poppins(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w600,
  //                         color: mainTheme,
  //                       decoration: TextDecoration.underline,
  //                     ),
  //                   ),
  //                   onTap: (){
  //                     setState(() {
  //                       showMessages = !showMessages;
  //                     });
  //                   },
  //                 ),
  //                 showMessages ? SizedBox(
  //                   width: MediaQuery.of(context).size.width,
  //                   height: MediaQuery.of(context).size.height/2,
  //                   child: ListView.builder(
  //                       itemCount: _message!.length,
  //                       physics: const BouncingScrollPhysics(),
  //                       scrollDirection: Axis.vertical,
  //                       itemBuilder: (context, index){
  //                     return Expanded(
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(vertical: 8.0),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               "${_notesMessages!.messages![index].id}.  ",
  //                               style: GoogleFonts.poppins(
  //                                 fontSize: 14,
  //                                 fontWeight: FontWeight.w500,
  //                                 color: Colors.black,
  //                               ),
  //                             ),
  //                             Expanded(
  //                               child: Text(
  //                                 "${_notesMessages!.messages![index].mess}",
  //                                 style: GoogleFonts.poppins(
  //                                   fontSize: 14,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: Colors.black,
  //                                 ),
  //                               ),
  //                             ),
  //                             Text(
  //                               DateFormat("jm").format(_notesMessages!.messages![index].createdAt!),
  //                               style: GoogleFonts.poppins(
  //                                 fontSize: 14,
  //                                 fontWeight: FontWeight.w500,
  //                                 color: Colors.black,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   }),
  //                 ):const SizedBox(),
  //               ],
  //             )),
  //
  //         actions: <Widget>[
  //           Center(
  //             child: TextButton(
  //               child: Text(
  //                 "Close",
  //                 style: GoogleFonts.poppins(
  //                     fontWeight: FontWeight.w600,
  //                     fontSize: 16,
  //                     color: Colors.red
  //                 ),
  //               ),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _getAppliedJobDetails() async {
    loading = true;
    _appliedJobList = (await ApiService().appliedJobList(context, userID!));
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {}));
    if (_appliedJobList!.statusCode == 200) {
      appliedJob = _appliedJobList!.jobs;
      loading = false;
      print('applied job list: $appliedJob');
    } else {
      GFToast.showToast('Error: ${_appliedJobList!.statusCode}', context,
          toastPosition: GFToastPosition.BOTTOM);
      loading = false;
    }
  }
}
