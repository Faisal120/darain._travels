import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:darain_travels/utils/upi_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PaymentDemo extends StatefulWidget{
  @override
  State<PaymentDemo> createState() => _PaymentDemoState();
}

class _PaymentDemoState extends State<PaymentDemo> {
  String body = "";
  String callback = "flutterDemoApp";
  String checksum = "";

  Map<String, String> headers = {};
  Map<String, String> pgHeaders = {"Content-Type": "application/json"};
  List<String> apiList = <String>['Container', 'PG'];
  List<String> environmentList = <String>['UAT', 'UAT_SIM', 'PRODUCTION'];
  String apiEndPoint = "/pg/v1/pay";
  bool enableLogs = true;
  Object? result;
  String dropdownValue = 'PG';
  String environmentValue = 'UAT_SIM';
  String appId = "";
  String merchantId = "";
  String packageName = "com.phonepe.simulator";

  void startTransaction() {
    // dropdownValue == 'Container'
    //     ? startContainerTransaction()
    //     : startPGTransaction();
  }

  void initPhonePeSdk() {
    getCheckSum();
    PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLogs)
        .then((isInitialized) => {
      setState(() {

        result = 'PhonePe SDK Initialized - $isInitialized';
      })
    })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  String getCheckSum(){
    Map<String, dynamic> jsonPayload =
    {
      "merchantId": "M1YSZIR034JK",
      "merchantTransactionId": "transaction_1",
      "merchantUserId": "123456",
      "amount": 10,
      "mobileNumber": "8736051739",
      "callbackUrl": "https://webhook.site/callback-url",
      "paymentInstrument": {
        "type": "UPI_INTENT",
        "targetApp": "com.phonepe.app"
      },
      "deviceContext": {
        "deviceOS": "ANDROID"
      }
    };

    var key = "021be1b1-29e3-4e3f-89ef-430882b1cd56";

    String jsonString = json.encode(jsonPayload);
    Uint8List bytes = Uint8List.fromList(utf8.encode(jsonString));
    String base64Payload = base64.encode(bytes);

    String checksum = Hmac(sha256, key.codeUnits).convert(base64Payload.codeUnits).toString();
    checksum += "###1";
    print("Base64 Encoded Payload: $checksum");

    startPGTransaction(checksum, base64Payload);

    return base64Payload;
  }

