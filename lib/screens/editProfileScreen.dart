import 'dart:io';

import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/getProfile.dart';
import 'package:darain_travels/models/updateProfile.dart';
import 'package:darain_travels/widgets/date_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/get_state_model.dart';
import '../utils/myColors.dart';
import '../widgets/app_bar.dart';

class EditProfile extends StatefulWidget {
  GetProfile? getProfile;
  List<AllStateList> stateList;

  EditProfile(this.getProfile, this.stateList, {super.key});

  @override
  State<EditProfile> createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  UpdateProfile? _updateProfile;
  File? image;
  bool editable = false, loading = false;
  int maleGroupValue = 0;
  int femaleGroupValue = 0;
  bool isChecked = false;
  String defMonth = 'Month',
      defCountry = 'Country',
      defState = 'State',
      defGender = 'Select Gender';

  String? name, email, mobile, gender, day, year, nationality, state, imageUrl;
  TextEditingController? nameController,
      emailController,
      mobileController,
      dateController;
  var date, Vdate = false;

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
  var countryList = [
    'Country',
    'India',
  ];
  var stateList = [
    'State',
    'Uttar Pradesh',
    'Uttarakhand',
    'Punjab',
  ];
  var genderList = [
    'Select Gender',
    'Male',
    'Female',
    'Others',
  ];

  @override
  void initState() {
    super.initState();
    initializeUserData();
    nameController = TextEditingController(text: name);
    emailController = TextEditingController(text: email);
    mobileController = TextEditingController(text: mobile);
    dateController = TextEditingController(text: date.toString());
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
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  image != null
                      ? GFAvatar(
                          backgroundImage: FileImage(image!),
                          size: 75,
                          shape: GFAvatarShape.circle,
                        )
                      : imageUrl == null || imageUrl == "NA" ? const GFAvatar(
                    backgroundImage:
                    AssetImage('assets/images/user.png'),
                    shape: GFAvatarShape.circle,
                    size: 75,
                  ):GFAvatar(
                    backgroundImage:
                    NetworkImage(imageUrl!),
                    shape: GFAvatarShape.circle,
                    size: 75,
                  ),
                  editable
                      ? InkWell(
                          child: const GFAvatar(
                            size: 20,
                            shape: GFAvatarShape.circle,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.camera_alt_outlined, size: 20),
                          ),
                          onTap: () async {
                            showCupertinoModalPopup(
                                context: context, builder: buildActionSheet);
                          },
                        )
                      : const GFAvatar(
                          backgroundColor: Colors.transparent,
                        ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16),
                  child: Text("Name (नाम)",
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
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: "Name",
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
                  child: Text("Email (ईमेल)",
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
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
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

              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16),
                  child: Text("Mobile (मोबाईल न0)",
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
                    keyboardType: TextInputType.number,
                    textAlignVertical: TextAlignVertical.center,
                    controller: mobileController,
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w500),
                    decoration: const InputDecoration(
                      hintText: "Mobile No.",
                      hintStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      enabled: false,
                      focusedBorder: OutlineInputBorder(
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16),
                  child: Text("Gender (लिंग)",
                      style:
                          GoogleFonts.poppins(fontSize: 12, color: mainTheme)),
                ),
              ),

