import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/subscription_plans.dart';
import 'package:darain_travels/screens/applyCouponScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/plan_validity_response.dart';
import '../widgets/app_bar.dart';

class SubscriptionDetails extends StatefulWidget {
  const SubscriptionDetails({super.key});

  @override
  State<SubscriptionDetails> createState() => _SubscriptionDetailsState();
}

class _SubscriptionDetailsState extends State<SubscriptionDetails> {
  SubscriptionPlan? _subscriptionPlan;
  List<PlanList>? _planList;
  bool loading = false, planExpired = false;
  String? imageUrl, planId, userId;
  PlanValidityRes? _validityRes;

  var planBackground = [
    const Color(0xffF26722),
    const Color(0xff007CC1),
    const Color(0xff32C100),
    const Color(0xffF26722),
    const Color(0xff007CC1),
    const Color(0xff32C100),
    const Color(0xffF26722),
    const Color(0xff007CC1),
    const Color(0xff32C100),
    const Color(0xffF26722),
    const Color(0xff007CC1),
    const Color(0xff32C100),
    const Color(0xffF26722),
    const Color(0xff007CC1),
    const Color(0xff32C100),
    const Color(0xffF26722),
    const Color(0xff007CC1),
    const Color(0xff32C100),
  ];

  var planButtonColor = [
    const Color(0xffFBA629),
    const Color(0xff0663A7),
    const Color(0xff06A716),
    const Color(0xffFBA629),
    const Color(0xff0663A7),
    const Color(0xff06A716),
    const Color(0xffFBA629),
    const Color(0xff0663A7),
    const Color(0xff06A716),
    const Color(0xffFBA629),
    const Color(0xff0663A7),
    const Color(0xff06A716),
    const Color(0xffFBA629),
    const Color(0xff0663A7),
    const Color(0xff06A716),
    const Color(0xffFBA629),
    const Color(0xff0663A7),
    const Color(0xff06A716),
  ];

  @override
  void initState() {
    getPlans(context);
    imageUrl = BasicConstants.prefs?.getString(BasicConstants.PROFILE_URL);
    planId = BasicConstants.prefs?.getString(BasicConstants.PLAN_ID);
    userId = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
    print('Image Url : $imageUrl, Plan id: $planId');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: const Text(''),
        backButton: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      imageUrl == null || imageUrl == "NA"
                          ? const GFAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/user.png'),
                              shape: GFAvatarShape.circle,
                              size: 50,
                            )
                          : GFAvatar(
                              backgroundImage: NetworkImage(imageUrl!),
                              shape: GFAvatarShape.circle,
                              size: 50,
                            ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Hello! ${BasicConstants.prefs?.getString(BasicConstants.USER_NAME)}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ListView.builder(
                        itemCount: _planList?.length,
                        itemBuilder: (context, index) {
                          return _subscriptionCards(index,
                              planBackground[index], planButtonColor[index]);
                        },
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemExtent: 180,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _subscriptionCards(
      int index, Color planBackground, Color planButtonColor) {
    return Container(
      width: double.infinity,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_planList?[index].name}',
                    style:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹ ${_planList?[index].price}',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.white,
                            decorationThickness: 2),
                      ),
                      Text(
                        '₹ ${_planList?[index].finalPrice}/${_planList?[index].maxMonth} Months',
                        style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Text(
                      '${_planList?[index].des}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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
                Row(
                  children: [
                    _planList![index].planId == planId
                        ? InkWell(
                            onTap: () {
                              _showMyDialog();
                            },
                            child: const Icon(
                              Icons.info_outline_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                          )
                        : const SizedBox(),
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
                _planList![index].planId == planId
                    ? InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              color: planExpired ? Colors.red: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: Text(
                              planExpired ? "Renew Plan" : "Existing Plan",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color:planExpired ? Colors.white : planButtonColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        onTap: () {
                          planExpired
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ApplyCoupon(
                                          _planList!,
                                          index,
                                          userId!,
                                          planBackground,
                                          planButtonColor)))
                              : null;
                        },
                      )
                    : _planList![index].name == "Free"
                        ? const SizedBox()
                        : GFButton(
                            shape: GFButtonShape.pills,
                            size: 30,
                            color: planButtonColor,
                            text: 'Choose Plan',
                            textStyle: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 12),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ApplyCoupon(
                                          _planList!,
                                          index,
                                          userId!,
                                          planBackground,
                                          planButtonColor)));
                            })
              ],
            ),
          )
        ],
      ),
    );
  }

  void getPlans(BuildContext context) async {
    setState(() {
      loading = true;
    });
    _subscriptionPlan = await ApiService().getPlans(context);
    _planList = _subscriptionPlan?.data;
    setState(() {
      loading = false;
      getPlannValidity(userId!);
    });
    print('Plans are : ${_planList}');
  }

  void getPlannValidity( String userID) async {
    setState(() {
      loading = true;
    });
    _validityRes = await ApiService().getPlanValidity(userID);
    if (_validityRes?.statusCode == 202 || _validityRes?.statusCode == 200) {
      setState(() {
        if(_validityRes?.planName=='Free'){
          planExpired = false;
        }else{
          var currentDate = DateTime.now();
          if (currentDate.isAfter(_validityRes!.date!)|| _validityRes!.jobLeft! <= 0) {
            print("Plan got expired");
            planExpired = true;
          } else {
            print("Plan is Valid");
            planExpired = false;
          }
        }
        loading = false;
      });
    }
  }

  void _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Subscription Details :",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black),
            ),
          ),
          content: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              planExpired ? Text(
                "Your Plan has been Expired!",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ): SizedBox(),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Plan Name:",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    _validityRes!.planName!,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Activation Date:",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    DateFormat("dd/MM/yyyy").format(_validityRes!.activeDate!),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  //2024-10-26
                  //2023-10-26 18:45:26
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Valid Till:",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    DateFormat("dd/MM/yyyy").format(_validityRes!.date!),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Jobs:",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    _validityRes!.totalAvJob.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Applied Jobs:",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    _validityRes!.totalApplied.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Jobs Left:",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    _validityRes!.jobLeft.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          )),
        );
      },
    );
  }
}
