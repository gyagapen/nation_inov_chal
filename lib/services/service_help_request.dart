import 'package:http/http.dart' as http;
import 'dart:async';
import '../models/service_provider.dart';
import '../helpers/constants.dart';

class ServiceHelpRequest {
  static String serviceBaseUrl = "http://192.168.0.111:8083/mausafe/index.php/";
  static String apiKey = "58eb50e1-f87b-44a7-a4be-dcccd71625eb";

  static Map<String, String> generateHeaders() {
    Map<String, String> headers = new Map<String, String>();
    headers["x-api-key"] = apiKey;

    return headers;
  }

  static void retrieveLiveRequest(deviceId, callback) async {
    Future<http.Response> resp = http.get(
        serviceBaseUrl + 'HelpRequest?device_id=' + deviceId,
        headers: generateHeaders());

    callback(resp);
  }

  static void initiateHelpRequest(String deviceId, String longitude,
      String latitude, List<ServiceProvider> providers, callback) {
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
      providerStrList += providers.elementAt(i).name.toUpperCase() + "|";
    }

    //remove last delimiter
    if (providers.length > 0) {
      providerStrList = providerStrList.substring(0, providerStrList.length - 2);
    }

    bodyRequest["provider_list"] = providerStrList;

    Future<http.Response> resp = http.post(
        serviceBaseUrl + 'HelpRequest?device_id=' + deviceId,
        headers: generateHeaders(),
        body: bodyRequest);

    callback(resp, providers);
  }
}
