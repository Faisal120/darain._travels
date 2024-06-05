import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';
import '../models/jobDetailsModel.dart';

class AppFunctionalities {
  shareItems(BuildContext context, List<JobList> jobDetails, int index) {
    Share.share(
        'Darain Travels | Gulf Jobs \n Stay updated with the latest Gulf job opportunities.\nDownload our app now. \n Link: https://daraintravels.in/app-download.html',
        subject: "Stay updated with the latest Gulf job opportunities"
    );
  }

}