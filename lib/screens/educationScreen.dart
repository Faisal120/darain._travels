import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/updateProfile.dart';
import 'package:darain_travels/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/getProfile.dart';

class EducationScreen extends StatefulWidget {
  GetProfile? getProfile;

  EducationScreen(this.getProfile, {super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  UpdateProfile? _updateProfile;
  bool editable = false, loading = false;
  String defEducation = 'Education';
  String? education;

  var educationList = [
    'Education',
    'NonSSC',
    'SSC/HSC',
    'Diploma',
    'Graduate',
    'ITI',
    'B.E/B.Tech.',
    'MBA',
    '8th',
    'High School',
    'Intermediate',
  ];

  @override
  void initState() {
    super.initState();
    initializeUserData();
  }

  void initializeUserData() {
    education = widget.getProfile?.data.qualification;
    defEducation = education!;
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
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: DropdownButton(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          isExpanded: true,
                          value: defEducation,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          underline: const SizedBox(),
                          items: educationList.map((String gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (!editable) {
                              return;
                            } else {
                              setState(() {
                                defEducation = newValue!;
                              });
                            }

                          }),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: loading
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        : GFButton(
                      shape: GFButtonShape.standard,
                      color: Colors.green,
                      text: editable ? 'Save' : 'Edit your qualification',
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
                            updateProfile();
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
        ),
      ),
    );
  }

  void updateProfile() async {
    setState(() {
      loading = true;
    });
    var userID = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
    _updateProfile = await ApiService().updateProfile(
        context: context, userID: userID, defEducation: defEducation);
    if (_updateProfile?.statusCode == 200) {
      setState(() {
        editable = false;
        loading = false;
      });
      GFToast.showToast('Qualifications Updated Successfully!', context,
          toastPosition: GFToastPosition.BOTTOM);
    } else {
      GFToast.showToast(
          'Something went Galat! ${_updateProfile?.statusCode}', context,
          toastPosition: GFToastPosition.BOTTOM);
    }
  }
}
