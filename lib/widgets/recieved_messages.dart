import 'dart:math' as math; // import this

import 'package:darain_travels/utils/myColors.dart';
import 'package:darain_travels/widgets/custom_shape.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class ReceivedMessageScreen extends StatefulWidget {
  final String message, path;
  DateTime time;

  ReceivedMessageScreen({
    Key? key,
    required this.message,
    required this.path,
    required this.time,
  }) : super(key: key);

  @override
  State<ReceivedMessageScreen> createState() => _ReceivedMessageScreenState();
}

class _ReceivedMessageScreenState extends State<ReceivedMessageScreen> {
  String progressValue = "0";
  bool downloadStarted = false;

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat('dd-MM-yyyy');
    String formatDate = formatter.format(widget.time);
    String formatTime = DateFormat('kk:mm a').format(widget.time);
    print('Formatted Time: $formatDate, $formatTime');

    final messageTextGroup = Flexible(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: CustomPaint(
            painter: CustomShape(Colors.grey[300]!),
          ),
        ),
        Flexible(
          child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message,
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 14),
                  ),
                  widget.path == ""
                      ? const SizedBox()
                      : InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(1, 2))
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        widget.path.toString().replaceAll(
                                            "https://niftelhrms.com/public/messFiles/",
                                            ""),
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    downloadStarted
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0),
                                            child: SizedBox(
                                              width: 30,
                                              child: Center(
                                                child: GFProgressBar(
                                                  progressBarColor: mainTheme,
                                                  backgroundColor: Colors.grey,
                                                  percentage: 0.9,
                                                  radius: 40,
                                                  width: 30,
                                                  animation: true,
                                                  circleWidth: 8,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 4),
                                                  type: GFProgressType.circular,
                                                  child: Text(progressValue, style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w500,
                                                  ),),
                                                ),
                                              ),
                                            ),
                                          )
                                        : GFAvatar(
                                            size: 30,
                                            backgroundColor: Colors.grey[300],
                                            child: const Icon(Icons.download,
                                                size: 20, color: Colors.black))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            Map<Permission, PermissionStatus> statuses = await [
                              Permission.storage,
                              //add more permission to request here.
                            ].request();
                            setState(() {
                              downloadStarted = true;
                            });
                            if (statuses[Permission.storage]!.isGranted) {
                              var dir = await DownloadsPathProvider
                                  .downloadsDirectory;
                              if (dir != null) {
                                String savename = widget.path
                                    .toString()
                                    .replaceAll(
                                        "https://niftelhrms.com/public/messFiles/",
                                        "");
                                String savePath = dir.path + "/$savename";
                                print(savePath);
                                //output:  /storage/emulated/0/Download/banner.png

                                try {
                                  await Dio().download(widget.path, savePath,
                                      onReceiveProgress: (received, total) {
                                    if (total != -1) {
                                      print(
                                          "${(received / total * 100).toStringAsFixed(0)}%");
                                      progressValue =
                                          "${(received / total * 100).toStringAsFixed(0)}%";
                                      //you can build progressbar feature too
                                    }
                                  });
                                  GFToast.showToast(
                                      "${widget.path.toString().replaceAll("https://niftelhrms.com/public/messFiles/", "")} downloaded successfully!",
                                      context,
                                      toastPosition: GFToastPosition.BOTTOM);
                                  print("File is saved to download folder.");
                                  setState(() {
                                    downloadStarted = false;
                                  });
                                } on DioError catch (e) {
                                  print(e.message);
                                }
                              }
                            } else {
                              print("No permission to read and write.");
                            }
                          },
                        ),
                  const SizedBox(
                    height: 4,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "$formatTime",
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontSize: 12),
                    ),
                  )
                ],
              )),
        ),
      ],
    ));

    return Padding(
      padding: const EdgeInsets.only(right: 50.0, left: 18, top: 10, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const SizedBox(height: 30),
          messageTextGroup,
        ],
      ),
    );
  }
}
