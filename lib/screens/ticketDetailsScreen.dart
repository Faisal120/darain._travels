import 'dart:io';

import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/models/ticketDetailsModel.dart';
import 'package:darain_travels/models/ticketModel.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:darain_travels/widgets/app_bar.dart';
import 'package:darain_travels/widgets/recieved_messages.dart';
import 'package:darain_travels/widgets/send_message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/components/text_field/gf_text_field.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class TicketDetailsScreen extends StatefulWidget {
  List<TicketList> ticketList;
  int index;

  TicketDetailsScreen(this.ticketList, this.index, {super.key});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  TextEditingController messageController = TextEditingController();
  TicketDetailsModel? _ticketDetailsModel;
  List<Chat>? _ticketChats;
  bool loading = false;
  File? file;
  bool imageSelected= false;
  String chatRealTime = "";

  @override
  void initState() {
    super.initState();
    initiateApi();
  }

  void initiateApi() async {
    setState(() {
      loading = true;
    });
    _ticketDetailsModel = await ApiService()
        .getTicketChat(context, widget.ticketList[widget.index].id);
    _ticketChats = _ticketDetailsModel!.chats;
    print("Chats are: $_ticketChats");
    setState(() {
      loading = false;
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
      body: Stack(
        alignment: Alignment.bottomCenter,
          children: [
            loading ? const GFLoader(
              loaderColorOne: mainTheme,
              loaderColorTwo: Colors.grey,
              loaderColorThree: mainTheme,
              type: GFLoaderType.circle,
              loaderstrokeWidth: 40,
              size: 35
            )
            : SingleChildScrollView(
              child: Container(
                child: _ticketChats!.isEmpty
                    ? Center(
                        child: Text(
                          "No chats available...",
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        )
                      )
                    : Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 170),
                          child: ListView.builder(
                            itemCount: _ticketChats!.length,
                            itemBuilder: (BuildContext context, int index) {;
                              print("Time is: $chatRealTime");
                              return _ticketDetailsModel!
                                  .chats[index].senderId == "Admin"
                                  ? ReceivedMessageScreen(
                                  message: _ticketDetailsModel!
                                      .chats[index].mess, path: _ticketChats![index].filePath, time: _ticketChats![index].createdAt, )
                                  : SentMessageScreen(
                                  message: _ticketChats![index].mess, path: _ticketChats![index].filePath, time: _ticketChats![index].createdAt, );
                            },
                          ),
                        ),
                      ),
              ),
            ),
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: Container(
            //     color: Colors.white,
            //     width: MediaQuery.of(context).size.width,
            //     child: Padding(
            //       padding: const EdgeInsets.all(16.0),
            //       child: Text(
            //         "Ticket Related to ${widget.ticketList[widget.index].subject}",
            //         style: GoogleFonts.poppins(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w600,
            //             color: Colors.black),
            //       ),
            //     ),
            //   ),
            // ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      InkWell(
                          child: const Icon(Icons.attach_file_sharp, color: mainTheme, size: 20,),
                      onTap: (){
                           uploadFile();
                      },),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GFTextField(
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                  hintText: "Enter your message",
                                  hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
                              controller: messageController,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            imageSelected? Text("1 File Selected", style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                            ),):SizedBox.shrink()
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                          child: const Icon(Icons.send, color: mainTheme, size: 20),
                      onTap: () async{
                        setState(() {
                            });
                        var message = messageController.text.toString();
                        messageController.clear();
                        // SentMessageScreen(message: messageController.text.toString(), path: '', time: null,);
                       imageSelected ? await ApiService().postMultipartTicketReply(context, _ticketDetailsModel!.ticketDetails.id.toString(), message.isEmpty? '': message, file!, ) : await ApiService().postTicketReply(context, _ticketDetailsModel!.ticketDetails.id.toString(), message);
                        setState(() {
                          initiateApi();
                          imageSelected = false;
                            });
                      },),
                    ],
                  ),
                ),
              ),
            ),
      ]),
    );
  }

  Future uploadFile() async{
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      file = File(filePickerResult.files.single.path ?? " ");
      String fileName = file!.path.split('/').last;
      print('fileName: $fileName');
      String path = file!.path;
      print('FilePath $path');
      setState(() {
        imageSelected = true;
      });
  }
  // Future _openGallery() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (image == null) return;
  //     final imageTemp = File(image.path);
  //     setState(() => this.image = imageTemp);
  //     print('path ${this.image.toString()}');
  //     setState(() {
  //       imageSelected=true;
  //     });
  //   } on PlatformException catch (exc) {
  //     GFToast.showToast("Failed to pick image from gallery! $exc", context,
  //         toastPosition: GFToastPosition.BOTTOM);
  //   }
  }
}
