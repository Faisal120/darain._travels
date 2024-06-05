import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/screens/getTicketScreen.dart';
import 'package:darain_travels/screens/ticketScreen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_bar.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  bool isPremium = false;
  var supportSvg = [
    'assets/images/phone.svg',
    'assets/images/warning.svg',
    'assets/images/disclaimer.svg',
  ];

  var supportTitle = [
    'HR/Agency Did Not Pick up the call (HR/एजेंसी ने फोन नही उठाया)',
    'Other Issue (अन्य)',
    'Disclaimer (अस्वीकरण)',
  ];

  var supportContent = [
    'HR/Agency may not be available,So please retry after sometime. As thousand+ of people apply,it may not be possible for HR/Agency to respond to everyone. So please upload your CV and apply by mailing the agency. \n\n(एचआर / एजेंसी कॉल रिसीव के लिए उपलब्ध नहीं हो सकती है, इसलिए कृपया कुछ समय बाद पुनः प्रयास करें। क्यूंकि हजारों लोग आवेदन करते हैं, एचआर / एजेंसी के लिए हर किसी को जवाब देना संभव नहीं हो सकता है। इस लिए आप अप्लाई में जाके अपना सीबी अपलोड करके एजेंसी को मेल करके आवेदन करे.)',
    'If there\'s any other issue or crash that you\'ve faced, you can also report here. info@daraintravels.in \n\n(यदि कोई अन्य ऐप समस्या या क्रैश है जिसका आपने सामना किया है, तो आप इसकी रिपोर्ट यहां भी कर सकते हैं।)',
    'This is to inform all concerned that \'Darain Travels\' is a free service to job seekers.\n\nAll the information on this application is published in good faith and for general information purpose only. We Publish Information we received from various offline and online sources. We hold no responsibility for Jobs information we post on this portal. \'Darain Travels\' does not make any warranties about the completeness, reliability, and accuracy of this information. We are not cross-checking job roles, once we receive job requirements or opening information, We post them on this app. We request you to check companies authenticity before you proceed further.\n\nAny action you take upon the information you find on this application (Darain Travels), is strictly at your own risk. We(Darain travels) will not be liable for any losses and/or damages in connection with the use of our application.\n\nIf you require any more information or have any questions about our site\'s disclaimer, please feel free to contact us by email at info@daraintravels.in',
  ];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sharedPreferences) {
      isPremium = sharedPreferences.getBool(BasicConstants.IS_PREMiUM_USER)!;
      print("Is_Premium $isPremium");
    });

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListView.builder(
              itemBuilder: (context, index) {
                return _supportList(supportTitle[index], supportSvg[index], supportContent[index]);
              },
              itemCount: supportTitle.length,
              physics: const ScrollPhysics(),
              shrinkWrap: true,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                    child: GFButton(
                      shape: GFButtonShape.standard,
                      color: isPremium? Colors.grey : Colors.green,
                      text: 'New Ticket',
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                      onPressed: () {
                        isPremium? Navigator.push(context, CupertinoPageRoute(builder: (context)=> const TicketScreen())):null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                    child: GFButton(
                      shape: GFButtonShape.standard,
                      color: Colors.green,
                      text: 'View Ticket',
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const GetTicketScreen()));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _supportList(String supportTitle, String supportSvg, String supportContent) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ExpansionTile(
            title: Text(
              supportTitle,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
              ),
            ),
            leading: SvgPicture.asset(supportSvg,
                height: 25, width: 25, fit: BoxFit.cover),
            backgroundColor: mainTheme,
            textColor: Colors.white,
            iconColor: Colors.white,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supportContent,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.grey,
          height: 2,
          thickness: 1,
        ),
      ],
    );
    //   Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           SvgPicture.asset(supportSvg,
    //               height: 25, width: 25, fit: BoxFit.cover),
    //           Text(
    //             supportTitle,
    //             style: GoogleFonts.poppins(
    //                 fontWeight: FontWeight.w500,
    //                 color: Colors.black,
    //                 fontSize: 14),
    //           ),
    //           SvgPicture.asset('assets/images/arrowRight.svg',
    //               height: 25, width: 25, fit: BoxFit.cover),
    //         ],
    //       ),
    //     ),
    //     Divider(
    //       color: Colors.grey,
    //       height: 2,
    //       thickness: 1,
    //     )
    //   ],
    // );
  }
}
