import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/models/offer_res.dart';
import 'package:darain_travels/models/subscription_plans.dart';
import 'package:darain_travels/screens/payment_webview.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:darain_travels/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplyCoupon extends StatefulWidget {
  List<PlanList> _planList;
  int index;
  String userId;
  Color planBackground, planButtonColor;

  ApplyCoupon(this._planList, this.index, this.userId, this.planBackground,
      this.planButtonColor,
      {super.key});

  @override
  State<ApplyCoupon> createState() => _ApplyCouponState();
}

class _ApplyCouponState extends State<ApplyCoupon> {
  bool couponApplied = false,
      loading = false,
      valInPer = false,
      invalidCoupon = false;
  OfferResponse? _offerResponse;
  TextEditingController offerCon = TextEditingController();
  int valPercentage = 0;
  int valAmount = 0;
  int finalPrice = 0;
  int discAmount = 0;
  String? errortext;

  @override
  void initState() {
    super.initState();
    finalPrice = widget._planList[widget.index].finalPrice;
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Summary",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 18),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      // gradient: const LinearGradient(
                      //     colors: [
                      //       Color(0xffE2F8FF),
                      //       Color(0xffD9FFF8),
                      //       Color(0xffFAFFFE)
                      //     ],
                      //     begin: Alignment.topCenter,
                      //     end: Alignment.bottomCenter),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(color: grey, blurRadius: 20)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget._planList[widget.index].name} Plan",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: mainTheme),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "${widget._planList[widget.index].des}",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: mainTheme),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Plan Amount :",
                                style: GoogleFonts.poppins(
                                    fontSize: 14, color: Colors.black),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "₹ ${widget._planList[widget.index].price.toString()}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.black,
                                        decorationThickness: 2),
                                  ),
                                  Text(
                                    "₹ ${widget._planList[widget.index].finalPrice.toString()}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                valInPer
                                    ? "Discount : $valPercentage %"
                                    : "Discount :",
                                style: GoogleFonts.poppins(
                                    fontSize: 14, color: Colors.black),
                              ),
                              Text(
                                "₹ $discAmount",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Amount :",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                              Text(
                                "₹ ${finalPrice.toString()}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        if (couponApplied)
                          Center(
                            child: ClipPath(
                              clipper: DolDurmaClipper(holeRadius: 20),
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.amberAccent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      color: mainTheme,
                                      height: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0,
                                            top: 4,
                                            bottom: 4,
                                            right: 4),
                                        child: RotatedBox(
                                            quarterTurns: 3,
                                            child: Text(
                                              offerCon.text.toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            )),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          valPercentage == 0
                                              ? "₹ $valAmount DISCOUNT"
                                              : "$valPercentage% DISCOUNT",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "You Saved ₹$discAmount",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: Colors.green),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          child: const Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                            size: 25,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              couponApplied = false;
                                              offerCon.clear();
                                              discAmount = 0;
                                              finalPrice = widget
                                                  ._planList[widget.index]
                                                  .finalPrice;
                                              valInPer = false;
                                            });
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // child: Container(
                            //   height: 120,
                            //   child: Stack(
                            //     alignment: Alignment.center,
                            //     children: [
                            //       Image.asset('assets/images/voucher.png', height: 95, width: MediaQuery.of(context).size.width,fit: BoxFit.fill,),
                            //       Padding(
                            //         padding: const EdgeInsets.only(top: 19.0),
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.center,
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             Column(
                            //               children: [
                            //                 Text(
                            //                   offerCon.text.toString(),
                            //                   style: GoogleFonts.poppins(
                            //                       fontWeight: FontWeight.w600,
                            //                       fontSize: 14,
                            //                       color: mainTheme),
                            //                 ),
                            //                 Text(
                            //                   valPercentage==0? "₹ $valAmount DISCOUNT" :"$valPercentage% DISCOUNT",
                            //                   style: GoogleFonts.poppins(
                            //                       fontWeight: FontWeight.w600,
                            //                       fontSize: 22,
                            //                       color: Colors.white),
                            //                 ),
                            //                 Text(
                            //                   "You Saved ₹$discAmount",
                            //                   style: GoogleFonts.poppins(
                            //                       fontWeight: FontWeight.w600,
                            //                       fontSize: 14,
                            //                       color: Colors.white),
                            //                 ),
                            //               ],
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       Align(
                            //         alignment: Alignment.topRight,
                            //           child: InkWell(child: Icon(Icons.cancel, color: Colors.red, size: 25,),
                            //           onTap: (){
                            //             setState(() {
                            //               couponApplied = false;
                            //               offerCon.clear();
                            //               discAmount = 0;
                            //               finalPrice = widget._planList[widget.index].finalPrice;
                            //               valInPer = false;
                            //             });
                            //           },
                            //           ),
                            //       )
                            //     ]
                            //   ),
                            // ),
                          )
                        else
                          Center(
                            child: InkWell(
                              child: Text(
                                "Have a promo code?",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: mainTheme),
                              ),
                              onTap: () {
                                setState(() {
                                  showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      enableDrag: true,
                                      isScrollControlled: true,
                                      builder: (builder) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                            left: 24,
                                            right: 24,
                                          ),
                                          child: SizedBox(
                                            height: 200,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 36,
                                                ),
                                                Text(
                                                  "Apply Coupon Code",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                                TextField(
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black),
                                                  controller: offerCon,
                                                  decoration: InputDecoration(
                                                      errorText: invalidCoupon
                                                          ? errortext
                                                          : null,
                                                      hintText:
                                                          "Enter Coupon Code",
                                                      hintStyle:
                                                          GoogleFonts.poppins(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black),
                                                      suffix: InkWell(
                                                        child: Text(
                                                          "Apply",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      mainTheme),
                                                        ),
                                                        onTap: () {
                                                          applyCoup();
                                                        },
                                                      ),
                                                      fillColor:
                                                          Colors.grey.shade300,
                                                      filled: true),
                                                  textCapitalization:
                                                      TextCapitalization
                                                          .characters,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                GFButton(
                  shape: GFButtonShape.pills,
                  color: mainTheme,
                  text: 'Checkout',
                  fullWidthButton: true,
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                  onPressed: () async {
                    String url = widget.userId;
                    String userID = widget._planList[widget.index].planId;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentWebView(
                                  widget._planList,
                                  widget.index,
                                  widget.planBackground,
                                  widget.planButtonColor,
                                  initialUrl:
                                      'https://admin.daraintravels.in/phonepe/payment/$url/$userID/darain@@password',
                                )));
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentSuccessScreen(widget._planList, widget.index, widget.planBackground, widget.planButtonColor)));
                  },
                ),
              ],
            ),
          ),
        ));
  }

  void applyCoup() async {
    _offerResponse = await ApiService().getOffer(offerCon.text.toString());
    print("Sahi hai $_offerResponse key");
    // _offerResponse = offerResponseFromJson(jsonEncode(res));
    if (_offerResponse!.discountInfo != null) {
      if (_offerResponse!.discountInfo!.type == "percentage") {
        setState(() {
          valPercentage = _offerResponse!.discountInfo!.value!;
          discAmount =
              (widget._planList[widget.index].finalPrice * valPercentage) ~/
                  100;
          valInPer = true;
          finalPrice = finalPrice - discAmount;
        });
      } else {
        setState(() {
          valAmount = _offerResponse!.discountInfo!.value!;
          discAmount = (widget._planList[widget.index].finalPrice - valAmount);
          valInPer = false;
          finalPrice = finalPrice - discAmount;
        });
      }
      setState(() {
        invalidCoupon = true;
        Navigator.pop(context);
        couponApplied = true;
      });
    } else {
      print("Invalid Coupon");
      setState(() {
        errortext = _offerResponse!.error;
        invalidCoupon = true;
      });
    }
  }
}

class DolDurmaClipper extends CustomClipper<Path> {
  final double holeRadius;

  DolDurmaClipper({required this.holeRadius});

  @override
  Path getClip(Size size) {
    var bottom = size.height / 2;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0.0, size.height - bottom - holeRadius)
      ..arcToPoint(
        Offset(0, size.height - bottom),
        clockwise: true,
        radius: const Radius.circular(1),
      )
      ..lineTo(0.0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height - bottom)
      ..arcToPoint(
        Offset(size.width, size.height - bottom - holeRadius),
        clockwise: true,
        radius: const Radius.circular(1),
      );

    path.lineTo(size.width, 0.0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(DolDurmaClipper oldClipper) => true;
}
