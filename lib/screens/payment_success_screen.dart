import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/plan_validity_response.dart';
import 'package:darain_travels/models/subscription_plans.dart';
import 'package:darain_travels/screens/dashboardScreen.dart';
import 'package:darain_travels/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/myColors.dart';
import '../widgets/app_bar.dart';

class PaymentSuccessScreen extends StatefulWidget {
  List<PlanList> planList;
  int index;
  Color planBackground, planButtonColor;

  PaymentSuccessScreen(
      this.planList, this.index, this.planBackground, this.planButtonColor,
      {super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  String? userID;
  PlanValidityRes? _validityRes;
  bool loading = false;

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences sharedPreferences) {
      userID = sharedPreferences.getString(BasicConstants.USER_ID);
      getPlannValidity(widget.planList[widget.index].planId, userID!);
    });
    super.initState();
  }

  void getPlannValidity(String planId, String userID)async{
    setState(() {
      loading = true;
    });
    _validityRes = await ApiService().getPlanValidity(userID);
    if(_validityRes?.statusCode==202 || _validityRes?.statusCode==200 ){
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: const Text(''),
        backButton: true,
      ),
      body: loading? const Center(child: CircularProgressIndicator()) : Padding(
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
                      'assets/animation/suc_anim.json',
                    )),
              ),
              const SizedBox(
                height: 16,
              ),
              Center(
                child: Text(
                  "Thank You!",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: Colors.green,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Your Plan has been Purchased Successfully",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              _validityRes!.statusCode==200? SizedBox() : Center(
                child: Text(
                  "You Updated Plan is :",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              _validityRes!.statusCode==200? SizedBox() :Center(
                child: Container(
                    width: 300,
                    child: _subscriptionCards(
                        widget.index,
                        widget.planBackground,
                        widget.planButtonColor,
                        widget.planList)),
              ),
              const SizedBox(
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

  Widget _subscriptionCards(int index, Color planBackground,
      Color planButtonColor, List<PlanList> _planList) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              colors: [planBackground, planButtonColor],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter),
          boxShadow: [BoxShadow(color: planButtonColor, blurRadius: 8)]),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _planList[index].name,
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹ ${_planList[index].price}',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.white,
                            decorationThickness: 2),
                      ),
                      Text(
                        '₹ ${_planList[index].finalPrice}/${_planList[index].maxMonth} Months',
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Text(
                    _planList[index].des,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Valid up to : ${DateFormat('yyyy-MM-dd').format(_validityRes!.date!)}",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  // ignore: deprecated_member_use
                  child: SvgPicture.asset(
                    'assets/images/prem.svg',
                    fit: BoxFit.cover,
                    height: 20,
                    width: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
