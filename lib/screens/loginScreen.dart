// ignore_for_file: use_build_context_synchronously

import 'package:country_code_picker/country_code_picker.dart';
import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/sendOtpRes.dart';
import 'package:darain_travels/models/verifyOtp.dart';
import 'package:darain_travels/screens/createProfileScreen.dart';
import 'package:darain_travels/screens/dashboardScreen.dart';
import 'package:darain_travels/screens/splashScreen.dart';
import 'package:darain_travels/screens/verifyOtpScreen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _mobileController = TextEditingController();
  // var countryCode = "+91";
  bool loading = false;
  bool otpLoading = false;
  SendOtpRes? _sendOtpRes;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    BasicConstants.prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: GFAvatar(
                size: 60,
                shape: GFAvatarShape.circle,
                backgroundImage: AssetImage("assets/images/sp_logo.jpeg"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    " Darain Travels",
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                "Please enter your mobile number to login",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              "(लॉगिन करने के लिए कृपया अपना मोबाइल नंबर दर्ज करें)",
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CountryCodePicker(
                    initialSelection: '+91',
                    onChanged: (value) {},
                    favorite: ['IN', '+91'],
                    enabled: false,
                    boxDecoration: BoxDecoration(
                        border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      width: 220,
                      child: GFTextField(
                        controller: _mobileController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10)
                        ],
                        maxLength: 10,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainTheme, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : InkWell(
                    child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        width: 200,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: mainTheme,
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.only(left: 16, right: 16),
                        child: Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Login (लॉग इन करें)",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                    onTap: () async {
                      if (_mobileController.text.isEmpty) {
                        GFToast.showToast(
                            "Please enter your mobile number", context,
                            toastPosition: GFToastPosition.BOTTOM);
                      } else {
                        setState(() {
                          loading = true;
                        });
                        _sendOtpRes = await ApiService().sendOtp('+91',
                            _mobileController.text.toString(), context);
                        if (_sendOtpRes?.statusCode == 200) {
                          // ignore: use_build_context_synchronously
                          GFToast.showToast(
                              'Otp Sent To Your Phone Number!', context,
                              toastPosition: GFToastPosition.BOTTOM);
                          Future.delayed(const Duration(seconds: 2))
                              .then((value) => setState(() {
                                loading = false;
                          }));
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyOtpScreen(_mobileController.text.toString())));
                          BasicConstants.prefs?.setString(BasicConstants.USER_ID, _sendOtpRes!.userId);
                        } else {
                          GFToast.showToast('Something went wrong! ${_sendOtpRes?.statusMessage}', context,
                              toastPosition: GFToastPosition.BOTTOM);
                        }
                        setState(() {
                          otpLoading = false;
                        });
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }


  // void _onCountryChange(CountryCode countryCode) {
  //   if (countryCode != null) {
  //     this.countryCode = countryCode.toString();
  //   } else {
  //     print('Country Code =$countryCode');
  //   }
  // }
}