              Container(
                width: double.infinity,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: DropdownButton(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          value: defGender,
                          isExpanded: true,
                          disabledHint: Text(gender!),
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
                            if (!editable) {
                              return null;
                            } else {
                              setState(() {
                                defGender = newValue!;
                              });
                            }
                          }),
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16),
                  child: Text("Date of Birth (जन्मतिथि)",
                      style:
                          GoogleFonts.poppins(fontSize: 12, color: mainTheme)),
                ),
              ),
              //DD DOB

              DateTextField(
                tController: dateController!,
                htext: "MM-DD-YYY",
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
                      final DateFormat formatter = DateFormat('yyy/MM/dd');
                      date = formatter
                          .format(DateTime.parse(datevalue.toString()));
                      dateController!.text = date;
                      print(date);
                      // txt.text = date.toString();
                    });
                  });
                },
                icon: Icons.calendar_month,
                isValidate: Vdate,
                isEditable: editable,
              ),
              //TV Country
              // SizedBox(
              //   width: double.infinity,
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 16.0, left: 16),
              //     child: Text("Nationality",
              //         style:
              //             GoogleFonts.poppins(fontSize: 12, color: mainTheme)),
              //   ),
              // ),
              // //DD Country
              // SizedBox(
              //   width: double.infinity,
              //   height: 60,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Container(
              //       decoration: BoxDecoration(
              //           border: Border.all(
              //             color: Colors.grey,
              //             width: 1.0,
              //           ),
              //           borderRadius:
              //               const BorderRadius.all(Radius.circular(5))),
              //       child: Padding(
              //         padding: const EdgeInsets.only(left: 8.0),
              //         child: DropdownButton(
              //             isExpanded: true,
              //             borderRadius: const BorderRadius.only(
              //                 bottomLeft: Radius.circular(15),
              //                 bottomRight: Radius.circular(15)),
              //             value: defCountry,
              //             disabledHint: Text(nationality!),
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
              //               if (!editable) {
              //                 return null;
              //               } else {
              //                 setState(() {
              //                   defCountry = newValue!;
              //                 });
              //               }
              //             }),
              //       ),
              //     ),
              //   ),
              // ),
              //
              // //TV State
              // SizedBox(
              //   width: double.infinity,
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 16.0, left: 16),
              //     child: Text("Location",
              //         style:
              //             GoogleFonts.poppins(fontSize: 12, color: mainTheme)),
              //   ),
              // ),
              // //DD State
              // SizedBox(
              //   width: double.infinity,
              //   height: 60,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Container(
              //       decoration: BoxDecoration(
              //           border: Border.all(
              //             color: Colors.grey,
              //             width: 1.0,
              //           ),
              //           borderRadius:
              //               const BorderRadius.all(Radius.circular(5))),
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
              //             items: widget.stateList!.map((state) {
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

              Container(
                width: double.infinity,
                height: 45,
                margin: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : GFButton(
                        shape: GFButtonShape.standard,
                        color: Colors.green,
                        text: editable ? 'Save' : 'Edit Profile',
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
    );
  }

  void initializeUserData() {
    gender = widget.getProfile?.data.gender;
    defGender = gender!;
    name = widget.getProfile?.data.name;
    email = widget.getProfile?.data.email;
    mobile = widget.getProfile?.data.mobile;
    nationality = widget.getProfile?.data.nationality;
    defCountry = nationality!;
    state = widget.getProfile?.data.location;
    defState = state!;
    var dateVal = widget.getProfile?.data.dob;
    final DateFormat formatter = DateFormat('yyy/MM/dd');
    date = formatter.format(DateTime.parse(dateVal.toString()));
    imageUrl = widget.getProfile?.data.profileUrl;
  }

  void updateProfile() async {
    setState(() {
      loading = true;
    });
    var userID = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
    if(image==null){
      _updateProfile = await ApiService().updateProfile(
          context: context,
          userID: userID,
          nameController: nameController,
          emailController: emailController,
          defCountry: defCountry,
          defGender: gender,
          dob: date.toString(),
          defState: defState);
      if (_updateProfile?.statusCode == 200) {
        setState(() {
          BasicConstants.prefs?.setString(BasicConstants.USER_NAME, _updateProfile!.user.name);
          editable = false;
          loading = false;
        });
        GFToast.showToast('Profile Updated Successfully!', context,
            toastPosition: GFToastPosition.BOTTOM);
      } else {
        GFToast.showToast(
            'Something went Galat! ${_updateProfile?.statusCode}', context,
            toastPosition: GFToastPosition.BOTTOM);
      }
    }else{
      _updateProfile = await ApiService().updateMultipartProfile(
          context: context,
          userID: userID,
          nameController: nameController,
          emailController: emailController,
          defCountry: defCountry,
          defGender: gender,
          dob: date.toString(),
          defState: defState,
          image: image);
      if (_updateProfile?.statusCode == 200) {
        setState(() {
          BasicConstants.prefs?.setString(BasicConstants.USER_NAME, _updateProfile!.user.name);
          BasicConstants.prefs?.setString(BasicConstants.PROFILE_URL, _updateProfile!.user.profileUrl);
          editable = false;
          loading = false;
        });
        GFToast.showToast('Profile Updated Successfully!', context,
            toastPosition: GFToastPosition.BOTTOM);
      } else {
        GFToast.showToast(
            'Something went Galat! ${_updateProfile?.statusCode}', context,
            toastPosition: GFToastPosition.BOTTOM);
      }
    }

  }

  Future _openGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      print('path ${this.image.toString()}');
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on PlatformException catch (exc) {
      GFToast.showToast("Failed to pick image from gallery! $exc", context,
          toastPosition: GFToastPosition.BOTTOM);
    }
  }

  Future _openCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      print('path ${this.image.toString()}');
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on PlatformException catch (exc) {
      GFToast.showToast("Failed to pick image from gallery! $exc", context,
          toastPosition: GFToastPosition.BOTTOM);
    }
  }

  Widget buildActionSheet(BuildContext context) => CupertinoActionSheet(
        title: const Text("Select image!"),
        actions: [
          CupertinoActionSheetAction(
              onPressed: () {
                _openCamera();
              },
              child: const Text("Choose from camera")),
          CupertinoActionSheetAction(
              onPressed: () {
                _openGallery();
              },
              child: const Text("Choose from gallery")),
        ],
        cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
      );
}
