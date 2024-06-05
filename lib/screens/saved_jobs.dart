// ignore_for_file: use_build_context_synchronously

import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/jobDetailsModel.dart';
import 'package:darain_travels/screens/jobDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/save_job_model.dart';
import '../utils/myColors.dart';

class SavedJobs extends StatefulWidget{
  const SavedJobs({super.key});

  @override
  State<SavedJobs> createState() => _SavedJobsState();
}

class _SavedJobsState extends State<SavedJobs> {
  List<JobList> savedJob = [];
  JobDetailsModel? _savedJobList;
  String? userID;
  SaveJob? _saveJob;
  bool loading = false;

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  void initializeData() async {
    BasicConstants.prefs= await SharedPreferences.getInstance();
    setState(() {
      userID = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
      _getSavedJobDetails();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator()) : savedJob.isEmpty? Center(child: Text('No Saved Jobs...!', style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.black
      ),)) : Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ListView.builder(
          itemCount: savedJob.length,
          itemBuilder: (context, index) {
            return _getJobs(
                context,
                savedJob[index].title,
                savedJob[index].catName,
                savedJob[index].noOfJob,
                savedJob[index].location,
                savedJob[index].salary.toString(),
                savedJob[index].description,
                savedJob[index].formattedDate,
                index,
                savedJob[index].img);
          },
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }

  Widget _getJobs(
      BuildContext context,
      String title,
      String category,
      int jobType,
      String location,
      String salary,
      String description,
      DateTime formattedDate,
      int index,
      String? img) {
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
                            color: grey, borderRadius: BorderRadius.circular(10)),
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
                      //   padding:
                      //   const EdgeInsets.only(left: 8.0, right: 8.0, top: 4),
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
                      size: 20,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.delete, size: 20,color: Colors.white,),
                    ),
                  ),
                  onTap: (){
                    deleteJob(userID!, _savedJobList!, index);
                  },
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
                                  text:
                                  'Salary Scale: $salary',
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
                                  builder: (context) =>
                                      JobDetails(jobList: savedJob, index: index),
                                  settings:
                                  RouteSettings(arguments: savedJob[index])));
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

  void _getSavedJobDetails() async {
    setState(() {
      loading = true;
    });
    _savedJobList = (await ApiService().savedJobList(context, userID!));
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {}));
    if (_savedJobList!.statusCode == 200) {
      savedJob = _savedJobList!.jobs;
      setState(() {
        loading = false;
      });
    } else {
      GFToast.showToast('Error: ${_savedJobList!.statusCode}', context, toastPosition: GFToastPosition.BOTTOM);
      setState(() {
        loading = false;
      });
    }
  }

  void deleteJob(String userId, JobDetailsModel jobList, int index)async{
    setState(() {
      loading = true;
    });
    _saveJob = await ApiService().saveJob(
        userId,
        jobList.jobs[index]
            .jobId,
        context);
    if (_saveJob?.statusCode == 200) {
      GFToast.showToast(
          _saveJob!.statusMessage,
          context,
          toastPosition:
          GFToastPosition.BOTTOM);
      _getSavedJobDetails();
    }
    setState(() {
      loading = false;
    });
}
}