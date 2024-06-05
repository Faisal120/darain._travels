import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/functionalities/appFunctionalities.dart';
import 'package:darain_travels/models/allCategories.dart';
import 'package:darain_travels/models/jobDetailsModel.dart';
import 'package:darain_travels/screens/choose_filter_screen.dart';
import 'package:darain_travels/screens/jobDetailScreen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class AllJobs extends StatefulWidget {
  List<String> selectedCats;
  String countryId, stateId;
  AllJobs(this.selectedCats, this.countryId, this.stateId, {super.key});

  @override
  State<AllJobs> createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> {
  List<JobList> jobList = [];
  List<JobList> filteredJobList = [];
  JobDetailsModel? _jobDetails;
  String? userID;
  String defCat = "Category";
  String defCountry = "Location";
  bool loading = false;
  List<Datum> categoryList = [];
  List<String> selectedCats =[];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    BasicConstants.prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
      selectedCats = BasicConstants.prefs!.getStringList(BasicConstants.ALL_CATS)!;
      if(widget.selectedCats.isNotEmpty){
        selectedCats = widget.selectedCats;
      }else{
        selectedCats = [];
      }
      _getJobDetails(context, selectedCats);
    });
  }

  @override
  Widget build(BuildContext context) {
    return  loading
        ? const Center(child: CircularProgressIndicator())
        :Scaffold(
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: SingleChildScrollView(
            child: jobList.isEmpty
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
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ListView.builder(
                          itemCount: filteredJobList.isNotEmpty
                              ? filteredJobList.length
                              : jobList.length,
                          itemBuilder: (context, index) {
                            return _getJobs(
                                context,
                                filteredJobList.isNotEmpty
                                    ? filteredJobList[index].title
                                    : jobList[index].title,
                                filteredJobList.isNotEmpty
                                    ? filteredJobList[index].catName
                                    : jobList[index].catName,
                                filteredJobList.isNotEmpty
                                    ? filteredJobList[index].noOfJob
                                    : jobList[index].noOfJob,
                                filteredJobList.isNotEmpty
                                    ? filteredJobList[index].location
                                    : jobList[index].location,
                                filteredJobList.isNotEmpty
                                    ? filteredJobList[index].salary.toString()
                                    : jobList[index].salary.toString(),
                                filteredJobList.isNotEmpty
                                    ? filteredJobList[index].description
                                    : jobList[index].description,
                                filteredJobList.isNotEmpty
                                    ? filteredJobList[index].formattedDate
                                    : jobList[index].formattedDate,
                                index,
                                filteredJobList.isNotEmpty
                                    ? filteredJobList[index].img
                                    : jobList[index].img);
                          },
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                        ),
                      ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16,8,16,48),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 40,
              width: 120,
              margin: const EdgeInsets.only(bottom: 16, right: 8),
              decoration: const BoxDecoration(
                  color: mainTheme,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey,
                     offset: Offset(2,4),
                     blurRadius: 10,
                   )
                 ]
              ),
              child: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_alt_sharp, color: Colors.white,),
                      const SizedBox(
                        width: 8,
                      ),
                      Text("Filter", style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> ChooseFilterScreen(selectedCats)),(Route route)=> true);
                },
              ),
            ),
          ),
        ),
      ]),
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
          boxShadow: const [
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
                                      builder: (context) => JobDetails(
                                          jobList: jobList, index: index),
                                      settings: RouteSettings(
                                          arguments: jobList[index])))
                              .then((value) => _getJobDetails(context,selectedCats));
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

  void _getJobDetails(BuildContext context, List<String> selectedCats) async {
    setState(() {
      loading = true;
    });
    _jobDetails = (await ApiService().getJobDetails(context, userID!,"", selectedCats,widget.countryId,widget.stateId,""));
    if (_jobDetails!.statusCode == 202) {
      jobList = _jobDetails!.jobs;
      setState(() {
        loading = false;
      });
    } else {
      // ignore: use_build_context_synchronously
      GFToast.showToast('Error: ${_jobDetails!.jobs}', context,
          toastPosition: GFToastPosition.BOTTOM);
      setState(() {
        loading = false;
      });
    }
  }
}