  void isPhonePeInstalled() {
    PhonePePaymentSdk.isPhonePeInstalled()
        .then((isPhonePeInstalled) => {
      setState(() {
        result = 'PhonePe Installed - $isPhonePeInstalled';
      })
    })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void isGpayInstalled() {
    PhonePePaymentSdk.isGPayAppInstalled()
        .then((isGpayInstalled) => {
      setState(() {
        result = 'GPay Installed - $isGpayInstalled';
      })
    })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void isPaytmInstalled() {
    PhonePePaymentSdk.isPaytmAppInstalled()
        .then((isPaytmInstalled) => {
      setState(() {
        result = 'Paytm Installed - $isPaytmInstalled';
      })
    })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void getPackageSignatureForAndroid() {
    if (Platform.isAndroid) {
      PhonePePaymentSdk.getPackageSignatureForAndroid()
          .then((packageSignature) => {
        setState(() {
          result = 'getPackageSignatureForAndroid - $packageSignature';
        })
      })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    }
  }

  void getInstalledUpiAppsForAndroid() {
    if (Platform.isAndroid) {
      PhonePePaymentSdk.getInstalledUpiAppsForAndroid()
          .then((apps) => {
        setState(() {
          if (apps != null) {
            Iterable l = json.decode(apps);
            List<UPIApp> upiApps = List<UPIApp>.from(
                l.map((model) => UPIApp.fromJson(model)));
            String appString = '';
            for (var element in upiApps) {
              appString +=
              "${element.applicationName} ${element.version} ${element.packageName}";
            }
            result = 'Installed Upi Apps - $appString';
          } else {
            result = 'Installed Upi Apps - 0';
          }
        })
      })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    }
  }

  void startPGTransaction(String checksumm, String jsonPayload) async {
    try {
      PhonePePaymentSdk.startPGTransaction(
          jsonPayload, callback, checksumm, pgHeaders, apiEndPoint, packageName)
          .then((response) => {
        setState(() {
          if (response != null) {
            String status = response['status'].toString();
            String error = response['error'].toString();
            if (status == 'SUCCESS') {
              result = "Flow Completed - Status: Success!";
            } else {
              result =
              "Flow Completed - Status: $status and Error: $error";
            }
          } else {
            result = "Flow Incomplete";
          }
        })
      })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    } catch (error) {
      handleError(error);
    }
  }

  void handleError(error) {
    setState(() {
      if (error is Exception) {
        result = error.toString();
      } else {
        result = {"error": error};
      }
    });
  }

  void startContainerTransaction() async {
    try {
      PhonePePaymentSdk.startContainerTransaction(
          body, callback, checksum, headers, apiEndPoint)
          .then((response) => {
        setState(() {
          if (response != null) {
            String status = response['status'].toString();
            String error = response['error'].toString();
            if (status == 'SUCCESS') {
              result = "Flow Completed - Status: Success!";
            } else {
              result =
              "Flow Completed - Status: $status and Error: $error";
            }
          } else {
            result = "Flow Incomplete";
          }
        })
      })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    } catch (error) {
      result = {"error": error};
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Merchant Demo App'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(7),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Merchant Id',
                  ),
                  onChanged: (text) {
                    merchantId = text;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'App Id',
                  ),
                  onChanged: (text) {
                    appId = text;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Text('Select the environment'),
                    DropdownButton<String>(
                      value: environmentValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          environmentValue = value!;
                          if (environmentValue == 'PRODUCTION') {
                            packageName = "com.phonepe.app";
                          } else if (environmentValue == 'UAT') {
                            packageName = "com.phonepe.app.preprod";
                          } else if (environmentValue == 'UAT_SIM') {
                            packageName = "com.phonepe.simulator";
                          }
                        });
                      },
                      items: environmentList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ],
                ),
                Visibility(
                    maintainSize: false,
                    maintainAnimation: false,
                    maintainState: false,
                    visible: Platform.isAndroid,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 10),
                          Text("Package Name: $packageName"),
                        ])),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Checkbox(
                        value: enableLogs,
                        onChanged: (state) {
                          setState(() {
                            enableLogs = state!;
                          });
                        }),
                    const Text("Enable Logs")
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Warning: Init SDK is Mandatory to use all the functionalities*',
                  style: TextStyle(color: Colors.red),
                ),

                ElevatedButton(
                    onPressed: initPhonePeSdk, child: const Text('INIT SDK')),
                const SizedBox(width: 5.0),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'body',
                  ),
                  onChanged: (text) {
                    body = text;
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'checksum',
                  ),
                  onChanged: (text) {
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Text('Select the transaction type'),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                          if (dropdownValue == 'PG') {
                            apiEndPoint = "/pg/v1/pay";
                          } else {
                            apiEndPoint = "/v4/debit";
                          }
                        });
                      },
                      items: apiList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ],
                ),
                ElevatedButton(
                    onPressed: startTransaction,
                    child: const Text('Start Transaction')),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: ElevatedButton(
                              onPressed: isPhonePeInstalled,
                              child: const Text('PhonePe App'))),
                      const SizedBox(width: 5.0),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: isGpayInstalled,
                              child: const Text('Gpay App'))),
                      const SizedBox(width: 5.0),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: isPaytmInstalled,
                              child: const Text('Paytm App'))),
                    ]),
                Visibility(
                    maintainSize: false,
                    maintainAnimation: false,
                    maintainState: false,
                    visible: Platform.isAndroid,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: getPackageSignatureForAndroid,
                                  child:
                                  const Text('Get Package Signature'))),
                          const SizedBox(width: 5.0),
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: getInstalledUpiAppsForAndroid,
                                  child: const Text('Get UPI Apps'))),
                          const SizedBox(width: 5.0),
                        ])),
                Text("Result: \n $result")
              ],
            ),
          ),
        ));
  }
}