
import 'package:darain_travels/screens/createProfileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';

import '../firebase_options.dart';

class Authentication {
  static String verificationId = "";

  static Future<FirebaseApp> initializeFirebase(
      {required BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    return firebaseApp;
  }

  static Future<void> verifyMobileNumber(
      {required BuildContext context, String? mobile}) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try
    {
      await firebaseAuth.verifyPhoneNumber(
          phoneNumber: "+91$mobile",
          timeout: const Duration(seconds: 60),
          verificationCompleted: (authCredential) =>
              _verificationCompleted(authCredential, context),
          verificationFailed: (authException) =>
              _verificationFailed(authException, context),
          codeSent: (verificationID, [code]) => _codeSent(verificationID, [code]),
          codeAutoRetrievalTimeout: (verificationID) =>
              _codeAutoRetrievalTimeout(verificationID));
      // ignore: use_build_context_synchronously
    }on FirebaseException catch(exception){
      if(exception.code==''){

      }else{

      }
    } catch (exc){
      print(exc);
    }

  }

  static _verificationCompleted(
      PhoneAuthCredential authCredential, BuildContext context) {
    GFToast.showToast("Verification Successfully", BuildContext as BuildContext, toastPosition: GFToastPosition.BOTTOM);
    debugPrint("Verification Successfully");
    return null;
  }

  static _verificationFailed(
      FirebaseAuthException authException, BuildContext context) {
    GFToast.showToast("Invalid OTP!", BuildContext as BuildContext, toastPosition: GFToastPosition.BOTTOM);
    debugPrint("Invalid OTP!");
    return null;
  }

  static _codeAutoRetrievalTimeout(String verificationID) {
    GFToast.showToast("Timeout, Please try again!", BuildContext as BuildContext, toastPosition: GFToastPosition.BOTTOM);
    debugPrint("Timeout, Please try again!");
    verificationId = verificationID;
  }

  static _codeSent(String verificationID, List<int?> code) {
    GFToast.showToast("OTP sent to your registered mobile number", BuildContext as BuildContext, toastPosition: GFToastPosition.BOTTOM);
    debugPrint("Otp successfully sent to your mobile number");
    debugPrint(verificationID);
    verificationId = verificationID;
  }

  static Future<void> signInWithMobile(
      {required BuildContext context, required String otp}) async {
    print("otp: $otp");
    await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp));
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateProfile()));
  }

  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (exception) {
      exception.toString();
    }
  }
}
