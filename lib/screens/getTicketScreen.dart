import 'package:darain_travels/apiServices/apiService.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/ticketModel.dart';
import 'package:darain_travels/screens/ticketDetailsScreen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/app_bar.dart';

class GetTicketScreen extends StatefulWidget {
  const GetTicketScreen({super.key});

  @override
  State<GetTicketScreen> createState() => _GetTicketScreenState();
}

class _GetTicketScreenState extends State<GetTicketScreen> {
  TicketModel? _ticketModel;
  String? userId;
  List<TicketList>? _ticketList;
  bool loading = false;
  int status = 0;

  @override
  void initState() {
    initiateApi();
    super.initState();
  }

  void initiateApi() async {
    setState(() {
      loading = true;
    });
    userId = BasicConstants.prefs?.getString(BasicConstants.USER_ID);
    _ticketModel = await ApiService().getTickets(userId!);
    _ticketList = _ticketModel!.data;
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
      body: SingleChildScrollView(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : _ticketList!.isEmpty
                ? Center(
                    child: Text(
                    'No Tickets Available...!',
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ))
                : Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        margin: const EdgeInsets.all(8),
                        child: ListView.builder(
                            shrinkWrap: false,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _ticketList!.length,
                            itemBuilder: (context, index) {
                              status = _ticketList![index].status;
                              print("Status is: $status");
                              return InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10)),
                                        shape: BoxShape.rectangle,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(1, 2))
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  _ticketList![index].subject,
                                                  style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              GFButton(
                                                  size: 30,
                                                  shape: GFButtonShape.pills,
                                                  icon: status == 0
                                                      ? const Icon(
                                                          Icons.waving_hand,
                                                          color: Colors.white,
                                                    size: 15,
                                                        )
                                                      : status == 1
                                                          ? const Icon(
                                                              Icons.info_rounded,
                                                              color: Colors.white,
                                                    size: 15,
                                                            )
                                                          : const Icon(
                                                              Icons.check_circle,
                                                              color: Colors.white,
                                                    size: 15,
                                                            ),
                                                  color: status == 0
                                                      ? mainTheme
                                                      : status == 1
                                                          ? Colors.orange
                                                          : Colors.green,
                                                  text: status == 0
                                                      ? "Raised"
                                                      : status == 1
                                                          ? "Opened"
                                                          : "Solved",
                                                  textStyle: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                  onPressed: () {})
                                            ],
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            height: 1,
                                            thickness: 1,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            _ticketList![index].desc,
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TicketDetailsScreen(_ticketList!, index)));
                                },
                              );
                            }),
                      )
                    ],
                  ),
      ),
    );
  }
}
