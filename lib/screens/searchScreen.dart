import 'package:darain_travels/screens/feature_country_job_screen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:darain_travels/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apiServices/apiService.dart';
import '../apiServices/basicConstants.dart';
import '../models/allCategories.dart';
import '../models/getCountriesModel.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController? designationController, locationController;
  String? userID, selectedDesig;
  int? selectedLocation;
  AllCategories? _allCategories;
  List<Datum> categoryList = [];
  GetCountriesModel? _getCountriesModel;
  List<AllCountryList>? _countryList;

  // List<String> suggestons = ["USA", "UK", "Uganda", "Uruguay", "United Arab Emirates"];

  @override
  void initState() {
    super.initState();
    designationController= TextEditingController();
    locationController = TextEditingController();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      BasicConstants.prefs = sp;
      userID = sp.getString(BasicConstants.USER_ID);
      setState(() {
        getData();
      });
    });
  }

  void getData() async {
    _allCategories = (await ApiService().allCats())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    categoryList = _allCategories!.data;
    // suggestons.addAll(categoryList)
    print("Category List: $categoryList");
    _getCountriesModel = await ApiService().getCountryList();
    _countryList = _getCountriesModel!.data;
    print("Country Listsss $_countryList}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: const Text(''),
        backButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 24,
            ),
            Text(
              "Search Jobs",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              "Tell us your search criteria & we'll show you most relevant jobs",
              style: GoogleFonts.poppins(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            RawAutocomplete(
              onSelected: (Datum elm) {
                print("Data Elem ${elm.catName}");
              },

              optionsBuilder: (TextEditingValue textValue) {
                if (textValue.text == '') {
                  return const Iterable<Datum>.empty();
                } else {
                  List<Datum> matches = [];
                  matches.addAll(categoryList);

                  matches.retainWhere((element) {
                    return element.catName
                        .toLowerCase()
                        .contains(textValue.text.toLowerCase());
                  });
                  return matches;
                }
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                print("Controller value ${textEditingController.text}");
                  designationController = textEditingController;
                // textEditingController = TextEditingController(text: selectedDesig );
                return TextField(
                  onChanged: (value) {},
                  style: GoogleFonts.poppins(color: Colors.black),
                  controller: designationController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: "Enter key skills, Designation, Companies",
                    labelStyle:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 14),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                );
              },
              optionsViewBuilder: (BuildContext context,
                  void Function(Datum) onSelected, Iterable<Datum> options) {
                return Material(
                    child: SizedBox(
                        height: 200,
                        child: SingleChildScrollView(
                            child: Column(
                          children: options.map((opt) {
                            return InkWell(
                                onTap: () {
                                  onSelected(opt);
                                  selectedDesig = opt.catName;
                                  setState(() {
                                    designationController?.text=opt.catName;
                                  });
                                  print("selected ${opt.catName}");
                                },
                                child: Container(
                                    padding: EdgeInsets.only(right: 60),
                                    child: Card(
                                        child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(10),
                                      child: Text(opt.catName),
                                    ))));
                          }).toList(),
                        ))));
              },
            ),
            SizedBox(
              height: 16,
            ),
            RawAutocomplete(
              onSelected: (AllCountryList elm) {
                print("sel ${elm.countryName}");
              },
              optionsBuilder: (TextEditingValue countryTextValue) {
                if (countryTextValue.text == '') {
                  return const Iterable<AllCountryList>.empty();
                } else {
                  List<AllCountryList> countryMatches = [];
                  countryMatches.addAll(_countryList!);

                  countryMatches.retainWhere((element) {
                    return element.countryName
                        .toLowerCase()
                        .contains(countryTextValue.text.toLowerCase());
                  });
                  return countryMatches;
                }
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController countryController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                  locationController = countryController;
                // textEditingController = TextEditingController(text: selectedDesig );
                return TextField(
                  onChanged: (value) {
                  },
                  style: GoogleFonts.poppins(color: Colors.black),
                  controller: locationController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: "Enter Location",
                    labelStyle:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 14),
                  ),
                );
              },
              optionsViewBuilder: (BuildContext context,
                  void Function(AllCountryList) onCountrySelected,
                  Iterable<AllCountryList> countryOptions) {
                return Material(
                    child: SizedBox(
                        height: 200,
                        child: SingleChildScrollView(
                            child: Column(
                          children: countryOptions.map((opti) {
                            return InkWell(
                                onTap: () {
                                  onCountrySelected(opti);
                                  print("Selected Location ${opti.countryName}");
                                  setState(() {
                                    locationController?.text = opti.countryName;
                                    selectedLocation = int.parse(opti.countryId);
                                  });
                                },
                                child: Container(
                                    padding: EdgeInsets.only(right: 60),
                                    child: Card(
                                        child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(10),
                                      child: Text(opti.countryName),
                                    ))));
                          }).toList(),
                        ))));
              },
            ),
            SizedBox(
              height: 32,
            ),
            GFButton(
                color: mainTheme.shade600,
                buttonBoxShadow: true,
                textColor: Colors.white,
                text: "Search Jobs",
                textStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                fullWidthButton: true,
                onPressed: () {
                  if (designationController!.text.isEmpty ||
                      locationController!.text.isEmpty) {
                    GFToast.showToast("Both fields are necessary!", context,
                        toastPosition: GFToastPosition.BOTTOM);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FeaturedCountryJobs(selectedLocation, userID, selectedDesig)));
                  }
                })
          ],
        ),
      ),
    );
  }
}
