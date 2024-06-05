import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/screens/all_jobs.dart';
import 'package:darain_travels/screens/applied_jobs.dart';
import 'package:darain_travels/screens/saved_jobs.dart';
import 'package:darain_travels/screens/selectJobsScreen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllJobsScreen extends StatefulWidget {
  List<String> selectedCats;
  String countryId, stateId;
  AllJobsScreen(this.selectedCats, this.countryId,this.stateId, {super.key});

  @override
  State<AllJobsScreen> createState() => _AllJobsScreenState();
}

class _AllJobsScreenState extends State<AllJobsScreen> with TickerProviderStateMixin {
  TabController? _tabController;

  String? userName, imageUrl, userID;
  List<String> selectedCats=[];
  bool isPremiumUser = false;

  @override
  void initState() {
    super.initState();
    initializeData();
    _tabController = TabController(length: 3, vsync: this);
  }

  void initializeData() async {
    BasicConstants.prefs= await SharedPreferences.getInstance();
    setState(() {
      userName = BasicConstants.prefs?.getString(BasicConstants.USER_NAME);
      userID = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
      imageUrl = BasicConstants.prefs?.getString(BasicConstants.PROFILE_URL);
      isPremiumUser = BasicConstants.prefs!.getBool(BasicConstants.IS_PREMiUM_USER)!;
    });
    debugPrint('username: $userName');
  }

  @override
  Widget build(BuildContext context) {
    selectedCats = widget.selectedCats;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SvgPicture.asset('assets/images/appbar.svg', fit: BoxFit.cover),
        backgroundColor: mainTheme,
        elevation: 0,
        title: Text(
          "Darain Travels",
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                isPremiumUser? Image.asset("assets/images/verified.png",height: 30, width: 30, fit: BoxFit.fill,):const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '$userName',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.right,
                  ),
                ),
                InkWell(
                  child: imageUrl == null || imageUrl=="NA" ? const GFAvatar(
                    backgroundImage:
                    AssetImage('assets/images/user.png'),
                    shape: GFAvatarShape.circle,
                    size: 25,
                  ):
                  GFAvatar(
                    backgroundImage:
                    NetworkImage(imageUrl!),
                    shape: GFAvatarShape.circle,
                    size: 25,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SelectJobsScreen()));
                  },
                )
              ],
            ),
          ),
        ],
        bottom: TabBar(
          labelColor: mainTheme,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white,
          labelStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
          ),
          indicator:  const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Colors.white),
          controller: _tabController,
          tabs: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Tab(text: 'All Jobs'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Tab(text: 'Applied Jobs'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Tab(text: 'Saved Jobs'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AllJobs(selectedCats, widget.countryId, widget.stateId),
          AppliedJobScreen(),
          const SavedJobs(),
        ],
      ),
    );
  }
}
