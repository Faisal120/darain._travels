// ignore_for_file: use_build_context_synchronously

import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/verifyOtp.dart';
import 'package:darain_travels/screens/dashboardScreen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../apiServices/apiService.dart';
import '../models/allCategories.dart';
import 'main_screen.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  AllCategories? _allCategories;
  List<String> selectedItems = [];
  List<Datum> data = [];
  String user_id = '';
  VerifyOtp? _selectedCatsRes;
  bool loading = false;
  List<Datum> searchList = [];
  var items = <String>[];
  var index;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCategories();
    _initializeStates();
  }

  void _getCategories() async {
    _allCategories = (await ApiService().allCats())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    data = _allCategories!.data;
    searchList = data;
    print("list is: $searchList");
  }

  void _initializeStates() async {
    user_id = BasicConstants.prefs!.getString(BasicConstants.USER_ID)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Category",
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: mainTheme,
                  margin: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, top: 16, bottom: 8),
                        child: Text(
                          "What work do you do?\n(आप क्या काम करते हैं?)",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          onChanged: (value) {
                            filterSearchResults(value);
                          },
                          style: GoogleFonts.poppins(color: Colors.white),
                          controller: searchController,
                          decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle:
                                  GoogleFonts.poppins(color: Colors.white),
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.white),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1),
                              ),
                          ),
                        ),
                      ),
                      // GFSearchBar(
                      //   searchList: searchList,
                      //   searchBoxInputDecoration: const InputDecoration(
                      //     filled: true,
                      //     fillColor: Colors.white,
                      //     hintText: "Search here...",
                      //   ),
                      //   searchQueryBuilder: (query, item) {
                      //     return searchList
                      //         .where((element) =>
                      //         element.toLowerCase().contains(
                      //             query.toLowerCase()))
                      //         .toList();
                      //   },
                      //   overlaySearchListItemBuilder: (item) {
                      //     return Container(
                      //       color: mainTheme,
                      //       padding: const EdgeInsets.all(8),
                      //       child: Text(
                      //         item,
                      //         style: const TextStyle(fontSize: 14, color: Colors.white),
                      //       ),
                      //     );
                      //   },
                      //   onItemSelected: (item) {
                      //     setState(() {
                      //      print('items are: $item');
                      //     });
                      //   },
                      // ),
                      Container(
                        color: grey.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: searchList == null || searchList.isEmpty
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : GridView.count(
                                  crossAxisCount: 3,
                                  // itemCount: _allCategories!.data.length-1,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 0.6,
                                  children: List.generate(
                                      searchList.length,
                                      (index) => GestureDetector(
                                            child: InkWell(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: mainTheme.shade50,
                                                      border: Border.all(
                                                        color: searchList[index]
                                                                    .isSelected ==
                                                                true
                                                            ? mainTheme
                                                            : Colors
                                                                .transparent,
                                                        width: 2,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              24.0),
                                                      child: Image.network(
                                                          searchList[index].img,
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      "${searchList[index].catName}\n${searchList[index].catNameHindi}",
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  if (selectedItems.length <
                                                      4) {
                                                    if (selectedItems.contains(
                                                        searchList[index].catId)) {
                                                      searchList[index]
                                                          .isSelected = false;
                                                      selectedItems.remove(
                                                          searchList[index].catId);
                                                    } else {
                                                      searchList[index]
                                                          .isSelected = true;
                                                      selectedItems.add(
                                                          searchList[index].catId);
                                                    }
                                                    print(
                                                        'list items = $index');
                                                  } else {
                                                    if (selectedItems.contains(
                                                        searchList[index].catId)) {
                                                      searchList[index]
                                                          .isSelected = false;
                                                      selectedItems.remove(
                                                          searchList[index].catId);
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
                                            ),
                                          )),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 100,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Selected categories (${selectedItems.length}/4)",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : GFButton(
                          shape: GFButtonShape.standard,
                          color: mainTheme,
                          text: 'Next',
                          textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                          onPressed: () async {
                           updateCats();
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updateCats() async{
    if (selectedItems.isNotEmpty) {
      setState(() {
        loading = true;
      });
      Future.delayed(const Duration(seconds: 2));
      _selectedCatsRes = await ApiService().selectCat(context, user_id, selectedItems);
      if (_selectedCatsRes!.statusCode == 200) {
        GFToast.showToast(
            'Category Updated Successfully!', context,
            toastPosition: GFToastPosition.BOTTOM);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                MainScreen()), (Route route)=> false);
        setState(() {
          loading = false;
        });
      } else {
        GFToast.showToast(
            'Kuch to gadbad hai daya!!${_selectedCatsRes!.statusMessage}',
            context,
            toastPosition: GFToastPosition.BOTTOM);
        setState(() {
          loading = false;
        });
      }
    } else {
      GFToast.showToast('Select at least 1 category', context, toastPosition: GFToastPosition.BOTTOM);
    }
  }

  void filterSearchResults(String value) {
    setState(() {
      searchList = data
          .where((item){
            bool items;
            if(items = item.catName.contains(value)) {
              return items;
            } else if(items = item.catName.contains(value.toLowerCase())){
              return items;
            } else if(items = item.catName.contains(value.toUpperCase())){
              return items;
            }
            return items;
      }).toList();
    });
  }
}
