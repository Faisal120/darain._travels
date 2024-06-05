import 'dart:convert';
import 'dart:io';

import 'package:darain_travels/apiServices/baseApiServices.dart';
import 'package:darain_travels/data/appException.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices extends BaseApiServices{
  @override
  Future getApiResponse(String url) async {
    dynamic responseJson;
    try{
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));
    } on SocketException{
      throw FetchDataException('No Internet Connection!');
    }
    return responseJson;
  }

  @override
  Future postApiResponse(String url) {
    // TODO: implement postApiResponse
    throw UnimplementedError();
  }

  dynamic returnResponse(http.Response response){
    switch(response.statusCode){
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      default :
        throw FetchDataException('Error while communicating with server' +
            'with status code' +
            response.statusCode.toString());
    }
  }
}