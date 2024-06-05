import 'package:darain_travels/models/dashboard_response.dart';
import 'package:darain_travels/models/employer_response.dart';
import 'package:darain_travels/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopEmployersScreen extends StatefulWidget {
  List<FeatureEmployer> employerList;
  TopEmployersScreen(this.employerList, {super.key});

  @override
  State<TopEmployersScreen> createState() => _TopEmployersScreenState();
}

class _TopEmployersScreenState extends State<TopEmployersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar(), title: const Text(""), backButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(8),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 80
              ),
                  itemCount: widget.employerList.length,
                  itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                        border: Border.all(color: Colors.grey, width: 1)
                    ),
                    child: Image.network("${widget.employerList[index].logo}"),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
