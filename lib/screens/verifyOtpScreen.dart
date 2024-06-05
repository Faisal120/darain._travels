import 'dart:async';

import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/sendOtpRes.dart';
import 'package:darain_travels/models/verifyOtp.dart';
import 'package:darain_travels/screens/createProfileScreen.dart';
import 'package:darain_travels/screens/dashboardScreen.dart';
import 'package:darain_travels/screens/main_screen.dart';
import 'package:darain_travels/screens/splashScreen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:darain_travels/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerifyOtpScreen extends StatefulWidget{
  String mobileNumber;

  VerifyOtpScreen(this.mobileNumber, {super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  TextEditingController otp = TextEditingController();
  String? otpCode;
  // String? resendOtp = "Resend OTP";
  // bool resendCode = false;
  VerifyOtp? _verifyOtp;
  SendOtpRes? _sendOtpRes;
  bool otpLoading= false;
  Timer? _timer;
  int _start = 60;

  @override
  void initState() {
    setState(() {
      startTimer();
      listenOtp();
    });
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  void listenOtp() async {
    await SmsAutoFill().listenForCode();
    print("AutoFill OTP Called");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1.5,
                    width: MediaQuery.of(context).size.width / 4.5,
                    color: const Color.fromARGB(255, 153, 153, 153),
                    padding: const EdgeInsets.only(
                      top: 2,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text('OTP VERIFICATION',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                      height: 1.5,
                      width: MediaQuery.of(context).size.width / 4.5,
                      color: const Color.fromARGB(255, 153, 153, 153),
                      padding: const EdgeInsets.only(
                        top: 2,
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 42,
            ),
            Text('Enter 4 digit OTP sent to ${widget.mobileNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 42,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 48),
              child:  PinFieldAutoFill(
                currentCode: otpCode,
                codeLength: 4,
                decoration: BoxLooseDecoration(
                  radius: const Radius.circular(10),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black
                  ),
                  strokeColorBuilder: const FixedColorBuilder(mainTheme),
                  strokeWidth: 1.5,
                        ),
                onCodeChanged: (code){
                  otpCode = code.toString();
                },
                onCodeSubmitted: (val){
                  verifyOtp();
                },
              )
              // Pinput(
              //   controller: otp,
              //   onChanged: (value) {
              //     // if (otp.text.length != 4) {
              //     //   GFToast.showToast("Please enter your OTP!", context, toastPosition: GFToastPosition.BOTTOM);
              //     // } else {
              //     //   // showCustomSnackBar("OTP is invalid !", isError: true);
              //     // }
              //   },
              //   defaultPinTheme: PinTheme(
              //       height: 43,
              //       width: 45,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         border: Border.all(color: Colors.grey),
              //       )),
              //   length: 4,
              //   showCursor: true,
              //   onCompleted: (pin) => print(pin),
              // ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: GoogleFonts.openSans(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
              onPressed: () {
              },
              child: _start != 0 && _start != 60
                  ? Text(
                "Resend code in ($_start) sec",
                style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: mainTheme,
                    fontWeight: FontWeight.w700),
              )
                  : InkWell(
                    child: Text("Resend OTP",
                    style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: mainTheme,
                    fontWeight: FontWeight.w700)),
                onTap: (){
                  startTimer();
                  ApiService().sendOtp("+91", widget.mobileNumber, context);
                },
                  ),
            ),
            // InkWell(
            //   child: Text(_start != 0 && _start != 60 ?"Resend code in $_start sec": "Resend OTP" , style: GoogleFonts.poppins(
            //     color: _start != 0 && _start != 60? Colors.grey :mainTheme,
            //     fontSize: 14,
            //     fontWeight: FontWeight.w600
            //   ),
            //   ),
            //   onTap: (){
            //     setState(() {
            //       if(_start == 0){
            //         startTimer();
            //       }
            //       // resendCode = true;
            //       // print(resendCode);
            //     });
            //   },
            // ),
            const SizedBox(
              height: 34,
            ),
            otpLoading? const Center(
              child: CircularProgressIndicator(),
            ) :InkWell(
              child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  width: 150,
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: mainTheme,
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Continue",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              onTap: () {
                if (otpCode!.length == 4) {
                  verifyOtp();
                } else {
                  // showCustomSnackBar("OTP is invalid !", isError: true);
                  GFToast.showToast("Please enter your OTP!", context, toastPosition: GFToastPosition.BOTTOM);
                }
                // verifyOtp();
              },
            ),
          ],
        ),
      ),
    );
  }
  Future verifyOtp() async {
    otpLoading = true;
    var prefs = await SharedPreferences.getInstance();
    var fcmToken = prefs.getString("rFCMToken");
    // ignore: use_build_context_synchronously
    _verifyOtp = await ApiService().verifyotp(
        widget.mobileNumber.toString(),
        otpCode!,
        context,
      fcmToken!
    );
    if (_verifyOtp?.statusCode == 200) {
      if (_verifyOtp!.name=="NA") {
        print("User is ${_sendOtpRes?.statusHint}");
        BasicConstants.prefs
            ?.setString(BasicConstants.USER_NAME, _verifyOtp!.name);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CreateProfile()));
        GFToast.showToast('Signup Successful!', context,
            toastPosition: GFToastPosition.BOTTOM);
        setState(() {
          otpLoading = false;
        });
      } else {
        BasicConstants.prefs
            ?.setString(BasicConstants.USER_NAME, _verifyOtp!.name);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => MainScreen()), (Route route)=> false);
        GFToast.showToast('Login Successful!', context,
            toastPosition: GFToastPosition.BOTTOM);
        setState(() {
          otpLoading = false;
        });
      }
      prefs.setBool(SplashScreenState.LOGGED_IN, true);
    } else {
      GFToast.showToast('${_verifyOtp?.statusMessage}', context,
          toastPosition: GFToastPosition.BOTTOM);
      setState(() {
        otpLoading = false;
      });
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _start = 60;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
}
