import 'package:darain_travels/models/subscription_plans.dart';
import 'package:darain_travels/screens/dashboardScreen.dart';
import 'package:darain_travels/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../utils/myColors.dart';
import '../widgets/app_bar.dart';

class PaymentFailureScreen extends StatefulWidget {

  PaymentFailureScreen({super.key});

  @override
  State<PaymentFailureScreen> createState() => _PaymentFailureScreenState();
}

class _PaymentFailureScreenState extends State<PaymentFailureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: const Text(''),
        backButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              Center(
                child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Lottie.asset(
                      'assets/animation/failure.json',
                    )),
              ),
              const SizedBox(
                height: 16,
              ),
              Center(
                child: Text(
                  "Failure!",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: Colors.red,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Your Plan Purchased Failed \n Please try again, After some time!",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 36,
              ),
              Center(
                child: GFButton(
                  shape: GFButtonShape.standard,
                  color: mainTheme,
                  text: 'Home',
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                  onPressed: () async {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainScreen()),
                        (route) => false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
