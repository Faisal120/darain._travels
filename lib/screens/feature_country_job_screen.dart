import 'package:darain_travels/functionalities/appFunctionalities.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:darain_travels/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apiServices/apiService.dart';
import '../apiServices/basicConstants.dart';
import '../models/jobDetailsModel.dart';
import 'jobDetailScreen.dart';

class FeaturedCountryJobs extends StatefulWidget {
  int? countryID;
  String? userID, selectedDesig;

  FeaturedCountryJobs(this.countryID, this.userID, this.selectedDesig, {super.key});

  @override
  State<FeaturedCountryJobs> createState() => _FeaturedCountryJobsState();
}

class _FeaturedCountryJobsState extends State<FeaturedCountryJobs> {
  bool loading = false;
  JobDetailsModel? _jobDetails;

  List<JobList> jobList = [];

  @override
  void initState() {
    _getJobDetails(widget.userID!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: Text(""),
        backButton: true,
      ),
      body: loading? Center(
        child: CircularProgressIndicator(),
      ) :SingleChildScrollView(
          child: _jobDetails!.count <= 0
              ? Center(
              child: Text(
                'No Jobs Available...!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
            itemCount: jobList.length,
            itemBuilder: (context, index) {
                return _getJobs(
                    context,
                    jobList[index].title,
                    jobList[index].catName,
                    jobList[index].jobType,
                    jobList[index].location!,
                    jobList[index].salary.toString(),
                    jobList[index].description,
                    jobList[index].formattedDate,
                    index,
                    jobList[index].img);
            },
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
          ),
              ),
      ),
    );
  }

  Widget _getJobs(BuildContext context,
      String title,
      String category,
      String jobType,
      String location,
      String salary,
      String description,
      DateTime formattedDate,
      int index,
      String? img) {
    // final formatCurrency = new NumberFormat.compactCurrency(
    //     locale: "en_US", name: 'Rupee', symbol: '₹ ');
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2, 4),
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
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4),
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(formattedDate),
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
                  onTap: () =>
                      AppFunctionalities().shareItems(context, jobList, index),
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
                        buttonBoxShadow: true,
                        color: mainTheme,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      JobDetails(
                                          jobList: jobList, index: index),
                                  settings: RouteSettings(
                                      arguments: jobList[index])))
                              .then((value) => _getJobDetails(widget.userID!));
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
      loading = true;
    });
    _jobDetails = (await ApiService().getJobDetails(
        context, userID, widget.countryID.toString(), [], "", "", widget.selectedDesig!));
    if (_jobDetails!.statusCode == 202) {
      jobList = _jobDetails!.jobs;
      setState(() {
        loading = false;
      });
    }else if(_jobDetails!.count==0){
      setState(() {
        loading = false;
      });
    } else {
      // ignore: use_build_context_synchronously
      GFToast.showToast('Error: ${_jobDetails!.statusCode}', context,
          toastPosition: GFToastPosition.BOTTOM);
      loading = false;
    }
  }
}