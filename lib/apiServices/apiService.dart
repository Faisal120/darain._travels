// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_print, dead_code

import 'dart:convert';
import 'dart:io';

import 'package:darain_travels/apiServices/apiConstants.dart';
import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/models/allCategories.dart';
import 'package:darain_travels/models/apply_job_model.dart';
import 'package:darain_travels/models/banner_response.dart';
import 'package:darain_travels/models/employer_response.dart';
import 'package:darain_travels/models/getCountriesModel.dart';
import 'package:darain_travels/models/getFeaturedCountry.dart';
import 'package:darain_travels/models/get_state_model.dart';
import 'package:darain_travels/models/plan_validity_response.dart';
import 'package:darain_travels/models/registerUser.dart';
import 'package:darain_travels/models/save_job_model.dart';
import 'package:darain_travels/models/subscription_plans.dart';
import 'package:darain_travels/models/updateProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;

import '../models/dashboard_response.dart';
import '../models/getProfile.dart';
import '../models/jobDetailsModel.dart';
import '../models/notes_message_response.dart';
import '../models/notification_model.dart';
import '../models/offer_res.dart';
import '../models/sendOtpRes.dart';
import '../models/ticketDetailsModel.dart';
import '../models/ticketModel.dart';
import '../models/verifyOtp.dart';

class ApiService extends GetConnect {
  bool loading = false;

