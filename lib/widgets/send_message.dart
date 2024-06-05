
import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'custom_shape.dart';

// ignore: must_be_immutable
class SentMessageScreen extends StatelessWidget {
  final String message,path;
  DateTime time;
  SentMessageScreen({
    Key? key,
    required this.message,
    required this.path,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat('dd-MM-yyyy');
    String formatDate = formatter.format(time);
    String formatTime = DateFormat('kk:mm a').format(time);
    print('Formatted Time: $formatDate, $formatTime');
    final messageTextGroup = Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: mainTheme.shade500,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 14),
                    ),
                    path==""? const SizedBox(): Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(1,2)
                            )
                          ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(path.toString().replaceAll("https://niftelhrms.com/messFiles/", ""), style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                  maxLines: 1,
                                ),
                              ),
                              // GFAvatar(
                              //   size: 25,
                              //   backgroundColor: Colors.grey[300],
                              //   child: Icon(Icons.download,size: 20,color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        formatTime,
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 12),
                      ),
                    )
                  ],
                )
              ),
            ),
            CustomPaint(painter: CustomShape(mainTheme.shade500)),
          ],
        ));

    return Padding(
      padding: const EdgeInsets.only(right: 18.0, left: 50, top: 15, bottom: 5),
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