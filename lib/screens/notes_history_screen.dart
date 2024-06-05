import 'package:darain_travels/models/notes_message_response.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../apiServices/apiService.dart';
import '../widgets/app_bar.dart';

class NotesHistoryScreen extends StatefulWidget{
  String appId;
  NotesHistoryScreen(this.appId,{super.key});

  @override
  State<NotesHistoryScreen> createState() => _NotesHistoryScreenState();
}

class _NotesHistoryScreenState extends State<NotesHistoryScreen> {
  bool notesLoading = false;
  NotesMessages? _notesMessages;
  List<Message>? _message;

  @override
  void initState() {
    getNotes(widget.appId);
    super.initState();
  }

  void getNotes(String appID)async{
    setState(() {
      notesLoading = true;
    });
    _notesMessages = await ApiService().getNotes(appID);
    if(_notesMessages!.statusCode==202){
      setState(() {
        _message = _notesMessages!.messages;
        notesLoading = false;
      });
    }else{
      print("Error due to ${_notesMessages!.statusCode}");
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
      body: notesLoading? const Center(child: CircularProgressIndicator()) : Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            decoration: BoxDecoration(
                border: Border.all(color: grey, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Notes History :",
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600),
                    maxLines: 4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/2,
                    child: ListView.builder(
                        itemCount: _message!.length,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.watch_later_outlined, size: 20),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${DateFormat('yyyy-MM-dd').format(_message![index].createdAt!)}, ${DateFormat("jm").format(_message![index].createdAt!)}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  " ->  ${_message![index].mess}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}