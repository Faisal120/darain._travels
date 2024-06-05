import 'dart:io';

import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/getProfile.dart';
import 'package:darain_travels/models/updateProfile.dart';
import 'package:darain_travels/screens/pdf_viewer.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_bar.dart';

class UploadDocuments extends StatefulWidget {
  const UploadDocuments({super.key});

  @override
  State<UploadDocuments> createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  GetProfile? _getProfile;
  UpdateProfile? _updateProfile;
  String? cvResume, idProof, passport, visa, panCard, userID;
  bool isLoading = false;
  Future<String>? deletedResponse;

  @override
  void initState() {
    super.initState();
    _getUserProfile();
    // initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: const Text(''),
        backButton: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  resumeUI(context),
                  iDUI(context),
                  passportUI(context),
                  expCerUI(context),
                  eduCerUI(context),

                  // visaUI(context),
                  // panUI(context),
                  // _documentCard(context,'CV/Resume' , 'assets/images/cv.png',1),
                  // _documentCard(context,'ID Proof' , 'assets/images/id.png',2),
                  // _documentCard(context,'Passport' , 'assets/images/passport.png',3),
                  // _documentCard(context,'Visa' , 'assets/images/visa.png',4),
                  // _documentCard(context,'Pan Card' , 'assets/images/pan.png',5),
                ],
              ),
            ),
    );
  }

  Widget resumeUI(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: DottedBorder(
        radius: const Radius.circular(8),
        color: grey,
        borderType: BorderType.RRect,
        strokeWidth: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120,
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: const GFAvatar(
                backgroundImage: AssetImage('assets/images/cv.png'),
                shape: GFAvatarShape.standard,
                radius: 15,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CV/Resume",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Upload here",
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                GFButton(
                    shape: GFButtonShape.pills,
                    size: 25,
                    text: cvResume == "NA" ? 'Upload' : 'Uploaded',
                    icon: cvResume == "NA"
                        ?const Icon(Icons.file_upload_outlined,
                        color: mainTheme)
                        : const Icon(Icons.check_circle, color: Colors.green),
                    textStyle:
                        GoogleFonts.poppins(fontSize: 12, color: mainTheme),
                    color: cvResume == "NA"
                        ? Colors.transparent
                        : Colors.green.shade50,
                    borderSide: BorderSide(
                      width: 1,
                      color:
                          cvResume == "NA" ?  mainTheme :Colors.green.shade100,
                    ),
                    onPressed: () {
                      cvResume == "NA" ?  uploadCV(context): null;
                    })
              ],
            ),
            SizedBox(
              child: Column(
                children: [
              cvResume == "NA" ?const SizedBox() :  Expanded(
                    child: InkWell(
                      child: Container(
                        width: 45,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: mainTheme.shade100,
                            border: Border.all(
                              color:  mainTheme,
                              width: 1,
                            )),
                        child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child:Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.white),
                                child:const Icon(Icons.remove_red_eye_outlined,
                                    color:  mainTheme))
                        ),
                      ),
                      onTap: () {
                        cvResume != null
                            ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PDFOpener(_getProfile!.data.cv!))) : null;
                      },
                    ),
                  ),
                  cvResume == "NA"
                      ?const SizedBox(): Expanded(
                    child: InkWell(
                      child: Container(
                        width: 45,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:Colors.red.shade200,
                            border: Border.all(
                              color: Colors.red,
                              width: 1,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: const Icon(Icons.delete,
                                  color:Colors.red)),
                        ),
                      ),
                      onTap: () {
                        // cvResume!= null ? Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFOpener(_getProfile!.data.cv!))): null;
                        cvResume != null
                            ? showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return buildActionSheet(context, 'cv', userID!);
                            })
                            : null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget iDUI(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: DottedBorder(
        radius: const Radius.circular(8),
        color: grey,
        borderType: BorderType.RRect,
        strokeWidth: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120,
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: const GFAvatar(
                backgroundImage: AssetImage('assets/images/id.png'),
                shape: GFAvatarShape.standard,
                radius: 15,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "License",
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "Upload here",
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                GFButton(
                    shape: GFButtonShape.pills,
                    size: 25,
                    text: idProof == "NA" ? 'Upload' : 'Uploaded',
                    icon: idProof == "NA"
                        ? const Icon(Icons.file_upload_outlined, color: mainTheme)
                        : const Icon(Icons.check_circle, color: Colors.green),
                    textStyle:
                        GoogleFonts.poppins(fontSize: 12, color: mainTheme),
                    color: idProof == "NA"
                        ?Colors.transparent
                        :  Colors.green.shade50,
                    borderSide: BorderSide(
                      width: 1,
                      color:
                          idProof == "NA" ? mainTheme : Colors.green.shade100,
                    ),
                    onPressed: () {
                      idProof == "NA" ?  uploadID(context) :null;
                    })
              ],
            ),
            idProof == "NA" ? const SizedBox()  :Column(
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                      width: 45,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                          idProof != null ? mainTheme.shade100 : grey[100],
                          border: Border.all(
                            color: idProof != null ? mainTheme : grey,
                            width: 1,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(Icons.remove_red_eye_outlined,
                                color: idProof != null
                                    ? mainTheme
                                    : Colors.black)),
                      ),
                    ),
                    onTap: () {
                      idProof != null
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PDFOpener(_getProfile!.data.idProof!)))
                          : null;
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      width: 45,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                          idProof != null ? Colors.red.shade200 : grey[100],
                          border: Border.all(
                            color: idProof != null ? Colors.red : grey,
                            width: 1,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(Icons.delete,
                                color: idProof != null
                                    ? Colors.red
                                    : Colors.black)),
                      ),
                    ),
                    onTap: () {
                      // idProof!= null ? Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFOpener(_getProfile!.data.idProof!))): null;
                      idProof != null
                          ? showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return buildActionSheet(context, 'id_Proof', userID!);
                          })
                          : null;
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget passportUI(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: DottedBorder(
        radius: const Radius.circular(8),
        color: grey,
        borderType: BorderType.RRect,
        strokeWidth: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120,
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: const GFAvatar(
                backgroundImage: AssetImage('assets/images/passport.png'),
                shape: GFAvatarShape.standard,
                radius: 15,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Passport",
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "Upload here",
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                GFButton(
                    shape: GFButtonShape.pills,
                    size: 25,
                    text: passport == "NA" ? 'Upload' : 'Uploaded',
                    icon: passport == "NA"
                        ? const Icon(Icons.file_upload_outlined, color: mainTheme)
                        : const Icon(Icons.check_circle, color: Colors.green),
                    textStyle:
                        GoogleFonts.poppins(fontSize: 12, color: mainTheme),
                    color: passport == "NA"
                        ? Colors.transparent
                        : Colors.green.shade50,
                    borderSide: BorderSide(
                      width: 1,
                      color:
                          passport == "NA" ? mainTheme : Colors.green.shade100,
                    ),
                    onPressed: () {
                      passport == "NA" ? uploadPassport(context) : null;
                    })
              ],
            ),
            passport == "NA" ? const SizedBox() : Column(
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                      width: 45,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                          passport != null ? mainTheme.shade100 : grey[100],
                          border: Border.all(
                            color: passport != null ? mainTheme : grey,
                            width: 1,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(Icons.remove_red_eye_outlined,
                                color: passport != null
                                    ? mainTheme
                                    : Colors.black)),
                      ),
                    ),
                    onTap: () {
                      passport != null
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PDFOpener(_getProfile!.data.passport!)))
                          : null;
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      width: 45,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: passport != null
                              ? Colors.red.shade200
                              : grey[100],
                          border: Border.all(
                            color: passport != null ? Colors.red : grey,
                            width: 1,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(Icons.delete,
                                color: passport != null
                                    ? Colors.red
                                    : Colors.black)),
                      ),
                    ),
                    onTap: () {
                      // passport!= null ? Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFOpener(_getProfile!.data.cv!))): null;
                      passport != null
                          ? showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return buildActionSheet(context, 'passport',userID!);
                          })
                          : null;
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget expCerUI(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: DottedBorder(
        radius: const Radius.circular(8),
        color: grey,
        borderType: BorderType.RRect,
        strokeWidth: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120,
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: const GFAvatar(
                backgroundImage: AssetImage('assets/images/experience_cer.png'),
                shape: GFAvatarShape.standard,
                radius: 15,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Experience Certificate",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Upload here",
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  GFButton(
                      shape: GFButtonShape.pills,
                      size: 25,
                      text: visa == "NA" ? 'Upload' : 'Uploaded',
                      icon: visa == "NA"
                          ? const Icon(Icons.file_upload_outlined,
                          color: mainTheme)
                          : const Icon(Icons.check_circle, color: Colors.green),
                      textStyle:
                          GoogleFonts.poppins(fontSize: 12, color: mainTheme),
                      color: visa == "NA"
                          ? Colors.transparent
                          : Colors.green.shade50,
                      borderSide: BorderSide(
                        width: 1,
                        color: visa == "NA" ? mainTheme : Colors.green.shade100,
                      ),
                      onPressed: () {
                        visa == "NA" ? uploadExpCer(context) : null;
                      })
                ],
              ),
            ),
            visa == "NA" ? const SizedBox() :Column(
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                      width: 45,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: visa != null ? mainTheme.shade100 : grey[100],
                          border: Border.all(
                            color: visa != null ? mainTheme : grey,
                            width: 1,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(Icons.remove_red_eye_outlined,
                                color:
                                visa != null ? mainTheme : Colors.black)),
                      ),
                    ),
                    onTap: () {
                      visa != null
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PDFOpener(_getProfile!.data.visa!)))
                          : null;
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      width: 45,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: visa != null ? Colors.red.shade200 : grey[100],
                          border: Border.all(
                            color: visa != null ? Colors.red : grey,
                            width: 1,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(Icons.delete,
                                color:
                                visa != null ? Colors.red : Colors.black)),
                      ),
                    ),
                    onTap: () {
                      // cvResume!= null ? Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFOpener(_getProfile!.data.cv!))): null;
                      cvResume != null
                          ? showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return buildActionSheet(context, 'visa',userID!);
                          })
                          : null;
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget eduCerUI(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: DottedBorder(
        radius: const Radius.circular(8),
        color: grey,
        borderType: BorderType.RRect,
        strokeWidth: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120,
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: const GFAvatar(
                backgroundImage: AssetImage('assets/images/education_cer.png'),
                shape: GFAvatarShape.standard,
                radius: 15,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Educational Experience",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Upload here",
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  GFButton(
                      shape: GFButtonShape.pills,
                      size: 25,
                      text: panCard == "NA" ? 'Upload' : 'Uploaded',
                      icon: panCard == "NA"
                          ? const Icon(Icons.file_upload_outlined,
                          color: mainTheme)
                          : const Icon(Icons.check_circle, color: Colors.green),
                      textStyle:
                          GoogleFonts.poppins(fontSize: 12, color: mainTheme),
                      color: panCard == "NA"
                          ? Colors.transparent
                          : Colors.green.shade50,
                      borderSide: BorderSide(
                        width: 1,
                        color:
                            panCard == "NA" ? mainTheme :  Colors.green.shade100,
                      ),
                      onPressed: () {
                        panCard == "NA" ? uploadEduExp(context) : null;
                      })
                ],
              ),
            ),
            panCard == "NA" ? const SizedBox() : Column(
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                      width: 45,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                          panCard != null ? mainTheme.shade100 : grey[100],
                          border: Border.all(
                            color: panCard != null ? mainTheme : grey,
                            width: 1,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(Icons.remove_red_eye_outlined,
                                color: panCard != null
                                    ? mainTheme
                                    : Colors.black)),
                      ),
                    ),
                    onTap: () {
                      panCard != null
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PDFOpener(_getProfile!.data.panCard!)))
                          : null;
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      width: 45,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                          panCard != null ? Colors.red.shade200 : grey[100],
                          border: Border.all(
                            color: panCard != null ? Colors.red : grey,
                            width: 1,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(Icons.delete,
                                color: panCard != null
                                    ? Colors.red
                                    : Colors.black)),
                      ),
                    ),
                    onTap: () {
                      panCard != null ? showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return buildActionSheet(context, 'pan_card',userID!);})
                          : null;
                      // cvResume!= null ? Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFOpener(_getProfile!.data.cv!))): null;
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future uploadCV(BuildContext context) async {
    var userID = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      File file = File(filePickerResult.files.single.path ?? " ");
      String fileName = file.path.split('/').last;
      print('fileName: $fileName');
      String path = file.path;
      print('FilePath $path');
      setState(() {
        isLoading = true;
      });
      _updateProfile = await ApiService()
          .uploadCV(context: context, userID: userID, cv: file);
      print("code is: ${_updateProfile?.statusCode}");
      if (_updateProfile?.statusCode == 200) {
        GFToast.showToast("Documents Uploaded Successfully!", context,
            toastPosition: GFToastPosition.BOTTOM);
        setState(() {
          _getUserProfile();
          isLoading = false;
        });
      }
    }
  }

  Future uploadID(BuildContext context) async {
    var userID = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      File file = File(filePickerResult.files.single.path ?? " ");
      String fileName = file.path.split('/').last;
      print('fileName: $fileName');
      String path = file.path;
      print('FilePath $path');
      setState(() {
        isLoading = true;
      });
      _updateProfile = await ApiService()
          .uploadID(context: context, userID: userID, id: file);
      print("code is: ${_updateProfile?.statusCode}");
      if (_updateProfile?.statusCode == 200) {
        GFToast.showToast("Documents Uploaded Successfully!", context,
            toastPosition: GFToastPosition.BOTTOM);
        setState(() {
          _getUserProfile();
          isLoading = false;
        });
      }
    }
  }

  Future uploadPassport(BuildContext context) async {
    var userID = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      File file = File(filePickerResult.files.single.path ?? " ");
      String fileName = file.path.split('/').last;
      print('fileName: $fileName');
      String path = file.path;
      print('FilePath $path');
      setState(() {
        isLoading = true;
      });
      _updateProfile = await ApiService()
          .uploadPassport(context: context, userID: userID, passport: file);
      print("code is: ${_updateProfile?.statusCode}");
      if (_updateProfile?.statusCode == 200) {
        GFToast.showToast("Documents Uploaded Successfully!", context,
            toastPosition: GFToastPosition.BOTTOM);
        setState(() {
          _getUserProfile();
          isLoading = false;
        });
      }
    }
  }

  Future uploadExpCer(BuildContext context) async {
    var userID = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      File file = File(filePickerResult.files.single.path ?? " ");
      String fileName = file.path.split('/').last;
      print('fileName: $fileName');
      String path = file.path;
      print('FilePath $path');
      setState(() {
        isLoading = true;
      });
      _updateProfile = await ApiService()
          .uploadVisa(context: context, userID: userID, visa: file);
      print("code is: ${_updateProfile?.statusCode}");
      if (_updateProfile?.statusCode == 200) {
        GFToast.showToast("Documents Uploaded Successfully!", context,
            toastPosition: GFToastPosition.BOTTOM);
        setState(() {
          _getUserProfile();
          isLoading = false;
        });
      }
    }
  }

  Future uploadEduExp(BuildContext context) async {
    var userID = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      File file = File(filePickerResult.files.single.path ?? " ");
      String fileName = file.path.split('/').last;
      print('fileName: $fileName');
      String path = file.path;
      print('FilePath $path');
      setState(() {
        isLoading = true;
      });
      _updateProfile = await ApiService()
          .uploadPan(context: context, userID: userID, panCard: file);
      print("code is: ${_updateProfile?.statusCode}");
      if (_updateProfile?.statusCode == 200) {
        GFToast.showToast("Documents Uploaded Successfully!", context,
            toastPosition: GFToastPosition.BOTTOM);
        setState(() {
          _getUserProfile();
          isLoading = false;
        });
      }
    }
  }

  // void initializeData() async {
  //   isCVUploaded = (BasicConstants.prefs?.getBool(BasicConstants.CV_UPLOADED))!;
  //   isIdUploaded = (BasicConstants.prefs?.getBool(BasicConstants.ID_UPLOADED))!;
  //   isPassportUploaded =
  //       (BasicConstants.prefs?.getBool(BasicConstants.PASSPORT_UPLOADED))!;
  //   isVisaUploaded =
  //       (BasicConstants.prefs?.getBool(BasicConstants.VISA_UPLOADED))!;
  //   isPanUploaded =
  //       (BasicConstants.prefs?.getBool(BasicConstants.PAN_UPLOADED))!;
  //   print('cvValue: $isCVUploaded');
  //   _getUserProfile();
  // }

  void _getUserProfile() async {
    setState(() {
      isLoading = true;
    });
    userID = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
    _getProfile = await (ApiService().getProfile(context, userID!));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    cvResume = _getProfile?.data.cv;
    idProof = _getProfile?.data.idProof;
    passport = _getProfile?.data.passport;
    visa = _getProfile?.data.expCert;
    panCard = _getProfile?.data.eduCert;

    print(
        'Uploaded Documents: $cvResume, $idProof, $passport, $visa, $panCard, $userID');
    setState(() {
      isLoading = false;
    });
  }

  Widget buildActionSheet(BuildContext context, String docs, String userID) =>
      CupertinoActionSheet(
        title: Text(
          "Are you sure want to delete?",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500, color: Colors.black, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                ApiService().deleteDocs(context, userID, docs);
                _getUserProfile();
                Navigator.pop(context);
              });
            },
            child: Text(
              "Yes",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "No",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      );
}
