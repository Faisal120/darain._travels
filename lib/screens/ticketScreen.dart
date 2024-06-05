import 'dart:convert';
import 'package:darain_travels/apiServices/apiConstants.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/screens/getTicketScreen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:darain_travels/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart'as http;

class TicketScreen extends StatefulWidget{
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {

  TextEditingController subjectController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String? userId;
  bool loading = false;

  @override
  void initState() {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Submit a ticket', style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Colors.black,
              ),),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                child: Text("Subject * (विषय)",
                    style:
                    GoogleFonts.poppins(
                        fontSize: 14, color: mainTheme,
                    fontWeight: FontWeight.w500,
                    )),
              ),

              SizedBox(
                height: 60,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w500),
                    textAlignVertical: TextAlignVertical.center,
                    controller: subjectController,
                    decoration: const InputDecoration(
                      hintText: "Subject",
                      hintStyle: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: mainTheme, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide:
                          BorderSide(color: mainTheme, width: 1)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.grey, width: 1)),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              SizedBox(
                width: double.infinity,
                child: Text("Description * (विवरण)",
                    style:
                    GoogleFonts.poppins(fontSize: 14, color: mainTheme, fontWeight: FontWeight.w500 )),
              ),

              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: descController,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: mainTheme, width: 1)),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: mainTheme, width: 1)),
                      disabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.grey, width: 1)),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Row(
                children: [
                  const Icon(Icons.attachment_rounded, size: 24, color: mainTheme,),
                  const SizedBox(
                    width: 8,
                  ),
                  Text("Attach file", style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                  ),)
                ],
              ),

              const SizedBox(
                height: 16,
              ),

              SizedBox(
                height: 45,
                child: loading? const Center(
                  child: CircularProgressIndicator(),
                ) :GFButton(
                  shape: GFButtonShape.standard,
                  color: Colors.green,
                  fullWidthButton: true,
                  text: 'Submit',
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                  onPressed: () {
                    print('${subjectController.text.toString()}, ${descController.text.toString()}');
                    setState(() {
                      createTicket(subjectController.text.toString(), descController.text.toString(), context);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createTicket(String subject, String desc, BuildContext context) async{
    userId = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
    loading = true;
    try{
      var url = Uri.parse(ApiConstants.CREATE_TICKET);
      var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type':'application/json; charset=UTF-8'
          },
          body: json.encode({
            'user_id':userId,
            'desc':desc,
            'subject':subject
          })
      );
      if(response.statusCode==201){
        var res = json.decode(response.body);
        print("Ticket Created $res");
        GFToast.showToast("${res['message']}", context, toastPosition: GFToastPosition.BOTTOM);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const GetTicketScreen()));
        setState(() {
          loading = false;
        });
        return res;
      }else{
        print("Soemthing went wrong! ${response.body}");
        setState(() {
          loading = false;
        });
      }
    }catch(e){
      print(e);
      setState(() {
        loading = false;
      });
    }
  }
}