import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogHelper {
  static void showLoader([String? messsage]){
    Get.dialog(
        Dialog(
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
                Text("Loading...", style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),)
              ],
            ),
          ),
        )
    );
  }
}