import 'package:http/http.dart' as http;
import 'dart:async';
import '../models/service_provider.dart';
import '../helpers/constants.dart';

class ServiceHelpRequest {
  static String serviceBaseUrl = "http://192.168.0.107:8083/mausafe/index.php/";
  static String apiKey = "58eb50e1-f87b-44a7-a4be-dcccd71625eb";

  static Map<String, String> generateHeaders() {
    Map<String, String> headers = new Map<String, String>();
    headers["x-api-key"] = apiKey;

    return headers;
  }

  static void retrieveLiveRequest(deviceId, callback) async {
    http
        .get(serviceBaseUrl + 'HelpRequest?device_id=' + deviceId,
            headers: generateHeaders())
        .then((response) {
      callback(response);
    }).catchError((e) {
      callback(null);
    });
  }

  static void initiateHelpRequest(String deviceId, String longitude,
      String latitude, List<ServiceProvider> providers, callback) async {
    //build request body
    Map<String, String> bodyRequest = new Map<String, String>();
    bodyRequest["customer_name"] = customerName;
    bodyRequest["age"] = age;
    bodyRequest["blood_group"] = bloodGroup;
    bodyRequest["special_conditions"] = specialConditions;
    bodyRequest["device_id"] = deviceId;
    bodyRequest["longitude"] = longitude;
    bodyRequest["latitude"] = latitude;

    String providerStrList = "";
    for (int i = 0; i < providers.length; i++) {
      if (providers[i].isOptional = false) {
        providerStrList += providers.elementAt(i).name.toUpperCase() + "|";
      }
    }

    //remove last delimiter
    if (providerStrList != "") {
      providerStrList =
          providerStrList.substring(0, providerStrList.length - 1);
    }

    bodyRequest["provider_list"] = providerStrList;

    http
        .post(serviceBaseUrl + 'HelpRequest/initiate',
            headers: generateHeaders(), body: bodyRequest)
        .then((response) {
      callback(response, providers);
    }).catchError((e) {
      callback(null, providers);
    });
  }
}