  Future<AllCategories?> allCats() async {
    try {
      var url = Uri.parse(ApiConstants.CATEGORIES);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        AllCategories _allCats = allCategoriesFromJson(response.body);
        return _allCats;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<SendOtpRes?> sendOtp(
      String countryCode, String mobile, BuildContext context) async {
    try {
      var url = Uri.parse(ApiConstants.SEND_OTP);
      var response = await http.post(
        url,
        body: jsonEncode(<String, String>{
          'mobile': mobile,
          'c_code': countryCode,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        SendOtpRes _sendOtp = sendOtpResFromJson(response.body);
        print('Status code id: ${response.body}');
        GFToast.showToast(_sendOtp.statusMessage, context,
            toastPosition: GFToastPosition.BOTTOM);
        return _sendOtp;
      } else {
        print('something went wrong');
        GFToast.showToast("Something went wrong!", context,
            toastPosition: GFToastPosition.BOTTOM);
      }
    } catch (exc) {
      print(exc);
    }
    return null;
  }

  Future<VerifyOtp?> verifyotp(
      String mobile, String otp, BuildContext context, String fcmToken) async {
    VerifyOtp? _verifyOtp;
    print('Mobile : $mobile, Otp: $otp, FCM $fcmToken');
    try {
      var url = Uri.parse(ApiConstants.VERIFY_OTP);
      var response = await http.post(
        url,
        body: json.encode(<String, dynamic>{
          'mobile': mobile,
          'otp': otp,
          'fcm_token':fcmToken,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        _verifyOtp = verifyOtpFromJson(response.body);
        print('otp verified : ${response.body}');
        BasicConstants.prefs?.setInt(BasicConstants.IS_PROFILE, _verifyOtp.form);
        return _verifyOtp;
      } else if(response.statusCode==400){
        GFToast.showToast("Invalid OTP!", context, toastPosition: GFToastPosition.BOTTOM);
      } else {
        print('otp verified failed : ${response.body}');
        GFToast.showToast("${_verifyOtp?.statusMessage}", context, toastPosition: GFToastPosition.BOTTOM);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<RegisterUser?> registerUser(
      String userID,
      TextEditingController nameController,
      TextEditingController emailController,
      String defGender,
      String dob,
      String defEducation,
      TextEditingController overseaWorkExpController,
      TextEditingController indianWorkEpController) async {
    RegisterUser? _registerUser;
    print('dob: $dob');

    try {
      var url = Uri.parse(ApiConstants.REGISTER_USER);
      var response = await http.post(
        url,
        body: json.encode({
          'user_id': userID,
          'name': nameController.text.toString(),
          'email': emailController.text.toString(),
          'gender': defGender,
          'dob': dob,
          'nationality': '',
          'location': '',
          'education': defEducation,
          'oversea_exp': overseaWorkExpController.text.toString(),
          'indian_exp': indianWorkEpController.text.toString(),
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        _registerUser = RegisterUser.fromJson(jsonDecode(response.body));
        print('data is : $_registerUser');
        return _registerUser;
      } else {
        print("Kuch to gadbad hai daya! ${response.body}");
      }
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<VerifyOtp?> selectCat(
      BuildContext context, String userId, List categories) async {
    VerifyOtp? _selectCat;
    print("Selected Catsss $categories");
    try {
      var url = Uri.parse(ApiConstants.USER_CATEGORY);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({
            'user_id': userId,
            'cat': categories,
          }));
      if (response.statusCode == 200) {
        _selectCat = verifyOtpFromJson(response.body);
        return _selectCat;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<JobDetailsModel?> getJobDetails(
      BuildContext context, String userId, String location, List<String> categories, String countryId, String stateId, String keyword) async {
    JobDetailsModel? _jobDetails;
    print("Catsssssssss $categories, Country & State $countryId, $stateId");
    try {
      var url = Uri.parse(ApiConstants.JOB_DETAILS);
      var response = await http.post(url,
          body: json.encode({
            "user_id": userId,
            "location": location,
            "category":categories,
            "country":countryId,
            "state":stateId,
            "keyword":keyword,
          }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        _jobDetails = jobDetailsModelFromJson(response.body);
        print('Successfully! ${response.body}');
        return _jobDetails;
      } else {
        print(response.body);
      }
    } catch (exception) {
      print("Something Went Wrong with $exception");
    }
    return null;
  }

  Future<JobDetailsModel?> getFeaturedJob(
      BuildContext context, String userID) async {
    JobDetailsModel? _featuredJobs;
    try {
      var url = Uri.parse(ApiConstants.FEATURED_JOB);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({"user_id": userID}));
      if (response.statusCode == 200) {
        print('Featured job get successfully!! ${response.body}');
        _featuredJobs = jobDetailsModelFromJson(response.body);
        print('Featured Response: $_featuredJobs');
        return _featuredJobs;
      } else {
        print('${response.statusCode}');
        GFToast.showToast(
            'Something went wrong! ${response.statusCode}', context,
            toastPosition: GFToastPosition.BOTTOM);
      }
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<DashboardResponse?> getDashboardData(
      BuildContext context, String userID) async {
    DashboardResponse? _dashboardResponse;
    print("User ID = $userID");
    try {
      var url = Uri.parse(ApiConstants.DASHBOARD_API);
      var response = await http.post(url,
          body: {"user_id": userID});
      if (response.statusCode == 200) {
        print('Dashboard data get successfully!! ${response.body}');
        _dashboardResponse = dashboardResponseFromJson(response.body);
        // var repo = json.decode(response.body);
        print('Dashboard 2 Data Response: ${_dashboardResponse.featureCountry}');
        return _dashboardResponse;
      } else {
        print('${response.statusCode}');
        GFToast.showToast(
            'Something went wrong! ${response.statusCode}', context,
            toastPosition: GFToastPosition.BOTTOM);
      }
    } catch (exception) {
      print("Exception $exception");
    }
    return null;
  }

  Future<GetProfile?> getProfile(BuildContext context, String userID) async {
    GetProfile? _getProfile;
    try {
      var url = Uri.parse(ApiConstants.GET_PROFILE);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({
            "user_id": userID,
          }));
      if (response.statusCode == 200) {
        _getProfile = getProfileFromJson(response.body);
        print("User fetched successfully! ${response.body}");
        return _getProfile;
      } else {
        GFToast.showToast(
            'Something went wrong! ${response.statusCode}', context,
            toastPosition: GFToastPosition.BOTTOM);
        print('Something went wrong!: ${response.body}');
      }
    } catch (exc) {
      print(exc);
    }
    return null;
  }

  Future<UpdateProfile?> updateMultipartProfile({
    required BuildContext? context,
    required String? userID,
    TextEditingController? nameController,
    TextEditingController? emailController,
    String? defGender,
    String? dob,
    String? defCountry,
    String? defState,
    String? defEducation,
    TextEditingController? overseaWorkExpController,
    TextEditingController? indianWorkEpController,
    File? image,
  }) async {
    UpdateProfile? _updateProfile;
    print('dob: $dob userID : $userID path: $image');

    Map<String, String> data = {
      'user_id': userID!,
      'name': nameController!.text.toString(),
      'email': emailController!.text.toString(),
      'gender': defGender!,
      'dob': dob!,
      'nationality': defCountry!,
      'location': defState!,
    };

    try {
      var url = Uri.parse(ApiConstants.UPDATE_PROFILE);
      Map<String, String> header = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var request = http.MultipartRequest('POST', url);
      request.fields.addAll(data);
      request.headers.addAll(header);
      var multiPartFile = await http.MultipartFile.fromPath('image', image!.path);
      request.files.add(multiPartFile);
      http.StreamedResponse response = await request.send();
      print('stats code: ${response.statusCode}');
      final respSt = await response.stream.bytesToString();
      var jsonData = jsonDecode(respSt);
      if (response.statusCode == 200) {
        _updateProfile = UpdateProfile.fromJson(jsonData);
        print('data is : $_updateProfile');
        return _updateProfile;
      } else {
        print("Kuch to gadbad hai daya! ${response.statusCode}");
      }
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<UpdateProfile?> uploadCV({
    required BuildContext? context,
    required String? userID,
    File? cv,
  }) async {
    UpdateProfile? _updateProfile;

    Map<String, String> data = {
      'user_id': userID!,
    };

    print('userId : $userID');

    try {
      var url = Uri.parse(ApiConstants.UPDATE_PROFILE);
      Map<String, String> header = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var request = http.MultipartRequest('POST', url);
      request.fields.addAll(data);
      request.headers.addAll(header);
      var multiPartFile = await http.MultipartFile.fromPath('cv', cv!.path);
      request.files.add(multiPartFile);
      http.StreamedResponse response = await request.send();
      print('stats code: ${response.statusCode}');
      final respSt = await response.stream.bytesToString();
      var jsonData = jsonDecode(respSt);
      if (response.statusCode == 200) {
        _updateProfile = UpdateProfile.fromJson(jsonData);
        print('data is : $_updateProfile');
        return _updateProfile;
      } else {
        print("Kuch to gadbad hai daya! ${response.statusCode}");
      }
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<UpdateProfile?> uploadID({
    required BuildContext? context,
    required String? userID,
    File? id,
  }) async {
    UpdateProfile? _updateProfile;

    Map<String, String> data = {
      'user_id': userID!,
    };

    try {
      var url = Uri.parse(ApiConstants.UPDATE_PROFILE);
      Map<String, String> header = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var request = http.MultipartRequest('POST', url);
      request.fields.addAll(data);
      request.headers.addAll(header);
      var multiPartFile =
          await http.MultipartFile.fromPath('id_proof', id!.path);
      request.files.add(multiPartFile);
      http.StreamedResponse response = await request.send();
      print('stats code: ${response.statusCode}');
      final respSt = await response.stream.bytesToString();
      var jsonData = jsonDecode(respSt);
      if (response.statusCode == 200) {
        _updateProfile = UpdateProfile.fromJson(jsonData);
        print('data is : $_updateProfile');
        return _updateProfile;
      } else {
        print("Kuch to gadbad hai daya! ${response.statusCode}");
      }
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<UpdateProfile?> uploadPassport({
    required BuildContext? context,
    required String? userID,
    File? passport,
  }) async {
    UpdateProfile? _updateProfile;

    Map<String, String> data = {
      'user_id': userID!,
    };

    try {
      var url = Uri.parse(ApiConstants.UPDATE_PROFILE);
      Map<String, String> header = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var request = http.MultipartRequest('POST', url);
      request.fields.addAll(data);
      request.headers.addAll(header);
      var multiPartFile =
          await http.MultipartFile.fromPath('passport', passport!.path);
      request.files.add(multiPartFile);
      http.StreamedResponse response = await request.send();
      print('stats code: ${response.statusCode}');
      final respSt = await response.stream.bytesToString();
      var jsonData = jsonDecode(respSt);
      if (response.statusCode == 200) {
        _updateProfile = UpdateProfile.fromJson(jsonData);
        print('data is : $_updateProfile');
        return _updateProfile;
      } else {
        print("Kuch to gadbad hai daya! ${response.statusCode}");
      }
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<UpdateProfile?> uploadVisa({
    required BuildContext? context,
    required String? userID,
    File? visa,
  }) async {
    UpdateProfile? _updateProfile;

    Map<String, String> data = {
      'user_id': userID!,
    };

    try {
      var url = Uri.parse(ApiConstants.UPDATE_PROFILE);
      Map<String, String> header = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var request = http.MultipartRequest('POST', url);
      request.fields.addAll(data);
      request.headers.addAll(header);
      var multiPartFile = await http.MultipartFile.fromPath('exp_cert', visa!.path);
      request.files.add(multiPartFile);
      http.StreamedResponse response = await request.send();
      print('stats code: ${response.statusCode}');
      final respSt = await response.stream.bytesToString();
      var jsonData = jsonDecode(respSt);
      if (response.statusCode == 200) {
        _updateProfile = UpdateProfile.fromJson(jsonData);
        print('data is : $_updateProfile');
        return _updateProfile;
      } else {
        print("Kuch to gadbad hai daya! ${response.statusCode}");
      }
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<UpdateProfile?> uploadPan({
    required BuildContext? context,
    required String? userID,
    File? panCard,
  }) async {
    UpdateProfile? _updateProfile;

    Map<String, String> data = {
      'user_id': userID!,
    };

    try {
      var url = Uri.parse(ApiConstants.UPDATE_PROFILE);
      Map<String, String> header = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var request = http.MultipartRequest('POST', url);
      request.fields.addAll(data);
      request.headers.addAll(header);
      var multiPartFile =
          await http.MultipartFile.fromPath('edu_cert', panCard!.path);
      request.files.add(multiPartFile);
      http.StreamedResponse response = await request.send();
      print('stats code: ${response.statusCode}');
      final respSt = await response.stream.bytesToString();
      var jsonData = jsonDecode(respSt);
      if (response.statusCode == 200) {
        _updateProfile = UpdateProfile.fromJson(jsonData);
        print('data is : $_updateProfile');
        return _updateProfile;
      } else {
        print("Kuch to gadbad hai daya! ${response.statusCode}");
      }
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<UpdateProfile?> updateProfile({
    required BuildContext? context,
    required String? userID,
    TextEditingController? nameController,
    TextEditingController? emailController,
    String? defGender,
    String? dob,
    String? defCountry,
    String? defState,
    String? defEducation,
    String? overseaWorkExpController,
    String? indianWorkEpController,
    File? image,
  }) async {
    UpdateProfile? _updateProfile;
    print('dob: $dob userID : $userID path: $image, indian $indianWorkEpController, oversea $overseaWorkExpController');

    try {
      var url = Uri.parse(ApiConstants.UPDATE_PROFILE);
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'user_id': userID,
          'name': nameController?.text.toString(),
          'email': emailController?.text.toString(),
          'gender': defGender,
          'dob': dob,
          'nationality': defCountry,
          'location': defState,
          "education": defEducation,
          "oversea_exp": overseaWorkExpController,
          "indian_exp": indianWorkEpController,
        }),
      );
      if (response.statusCode == 200) {
        print('Updated Successful ${response.body}');
        _updateProfile = updateProfileFromJson(response.body);
        return _updateProfile;
      } else {
        print("Kuch to gadbad hai daya");
      }
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<SaveJob?> saveJob(
      String userId, String jobId, BuildContext context) async {
    SaveJob? _saveJob;
    var url = Uri.parse(ApiConstants.SAVE_JOB);
    var response = await http.post(
      url,
      body: json.encode({'user_id': userId, 'job_id': jobId}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      _saveJob = saveJobFromJson(response.body);
      return _saveJob;
    }
    return _saveJob;
  }

  Future<ApplyJob?> applyJob(
      String userId, String jobId, BuildContext context, String notes) async {
    ApplyJob? _applyJob;
    var url = Uri.parse(ApiConstants.APPLY_JOB);
    var response = await http.post(
      url,
      body: json.encode({'user_id': userId, 'job_id': jobId, 'notes': notes}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      print("Applied Success ${response.body}");
      _applyJob = applyJobFromJson(response.body);
      return _applyJob;
    } else if (response.statusCode == 403) {
      _applyJob = applyJobFromJson(response.body);
      print('Already: ${response.statusCode}');
      return _applyJob;
    } else if (response.statusCode == 402) {
      _applyJob = applyJobFromJson(response.body);
      print('No Plans: ${response.statusCode}');
      return _applyJob;
    } else {
      _applyJob = applyJobFromJson(response.body);
     print('Exception: ${response.statusCode}');
      return _applyJob;
    }
  }

  Future<JobDetailsModel?> appliedJobList(
      BuildContext context, String userId) async {
    JobDetailsModel _appliedJobs;
    print('uId: $userId');
    try {
      var url = Uri.parse(ApiConstants.APPLIED_JOB_LIST);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({
            'user_id': userId,
          }));
      if (response.statusCode == 200) {
        _appliedJobs = jobDetailsModelFromJson(response.body);
        print('Applied Job Fetched Successful, ${response.body}');
        return _appliedJobs;
      } else {
        print('Something went galat!');
        GFToast.showToast(
            'Something went wrong! ${response.statusCode}', context,
            toastPosition: GFToastPosition.BOTTOM);
      }
    } catch (e) {
      print('Kuch to gadbad hai daya! $e');
    }
    return null;
  }

  Future<JobDetailsModel?> savedJobList(
      BuildContext context, String userId) async {
    JobDetailsModel _savedJobs;
    try {
      var url = Uri.parse(ApiConstants.SAVED_JOB_LIST);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({
            'user_id': userId,
          }));
      if (response.statusCode == 200) {
        _savedJobs = jobDetailsModelFromJson(response.body);
        print('Saved Jobs Fetched ${response.body}');
        return _savedJobs;
      } else {
        print('Something went galat!');
        GFToast.showToast(
            'Something went wrong! ${response.statusCode}', context,
            toastPosition: GFToastPosition.BOTTOM);
      }
    } catch (e) {
      print('Kuch to gadbad hai daya $e');
    }
    return null;
  }

  Future<SubscriptionPlan?> getPlans(BuildContext context) async {
    SubscriptionPlan? _subscriptionPlans;
    try {
      var url = Uri.parse(ApiConstants.SUBS_PLAN);
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        _subscriptionPlans = subscriptionPlanFromJson(response.body);
        print('Plans Fetched');
        return _subscriptionPlans;
      } else {
        print('Something went wrong! ${_subscriptionPlans?.statusCode}');
      }
    } catch (e) {
      print(e);
    }
    return _subscriptionPlans;
  }

  Future<String> deleteDocs(
      BuildContext context, String userID, String docs) async {
    try {
      var url = Uri.parse(ApiConstants.DELETE_DOCS);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({'user_id': userID, 'document_name': docs}));
      if (response.statusCode == 200) {
        print('Deleted Successfully! ${response.statusCode}');
       return json.decode(response.body);
      } else {
        print('Kuch to gadbad hai daya! ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
    return '';
  }

  Future<Response> getRates() async {
    String apiKey = 'LeNMNMpvqr6kdnMdYwOkGcGcaGmUlvjyVktk8mXZ';
    Response response = await get(
        'https://api.currencyapi.com/v3/latest?apikey=$apiKey&base_currency=');
    print('api response ${response.body}');
    return response;
  }

  Future<TicketModel?> getTickets(String userId) async {
    TicketModel? _ticketResponse;
    try {
      var url = Uri.parse(ApiConstants.GET_TICKET);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({
            'user_id': userId,
          }));
      if (response.statusCode == 201) {
        _ticketResponse = ticketModelFromJson(response.body);
        print("Ticket get successfully!");
        return _ticketResponse;
      } else {
        print('Something went wrong! ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<TicketDetailsModel?> getTicketChat(
      BuildContext context, int ticketId) async {
    TicketDetailsModel? _ticketDetailsResponse;
    print("Ticket id: $ticketId");
    try {
      var url = Uri.parse("${ApiConstants.TICKET_CHATS}$ticketId");
      print("Url: $url");
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        _ticketDetailsResponse = ticketDetailsModelFromJson(response.body);
        print("Ticket Chats: ${response.body}");
        return _ticketDetailsResponse;
      } else {
        print("Something went wrong! ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
    return _ticketDetailsResponse;
  }

  Future<void> postTicketReply(BuildContext context, String ticketId, String message ) async{
    try{
      var url = Uri.parse(ApiConstants.TICKET_REPLY);
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'ticket_id':ticketId,
          'message':message,
        })
      );
      if(response.statusCode==200){
        var res = json.decode(response.body);
        print(res["message"]);
      }else{
        print("Something went wrong!");
      }
    }catch(e){
      print(e);
    }
  }

  Future<void> postMultipartTicketReply(BuildContext context, String ticketId, String message, File file ) async{

    Map<String, String> data = {
      'ticket_id':ticketId,
      'message':message,
    };

    try {
      var url = Uri.parse(ApiConstants.TICKET_REPLY);
      Map<String, String> header = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var request = http.MultipartRequest('POST', url);
      request.fields.addAll(data);
      request.headers.addAll(header);
      var multiPartFile = await http.MultipartFile.fromPath('file', file.path);
      request.files.add(multiPartFile);
      http.StreamedResponse response = await request.send();
      print('stats code: ${response.statusCode}');
      final respSt = await response.stream.bytesToString();
      var jsonData = jsonDecode(respSt);
      if (response.statusCode == 200) {
        print(jsonData["message"]);
      } else {
        print("Kuch to gadbad hai daya! ${response.statusCode}");
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future<GetCountriesModel?> getCountryList()async{
    GetCountriesModel? _getCountry;
    try{
      var res = await http.get(
        Uri.parse("https://admin.daraintravels.in/api/location"),
      );
      if(res.statusCode==200){
        _getCountry = getCountriesModelFromJson(res.body);
        print("All Cuntries: ${res.body}");
        return _getCountry;
      }else{
        print("Something went Galat! ${res.body}");
      }
    }catch(e){
      print(e);
    }
    return _getCountry;
  }

  Future<GetStateModel?> getStateList(int countryId)async{
    GetStateModel? _getState;
    try{
      var res = await http.post(
        Uri.parse("https://admin.daraintravels.in/api/state/$countryId"),
      );
      if(res.statusCode==200){
        _getState = getStateModelFromJson(res.body);
        print("All States: ${res.body}");
        return _getState;
      }else{
        print("Something went Galat! ${res.body}");
      }
    }catch(e){
      print(e);
    }
    return _getState;
  }

  Future<String> getLatestUpdate()async{
    String newsStatus="";
    try{
      var url = Uri.parse(ApiConstants.LATEST_UPDATE);
      var response = await http.get(url);
      if(response.statusCode==200){
        print("Lastest Update News : ${response.body}");
        var jsonData = jsonDecode(response.body);
        newsStatus = jsonData["data"][0]["desc"];
        return newsStatus;
      }else{
        print("Something went galat!");
      }
    }catch(e){
      print(e.toString());
    }
    return newsStatus;
  }

  Future<NotificationModel?> getNotifications()async{
    NotificationModel? _notificationModel;
    try{
      var url = Uri.parse(ApiConstants.ALL_NOTIFICATION);
      var response = await http.get(url);
      if(response.statusCode==200){
        print("Notification get successfully! ${response.body}");
        _notificationModel = notificationModelFromJson(response.body);
        return _notificationModel;
      }else{
        print("Something went wrong! ${response.body}");
      }
    }catch(e){
      print(e);
    }

    return _notificationModel;
  }

  Future<EmployerResponse?> getEmployer() async{
    EmployerResponse? _employerResponse;
    try{
      var url = Uri.parse(ApiConstants.BRAND_EMPLOYER);
      var response = await http.post(url);
      if(response.statusCode==200){
        _employerResponse = employerResponseFromJson(response.body);
        print("Employer get Successful ${response.body}");
        return _employerResponse;
      }else{
        print("Something went wrong!");
      }
    }catch(e){
      print(e.toString());
    }
    return _employerResponse;
  }

  Future<FeaturedCountry?> getFeaturedCountries() async{
    FeaturedCountry? _featuredCountry;
    try{
      var url = Uri.parse(ApiConstants.FEATURED_COUNTRY);
      var response = await http.post(url);
      if(response.statusCode==200){
        _featuredCountry = featuredCountryFromJson(response.body);
        print("Featured Country get Successful ${response.body}");
        return _featuredCountry;
      }else{
        print("Something went wrong!");
      }
    }catch(e){
      print(e.toString());
    }
    return _featuredCountry;
  }

  Future<NotesMessages?> getNotes(String appID)async{
    NotesMessages? _notesMessageResponse;
    print("App ID : $appID");
    try{
      var url = Uri.parse("${ApiConstants.APP_DETAILS}/$appID");
      var response = await http.get(url);
      if(response.statusCode==200){
        print("Notes  get ${response.body}");
        _notesMessageResponse = notesMessagesFromJson(response.body);
        return _notesMessageResponse;
      }else{
        print("Something went galat!");
      }
    }catch(e){
      print(e);
    }
    return _notesMessageResponse;
  }

  Future<BannersResposne?> getBanner()async{
    BannersResposne? res;
    try{
      var url = Uri.parse(ApiConstants.TOP_BANNER);
      var response = await http.get(url);
      if(response.statusCode==200){
        res = bannersResposneFromJson(response.body);
        print("Banner : ${response.body}");
        return res;
      }else{
        print("Something went galat!");
      }
    }catch(e){
      print(e);
    }
    return res;
  }


  Future<PlanValidityRes?> getPlanValidity(String userId)async{
    PlanValidityRes? res;
    try{
      var url = Uri.parse("${ApiConstants.PLAN_VALIDITY}/$userId");
      var response = await http.get(url);
      if(response.statusCode==200){
        res = planValidityResFromJson(response.body);
        print("Plan Validity : ${response.body}");
        return res;
      } else {
        print("Something went galat!");
      }
    }catch(e){
      print(e);
    }
    return res;
  }

  Future<OfferResponse?> getOffer(String planId)async{
    OfferResponse? res;
    try{
      var url = Uri.parse("${ApiConstants.OFFER_DETAIL}/$planId");
      var response = await http.get(url);
      if(response.statusCode==200){
        print("Offer Detail : ${response.body}");
        res = parseResponse(response.body);
        return res;
      } else if(response.statusCode==404){
        print("Error ${response.body}");
        res = parseResponse(response.body);
        return res;
      }else {
        print("Something went galat! ${response.statusCode}");
        res = parseResponse(response.body);
        return res;
      }
    }catch(e){
      print(e);
    }
    return res;
  }

  // Future<GetResponse> getData(String imageUrl) async{
  //   GetResponse? _getResponse
  //   try{
  //     final Map<String, String> params = {
  //       'images': imageUrl,
  //       'organs': 'flower',
  //       'include-related-images':'true',
  //       'no-reject': 'false',
  //       'lang':'en',
  //       'type':'legacy',
  //       'api-key':'2b10gdb9gAKCBO7K0tnsEZuFsu',
  //       'authenix-access-token':'2b10gdb9gAKCBO7K0tnsEZuFsu'
  //     };
  //     final Uri uri = Uri.https("https://my-api.plantnet.org/v2/", "identify/all", params);
  //     var response = await http.get(uri);
  //     if (response.statusCode == 200) {
  //       print(response.body);
  //     } else {
  //       print('Request failed with status: ${response.statusCode}');
  //     }
  //   }catch(e){
  //     print(e);
  //   }
  // }
}
