import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/screens/categoryScreen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:darain_travels/widgets/date_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/get_state_model.dart';
import '../models/registerUser.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => CreateProfileState();
}

class CreateProfileState extends State<CreateProfile> {
  late TextEditingController _nameController,
      _emailController,
      _dayController,
      _yearController,
      _overseaWorkExpController,
      _indianWorkEpController,
      _date;
  String userID = '';
  var date;
  var Vdate = false;
  GetStateModel? _getStateModel;
  List<AllStateList>? _stateList;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    // initializeData();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _dayController = TextEditingController();
    _yearController = TextEditingController();
    _date = TextEditingController();
    _overseaWorkExpController = TextEditingController();
    _indianWorkEpController = TextEditingController();
  }

  String defGender = 'Select Gender',
      defEducation = 'Education';

  var genderList = [
    'Select Gender',
    'Male',
    'Female',
    'Others',
  ];
  var monthList = [
    'Month',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  // var countryList = [
  //   'Country',
  //   'India',
  // ];
  // var stateList = [
  //   'State',
  //   'Uttar Pradesh',
  //   'Uttarakhand',
  //   'Punjab',
  // ];
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
  RegisterUser? _registerUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text(
          "Create Profile",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
      body: loading
          ? Center(
              child: Dialog(
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: mainTheme),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Loading Data...",
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              color: mainTheme,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    //TV Basic Info
                    Container(
                      // margin: const EdgeInsets.only(top: 16),
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15)),
                          color: grey),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Basic Info (बुनियादी जानकारी)",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: mainTheme,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),

                    //TV Name
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 16),
                        child: Text("Name (नाम)",
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: mainTheme)),
                      ),
                    ),
                    //TF Name
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _nameController,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            hintText: "Name",
                            hintStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: mainTheme, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1)),
                          ),
                        ),
                      ),
                    ),

                    //TV Email
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 16),
                        child: Text("Email (ईमेल)",
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: mainTheme)),
                      ),
                    ),

                    //TF Email
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _emailController,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: mainTheme, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1)),
                          ),
                        ),
                      ),
                    ),

                    //TV Gender
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 16),
                        child: Text("Gender (लिंग)",
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: mainTheme)),
                      ),
                    ),
                    //DD Gender
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: DropdownButton(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                value: defGender,
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                underline: const SizedBox(),
                                items: genderList.map((String gender) {
                                  return DropdownMenuItem(
                                    value: gender,
                                    child: Text(gender),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    defGender = newValue!;
                                  });
                                }),
                          ),
                        ),
                      ),
                    ),

                    //TV DOB
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 16),
                        child: Text("Date of Birth (जन्मतिथि)",
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: mainTheme)),
                      ),
                    ),

                    DateTextField(
                      tController: _date,
                      htext: "MM/DD/YYY",
                      ontap: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now())
                            .then((value) {
                          setState(() {
                            var datevalue = value;
                            date = value;
                            final DateFormat formatter =
                                DateFormat('yyy/MM/dd');
                            date = formatter
                                .format(DateTime.parse(datevalue.toString()));
                            _date.text = date;
                            print(date);
                            // txt.text = date.toString();
                          });
                        });
                      },
                      icon: Icons.calendar_month,
                      isValidate: Vdate,
                      isEditable: true,
                    ),

                    // Container(
                    //   width: double.infinity,
                    //   decoration: const BoxDecoration(color: Colors.white),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 16.0, left: 16),
                    //     child: Text("Nationality",
                    //         style: GoogleFonts.poppins(
                    //             fontSize: 12, color: mainTheme)),
                    //   ),
                    // ),
                    // //DD Country
                    // Container(
                    //   width: double.infinity,
                    //   height: 60,
                    //   decoration: const BoxDecoration(color: Colors.white),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //           border: Border.all(
                    //             color: Colors.grey,
                    //             width: 1.0,
                    //           ),
                    //           borderRadius:
                    //               const BorderRadius.all(Radius.circular(10))),
                    //       child: Padding(
                    //         padding: const EdgeInsets.only(left: 8.0),
                    //         child: DropdownButton(
                    //             isExpanded: true,
                    //             borderRadius: const BorderRadius.only(
                    //                 bottomLeft: Radius.circular(15),
                    //                 bottomRight: Radius.circular(15)),
                    //             value: defCountry,
                    //             icon: const Icon(Icons.keyboard_arrow_down),
                    //             style: GoogleFonts.poppins(
                    //               color: Colors.black,
                    //               fontSize: 14,
                    //             ),
                    //             underline: const SizedBox(),
                    //             items: countryList.map((String gender) {
                    //               return DropdownMenuItem(
                    //                 value: gender,
                    //                 child: Text(gender),
                    //               );
                    //             }).toList(),
                    //             onChanged: (String? newValue) {
                    //               setState(() {
                    //                 defCountry = newValue!;
                    //               });
                    //             }),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    //
                    // //TV State
                    // Container(
                    //   width: double.infinity,
                    //   decoration: const BoxDecoration(color: Colors.white),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 16.0, left: 16),
                    //     child: Text("Location",
                    //         style: GoogleFonts.poppins(
                    //             fontSize: 12, color: mainTheme)),
                    //   ),
                    // ),
                    // //DD State
                    // Container(
                    //   width: double.infinity,
                    //   height: 60,
                    //   decoration: const BoxDecoration(color: Colors.white),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //           border: Border.all(
                    //             color: Colors.grey,
                    //             width: 1.0,
                    //           ),
                    //           borderRadius:
                    //               const BorderRadius.all(Radius.circular(10))),
                    //       child: Padding(
                    //         padding: const EdgeInsets.only(left: 8.0),
                    //         child: DropdownButton(
                    //             borderRadius: const BorderRadius.only(
                    //                 bottomLeft: Radius.circular(15),
                    //                 bottomRight: Radius.circular(15)),
                    //             isExpanded: true,
                    //             hint: Text(defState),
                    //             icon: const Icon(Icons.keyboard_arrow_down),
                    //             style: GoogleFonts.poppins(
                    //               color: Colors.black,
                    //               fontSize: 14,
                    //             ),
                    //             underline: const SizedBox(),
                    //             items: _stateList!.map((state) {
                    //               return DropdownMenuItem(
                    //                 value: state,
                    //                 child: Text(state.state!),
                    //               );
                    //             }).toList(),
                    //             onChanged: (newValue) {
                    //               setState(() {
                    //                 defState = newValue!.state!;
                    //               });
                    //             }),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    //Heading Education
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: grey),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Education (शिक्षा)",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: mainTheme,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),

                    //TV Education
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 16),
                        child: Text("Education (शिक्षा)",
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: mainTheme)),
                      ),
                    ),
                    //DD Education
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
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
                                  setState(() {
                                    defEducation = newValue!;
                                  });
                                }),
                          ),
                        ),
                      ),
                    ),

                    //TV Overseas Work Exp
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 16),
                        child: Text(
                            "Overseas Work Experience (विदेशी काम का अनुभव)",
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: mainTheme)),
                      ),
                    ),
                    //DD Overseas Work Exp
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _overseaWorkExpController,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "0 Years",
                            hintStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: mainTheme, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1)),
                          ),
                        ),
                      ),
                    ),

                    //TV Indian Work Exp
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 16),
                        child: Text(
                            "Indian Work Experience (भारतीय काम का अनुभव)",
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: mainTheme)),
                      ),
                    ),
                    //DD Indian Work Exp
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: _indianWorkEpController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "10+ Years",
                            hintStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: mainTheme, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1)),
                          ),
                        ),
                      ),
                    ),
                    //Save Button
                   InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                              width: double.infinity,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(color: mainTheme),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                        ),
                        onTap: () async {
                          if (_nameController.text.isEmpty ||
                              _emailController.text.isEmpty ||
                              defGender.isEmpty ||
                              date == null ||
                          //     defCountry == "Country" ||
                          // defState =="State" ||
                          defEducation=="Education" ||
                          _overseaWorkExpController.text.isEmpty ||
                          _indianWorkEpController.text.isEmpty
                          ) {
                            setState(() {
                              loading = true;
                            });
                            GFToast.showToast(
                                "All fields are mandatory!", context,
                                toastPosition: GFToastPosition.BOTTOM);
                            setState(() {
                              loading = false;
                            });
                          } else {
                            setState(() {
                              loading = true;
                            });
                            userID = BasicConstants.prefs!
                                .getString(BasicConstants.USER_ID)!;
                            _registerUser = await ApiService().registerUser(
                                userID,
                                _nameController,
                                _emailController,
                                defGender,
                                date!.toString(),
                                defEducation,
                                _overseaWorkExpController,
                                _indianWorkEpController);
                            if (_registerUser?.statusCode == 200) {
                              GFToast.showToast("Profile Created", context,
                                  toastPosition: GFToastPosition.BOTTOM);
                              BasicConstants.prefs?.setString(
                                  BasicConstants.USER_NAME,
                                  _registerUser!.user.name!);
                              print('name= ${_registerUser!.user.name!}');
                              setState(() {
                                loading = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Categories()));
                            } else {
                              GFToast.showToast(
                                  "Kuch dikkt hai bhai!${_registerUser?.user}",
                                  context,
                                  toastPosition: GFToastPosition.BOTTOM);
                              setState(() {
                                loading = false;
                              });
                            }
                          }
                        }),
                  ],
                ),
              ),
            ),
    );
  }

  void initializeData() async {
    BasicConstants.prefs = await SharedPreferences.getInstance();
    setState(() {
      loading = true;
    });
    _getStateModel = await ApiService().getStateList(1);
    setState(() {
      _stateList = _getStateModel!.data;
      print("Selected Satate  $_stateList");
      loading = false;
    });
  }
}
