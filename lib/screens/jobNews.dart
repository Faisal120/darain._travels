// ignore_for_file: use_build_context_synchronously, avoid_print, depend_on_referenced_packages

import 'dart:convert';
import 'package:darain_travels/utils/currencies.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:darain_travels/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class JobNews extends StatefulWidget {
  const JobNews({super.key});

  @override
  State<JobNews> createState() => _JobNewsState();

}

class _JobNewsState extends State<JobNews> {
  TextEditingController currencyController = TextEditingController();
  Map currencyData = {};

  // List<String>? currencies;
  String fromCurrency = 'AED';
  String toCurrency = 'INR';
  String result = "00.00";

  @override
  void initState() {
    // getRatesFromApi();
    super.initState();
  }

  // getRatesFromApi() async {
  //   String apiKey = 'LeNMNMpvqr6kdnMdYwOkGcGcaGmUlvjyVktk8mXZ';
  //   // selectedPrice.value = 0.00;
  //   var response = await http.get(Uri.parse(
  //       'https://api.currencyapi.com/v3/latest?apikey=$apiKey&base_currency='));
  //   var responseBody = json.decode(response.body);
  //   currencyData = responseBody['data'];
  //   currencies = currencyData.keys.cast<String>().toList();
  //   setState(() {});
  //   print('Currency Data : $currencies');
  // }

  _onFromChanged(String value) {
    setState(() {
      fromCurrency = value;
    });
  }

  _onToChanged(String value) {
    setState(() {
      toCurrency = "INR";
    });
  }

  Future<void> doConversion() async {
    String uri = "https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_T8FusPP07p7S8OPxZQGAN2UKssUYnZX57qsS7MAm&currencies=INR&base_currency=$fromCurrency";

    try {
      var response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        print('Body: $responseBody');

        if (responseBody.containsKey('data')) {
          var data = responseBody['data'];

          // Check if the response contains the target currency
          if (data.containsKey(toCurrency)) {
            setState(() {
              result = (double.parse(currencyController.text) *
                  data[toCurrency]).toString();
            });
            print("$toCurrency: ${data[toCurrency]}");
            print(result);
          } else {
            print("Target currency not found in response");
            GFToast.showToast("Target currency not found in response!", context, toastPosition: GFToastPosition.BOTTOM);
          }
        } else {
          print("No data found in response");
          GFToast.showToast("No data found in response!", context, toastPosition: GFToastPosition.BOTTOM);
        }
      } else {
        GFToast.showToast("Currency Not Found!", context, toastPosition: GFToastPosition.BOTTOM);
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Future<String> doConversion() async {
  //   // String uri = "https://api.currencyapi.com/v3/latest?apikey=LeNMNMpvqr6kdnMdYwOkGcGcaGmUlvjyVktk8mXZ&currencies=$toCurrency&base_currency=$fromCurrency";
  //   // String uri = "https://currency-converter5.p.rapidapi.com/currency/convert?format=json&from=$fromCurrency&to=$toCurrency&amount=${currencyController.text}";
  //   // String uri = "https://api.exchangerate.host/latest?base=$fromCurrency&symbols=INR";
  //   // String uri = "https://api.exchangerate.host/convert?from=$fromCurrency&to=INR";
  //   print("Current Currency $toCurrency, $fromCurrency");
  //   String uri  = "https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_T8FusPP07p7S8OPxZQGAN2UKssUYnZX57qsS7MAm&currencies=INR&base_currency=$fromCurrency";
  //   var response = await http.get(Uri.parse(uri));
  //   var responseBody = json.decode(response.body);
  //   print('Body: $responseBody');
  //   setState(() {
  //     result = (double.parse(currencyController.text) *
  //         (responseBody['data']['INR']))
  //         .toString();
  //     print("${responseBody['data']}");
  //   });
  //   print(result);
  //   return "";
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: const Text(''),
        backButton: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Convert your currency to any currency easily using Darain Currency Converter...',
                  style: GoogleFonts.poppins(
                    color: mainTheme,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDropDown(fromCurrency),
                      // currencyPickers(selectedFrom, selectedTo, switchCurrencies, changeSelected),
                      InkWell(
                        child: const Icon(Icons.compare_arrows_sharp,
                            size: 40, color: mainTheme),
                        onTap: () {
                          // swapCurrencies();
                        },
                      ),
                      _buildDropDown("INR"),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 24),
                  child: TextField(
                    onChanged: (String val) {
                      setState(() {
                        doConversion();
                      });
                    },
                    controller: currencyController,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "0.00",
                      hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: mainTheme,
                              width: 2
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: mainTheme, width: 2)),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: mainTheme.withOpacity(0.05),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 48),
                    child: Text(
                      '${currencyController.text.toString()} $fromCurrency = $result INR',
                      style: GoogleFonts.poppins(
                        color: mainTheme,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                // valueCounter(amount, selectedFrom, selectedTo, selectedPrice),
                // buttonsGrid(changeAmount, backspace),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropDown(String currencyCat) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
        border: Border.all(color: mainTheme, width: 2),
      ),
      width: 120,
      height: 80,
      child: Center(
        child: DropdownButton<String>(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          isExpanded: true,
          dropdownColor: Colors.white,
          // borderRadius: BorderRadius.circular(10),
          value: currencyCat,
          underline: const SizedBox(),
          items: currencies.map(
            (String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (String? value) {
            if (currencyCat == fromCurrency) {
              _onFromChanged(value!);
              doConversion();
            } else {
              _onToChanged(value!);
            }
          },
        ),
      ),
    );
  }

  void swapCurrencies() {
    setState(() {
      var temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
      doConversion();
    });
  }
}
