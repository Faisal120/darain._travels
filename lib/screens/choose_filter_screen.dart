// ignore_for_file: avoid_print

import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/get_state_model.dart';
import 'package:darain_travels/screens/allJobScreen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apiServices/apiService.dart';
import '../models/allCategories.dart';
import '../models/getCountriesModel.dart';

// ignore: must_be_immutable
class ChooseFilterScreen extends StatefulWidget {
  List<String> selectedCats;
  ChooseFilterScreen(this.selectedCats, {super.key});

  @override
  State<ChooseFilterScreen> createState() => _ChooseFilterScreenState();
}

class _ChooseFilterScreenState extends State<ChooseFilterScreen> {
  bool categories = true;
  bool location = false;
  bool state = false;
  bool countryClicked = false;
  AllCategories? _allCategories;
  List<Datum> categoryList = [];
  List<String> categoryList2 = [];
  GetCountriesModel? _getCountriesModel;
  List<AllCountryList>? _countryList;
  GetStateModel? _getStateModel;
  List<AllStateList>? _stateList;
  bool loading = false;
  List<String> selectedCats = [];
  int selectedCountry = 0;
  int selectedState = 0;

  @override
  void initState() {
    super.initState();
    initiateApi();
  }

  void initiateApi() async {
    loading = true;
    _allCategories = (await ApiService().allCats())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    categoryList = _allCategories!.data;
    print("Category List: $categoryList");
    loading = false;
    _getCountriesModel = await ApiService().getCountryList();
    _countryList = _getCountriesModel!.data;

    SharedPreferences.getInstance()
        .then((SharedPreferences sharedPreferences) async {
      BasicConstants.prefs = sharedPreferences;
      setState(() {
        // selectedCats = sharedPreferences.getStringList(BasicConstants.ALL_CATS)!;
        if(widget.selectedCats.isNotEmpty){
          selectedCats = widget.selectedCats;
        }
        print('All Sel Cats = $selectedCats');
        for(int i=0;i<selectedCats.length;i++){
              if (categoryList[i].catId.contains(selectedCats[i]))
              {
                categoryList[i].isSelected = true;
              } else {
                categoryList[i].isSelected = false;
                selectedCats.remove(selectedCats[i]);
              }
              print('list items in cat = $selectedCats');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: mainTheme,
          flexibleSpace:
              SvgPicture.asset('assets/images/appbar.svg', fit: BoxFit.cover),
          title: Text(
            "Filter",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: const BackButton(
            color: Colors.white,
          ),
          actions: [
            InkWell(
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(
                  Icons.check,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AllJobsScreen(selectedCats, selectedCountry.toString(), selectedState.toString())));
              },
            )
          ],
        ),
        body: loading
            ? Center(
                child: Dialog(
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: mainTheme),
                        const SizedBox(
                          height: 16,
                        ),
                        Text("Loading Data...", style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),)
                      ],
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: ListView(
                          children: <Widget>[
                            const SizedBox(
                              height: 4,
                            ),
                            InkWell(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: categories ? mainTheme : Colors.white,
                                ),
                                child: Center(
                                    child: Text(
                                  'Categories',
                                  style: GoogleFonts.poppins(
                                      color: categories
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                )),
                              ),
                              onTap: () {
                                setState(() {
                                  categories = true;
                                  location = false;
                                  state = false;
                                });
                              },
                            ),
                            InkWell(
                              child: Container(
                                height: 50,
                                color: location ? mainTheme : Colors.white,
                                child: Center(
                                    child: Text(
                                  'Country',
                                  style: GoogleFonts.poppins(
                                      color: location
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                )),
                              ),
                              onTap: () {
                                setState(() {
                                  location = true;
                                  categories = false;
                                  state = false;
                                });
                              },
                            ),
                            countryClicked?InkWell(
                              child: Container(
                                height: 50,
                                color: state ? mainTheme : Colors.white,
                                child: Center(
                                    child: Text(
                                      'State',
                                      style: GoogleFonts.poppins(
                                          color: state
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    )),
                              ),
                              onTap: () {
                                setState(() {
                                  location = false;
                                  categories = false;
                                  state = true;
                                });
                              },
                            ):const SizedBox(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      categories
                          ? Expanded(
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView.builder(
                                      shrinkWrap: false,
                                      itemCount: _allCategories!.data.length,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          child: Center(
                                              child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            decoration: BoxDecoration(
                                                color: categoryList[index]
                                                            .isSelected!
                                                    ? mainTheme
                                                    : Colors.white),
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Center(
                                              child: Text(
                                                _allCategories!
                                                    .data[index].catName,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: categoryList[index]
                                                                .isSelected ==
                                                            true
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                            ),
                                          )),
                                          onTap: () {
                                            setState(() {
                                              if (selectedCats.length < 4) {
                                                if (selectedCats.contains(
                                                    categoryList[index]
                                                        .catId)) {
                                                  categoryList[index]
                                                      .isSelected = false;
                                                  selectedCats.remove(
                                                      categoryList[index]
                                                          .catId);
                                                } else {
                                                  categoryList[index]
                                                      .isSelected = true;
                                                  selectedCats.add(
                                                      categoryList[index]
                                                          .catId);
                                                }
                                                print(
                                                    'list items = $selectedCats');
                                              } else {
                                                if (selectedCats.contains(
                                                    categoryList[index]
                                                        .catId)) {
                                                  categoryList[index]
                                                      .isSelected = false;
                                                  selectedCats.remove(
                                                      categoryList[index]
                                                          .catId);
                                                } else {
                                                  GFToast.showToast(
                                                      'Maximum Categories are selected',
                                                      context,
                                                      toastPosition:
                                                          GFToastPosition
                                                              .BOTTOM);
                                                }
                                              }
                                            });
                                          },
                                        );
                                      })),
                            )
                          : location ? Expanded(
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView.builder(
                                      shrinkWrap: false,
                                      itemCount: _countryList!.length,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () async {
                                            setState(() {
                                              loading = true;
                                              countryClicked = true;
                                            });
                                            _getStateModel = await ApiService().getStateList(_countryList![index].id);
                                            setState(() {
                                              selectedCountry = _countryList![index].id;
                                              _stateList = _getStateModel!.data;
                                              print("Selected Country $selectedCountry, $_stateList");
                                              loading = false;
                                            });
                                          },
                                          child: Center(
                                              child: Container(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                color: selectedCountry == _countryList![index].id
                                                    ? mainTheme
                                                    : Colors.white),
                                            child: Center(
                                              child: Text(
                                                _countryList![index].countryName,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: selectedCountry == _countryList![index].id
                                                        ? Colors.white
                                                        : Colors.black
                                                ),
                                              ),
                                            ),
                                          )),
                                        );
                                      })),
                            )
                          : Expanded(
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                                shrinkWrap: false,
                                itemCount: _stateList!.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedState = _stateList![index].id!;
                                        print("Selected State $selectedState");
                                      });
                                    },
                                    child: Center(
                                        child: Container(
                                          height: 50,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width,
                                          decoration: BoxDecoration(
                                              color: selectedState == _stateList![index].id
                                                  ? mainTheme
                                                  : Colors.white),
                                          child: Center(
                                            child: Text(
                                              _stateList![index].state!,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: selectedState == _stateList![index].id
                                                      ? Colors.white
                                                      : Colors.black
                                              ),
                                            ),
                                          ),
                                        )),
                                  );
                                })),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
