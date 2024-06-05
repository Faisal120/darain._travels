// ignore_for_file: use_build_context_synchronously

import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/save_job_model.dart';
import 'package:darain_travels/screens/confirmApplyScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../functionalities/appFunctionalities.dart';
import '../models/jobDetailsModel.dart';
import '../utils/myColors.dart';
import '../widgets/app_bar.dart';

class JobDetails extends StatefulWidget {
  List<JobList> jobList = [];
  int index;

  JobDetails({super.key, required this.jobList, required this.index});

  @override
  State<JobDetails> createState() {
    return _JobDetailsState();
  }
}

class _JobDetailsState extends State<JobDetails> {
  String? userId;
  SaveJob? _saveJob;
  bool loading = false;
  bool applyLoading = false;
  String? isApplied, isSaved;

  @override
  void initState() {
    super.initState();
    isApplied = widget.jobList[widget.index].applied;
    isSaved = widget.jobList[widget.index].saved;
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      BasicConstants.prefs = sp;
      userId = sp.getString(BasicConstants.USER_ID);
    });
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                decoration: BoxDecoration(
                    border: Border.all(color: grey, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.jobList[widget.index].title,
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                              maxLines: 4,
                            ),
                          ),
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GFAvatar(
                              shape: GFAvatarShape.circle,
                              size: 15,
                              child:
                                  SvgPicture.asset('assets/images/shareBg.svg'),
                            ),
                          ),
                          onTap: () => AppFunctionalities().shareItems(
                              context, widget.jobList, widget.index),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          GFAvatar(
                            backgroundImage:
                                NetworkImage(widget.jobList[widget.index].img),
                            size: 45,
                            shape: GFAvatarShape.standard,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.jobList[widget.index].location,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    )),
                                Row(
                                  children: [
                                    RichText(
                                        text: TextSpan(children: [
                                      const WidgetSpan(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 4, 0),
                                          child: Icon(
                                            Icons.history,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                          text:
                                              DateFormat('yyyy-MM-dd').format(widget.jobList[widget.index].formattedDate),
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 11))
                                    ])),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
                            text: widget.jobList[widget.index].jobType,
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
                              Icons.format_list_bulleted_rounded,
                              size: 18,
                            ),
                          ),
                        ),
                        TextSpan(
                            text:
                                'Category: ${widget.jobList[widget.index].catName}',
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
                          text:
                              'Salary Scale: ${widget.jobList[widget.index].salary}',
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 12),
                        )
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
                                  Icons.alarm_on_sharp,
                                  size: 18,
                                ),
                              ),
                            ),
                            TextSpan(
                              text:
                              'Selection Mode: ${widget.jobList[widget.index].selectionMode}',
                              style: GoogleFonts.poppins(
                                  color: Colors.black, fontSize: 12),
                            )
                          ])),
                    ),
                    isApplied == 'applied'?Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                      child: RichText(
                          text: TextSpan(children: [
                            const WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Icon(
                                  Icons.timelapse,
                                  size: 18,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: 'Application Status: ${widget.jobList[widget.index].appStatusName}',
                              style: GoogleFonts.poppins(
                                  color: Colors.black, fontSize: 12),
                            )
                          ])),
                    ):SizedBox(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                              child: applyLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : GFButton(
                                      onPressed: () async {
                                        if (isApplied == 'applied') {
                                          GFToast.showToast(
                                              'Already Applied!', context,
                                              toastPosition: GFToastPosition.BOTTOM);
                                        } else {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ConfirmApplyScreen(widget.jobList, widget.index)));
                                        }
                                      },
                                      shape: GFButtonShape.pills,
                                      buttonBoxShadow: true,
                                      borderSide: BorderSide(
                                          color: isApplied == 'applied'
                                              ? mainTheme
                                              : Colors.transparent,
                                          width: 1),
                                      color: isApplied == 'applied'
                                          ? Colors.grey.shade200
                                          : mainTheme,
                                      text: isApplied == 'applied'
                                          ? 'Already Applied'
                                          : 'Apply',
                                      textStyle: GoogleFonts.poppins(
                                        color: isApplied == 'applied'
                                            ? mainTheme
                                            : Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: loading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : GFButton(
                                      onPressed: () async {
                                          setState(() {
                                            loading = true;
                                          });
                                          _saveJob = await ApiService().saveJob(
                                              userId!,
                                              widget.jobList[widget.index]
                                                  .jobId,
                                              context);
                                          if (_saveJob?.statusCode == 200) {
                                            GFToast.showToast(
                                                _saveJob!.statusMessage,
                                                context,
                                                toastPosition:
                                                GFToastPosition.BOTTOM);
                                            Navigator.pop(context);
                                            setState(() {
                                              loading = false;
                                            });
                                          } else {
                                            GFToast.showToast(
                                                'Something went galat! ${_saveJob
                                                    ?.statusMessage}',
                                                context,
                                                toastPosition:
                                                GFToastPosition.BOTTOM);
                                            setState(() {
                                              loading = false;
                                            });
                                          }
                                      },
                                      shape: GFButtonShape.pills,
                                      color: Colors.white,
                                      text: isSaved == 'saved'? 'Saved' :'Save',
                                      buttonBoxShadow: true,
                                      borderSide: const BorderSide(
                                        color: mainTheme,
                                        width: 1,
                                      ),
                                      textStyle: GoogleFonts.poppins(
                                        color: mainTheme,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                decoration: BoxDecoration(
                    border: Border.all(color: grey, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Job Description",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        maxLines: 4,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Text(
                        widget.jobList[widget.index].description,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
