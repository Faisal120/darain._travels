import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/updateProfile.dart';
import 'package:darain_travels/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/getProfile.dart';
import '../utils/myColors.dart';

class ExperienceScreen extends StatefulWidget {
  GetProfile? getProfile;

  ExperienceScreen(this.getProfile, {super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  UpdateProfile? _updateProfile;
  bool editable = false, loading = false;
  String? overseaExp, indianExp;
  TextEditingController? overseaController, indianController;

  @override
  void initState() {
    super.initState();
    initializeUserData();
    overseaController = TextEditingController(text: overseaExp);
    indianController = TextEditingController(text: indianExp);
  }

  void initializeUserData() {
    overseaExp = widget.getProfile?.data.overseasExp.toString();
    indianExp = widget.getProfile?.data.indianExp.toString();
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
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16),
                  child: Text("Overseas Work Experience (विदेशी काम का अनुभव)",
                      style:
                          GoogleFonts.poppins(fontSize: 12, color: mainTheme)),
                ),
              ),
              //TF Name
              SizedBox(
                height: 60,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: overseaController,
                    textCapitalization: TextCapitalization.words,
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: "Overseas Work Experience",
                      enabled: editable ? true : false,
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainTheme, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide:
                              BorderSide(color: Colors.green, width: 1)),
                      disabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.grey, width: 1)),
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16),
                  child: Text("Indian Work Experience (भारतीय काम का अनुभव)",
                      style:
                          GoogleFonts.poppins(fontSize: 12, color: mainTheme)),
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
                    textAlignVertical: TextAlignVertical.center,
                    controller: indianController,
                    decoration: InputDecoration(
                      hintText: "10+ Years",
                      hintStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      enabled: editable ? true : false,
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainTheme, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide:
                              BorderSide(color: Colors.green, width: 1)),
                      disabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.grey, width: 1)),
                    ),
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                height: 45,
                margin: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : GFButton(
                        shape: GFButtonShape.standard,
                        color: Colors.green,
                        text: editable ? 'Save' : 'Edit Work Experience',
                        textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                        onPressed: () {
                          setState(() {
                            if (!editable) {
                              editable = true;
                              GFToast.showToast('Editing mode Enabled', context,
                                  toastPosition: GFToastPosition.BOTTOM);
                            } else {
                              updateProfile(overseaController!.text.toString(), indianController!.text.toString());
                            }
                          });
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfileCard()));
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateProfile(String overseaExp, String indianExp) async {
    setState(() {
      loading = true;
      print("Oversea $overseaExp, indianExp $indianExp");
    });
    var userID = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
    _updateProfile = await ApiService().updateProfile(
        context: context,
        userID: userID,
        overseaWorkExpController: overseaExp ,
        indianWorkEpController: indianExp,
    );
    if (_updateProfile?.statusCode == 200) {
      setState(() {
        editable = false;
        loading = false;
      });
      GFToast.showToast('Work Experience Updated Successfully!', context,
          toastPosition: GFToastPosition.BOTTOM);
    } else {
      GFToast.showToast(
          'Something went Galat! ${_updateProfile?.statusCode}', context,
          toastPosition: GFToastPosition.BOTTOM);
    }
  }
}
