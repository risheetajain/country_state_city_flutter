import 'dart:io';

import 'package:dio/dio.dart';

class ApiUtils{
   static Future getRequest(url) async {
    try {
      var response = await Dio().get(url,
          options: Options(headers: {
            "X-CSCAPI-KEY":
                "VE4wV3VsU2hQSkJTRHNMZUlDTUM1NFg0RnZCbmRqUDFCcWE5bHpsdg=="
          }));
      return response.data;
    } on SocketException {
      return {"message": "Internet Issue! No Internet connection 😑"};
    } catch (e) {
      print("dio error$e");
      return {"message": "Connection Problem"};
    }
  }

  static Future getCountryName() {
    String url = "https://api.countrystatecity.in/v1/countries";
    return getRequest(url);
  }

  static Future getStateName(String countryCode) {
    String url =
        "https://api.countrystatecity.in/v1/countries/$countryCode/states";
    return getRequest(url);
  }

  static Future getCityName(
      {required String countryCode, required String stateName}) {
    String url =
        "https://api.countrystatecity.in/v1/countries/$countryCode/states/$stateName/cities";
    return getRequest(url);
  }
}