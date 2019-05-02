import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../models/service_provider.dart';
import '../helpers/constants.dart';
import '../models/witness_details.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';

class ServiceHelpRequest {
  //static String serviceBaseUrl = "http://aroma.mu/webservices/mausafe/index.php/";
  static String serviceBaseUrl = "http://192.168.0.101:8083/mausafe/index.php/";
  static String apiKey = "58eb50e1-f87b-44a7-a4be-dcccd71625eb";

  static Map<String, String> generateHeaders() {
    Map<String, String> headers = new Map<String, String>();
    headers["x-api-key"] = apiKey;

    return headers;
  }

  static Future<http.Response> retrieveLiveRequest(
      deviceId, String type) async {
    return http.get(
        serviceBaseUrl + 'HelpRequest?device_id=' + deviceId + '&type=' + type,
        headers: generateHeaders());
  }

  static Future<http.Response> sendWitnessDetails(int helpReqId, WitnessDetails witnessDetails) async {

      //open file
      var videoFile = new File(witnessDetails.videoPath);

      // open a bytestream
      var stream = new http.ByteStream(DelegatingStream.typed(videoFile.openRead()));
      // get file length
      var length = await videoFile.length();

      // string to uri
      var uri = Uri.parse(serviceBaseUrl + 'HelpRequest/video');

      // create multipart request
      var request = new http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile = new http.MultipartFile('video', stream, length,
          filename: basename(witnessDetails.videoPath));

      //add headers
      request.headers.addAll(generateHeaders());

      // add file to multipart
      request.files.add(multipartFile);
      Map<String, String> bodyRequest = new Map<String, String>();
      bodyRequest["help_request_id"] = helpReqId.toString();

      request.fields.addAll(bodyRequest);

      // send
      var response = await request.send();
      print(response.statusCode);

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
  }

  static void cancelHelpReauest(String helpRequestId, callback) async {
    Map<String, String> bodyRequest = new Map<String, String>();

    bodyRequest["request_id"] = helpRequestId;

    http
        .post(serviceBaseUrl + 'HelpRequest/cancel',
            headers: generateHeaders(), body: bodyRequest)
        .then((response) {
      callback(response);
    }).catchError((e) {
      callback(null);
    });
  }

  static void addServiceProvider(
      String helpRequestId, String providerName, callback) async {
    Map<String, String> bodyRequest = new Map<String, String>();

    bodyRequest["help_request_id"] = helpRequestId;
    bodyRequest["provider_name"] = providerName;

    http
        .post(serviceBaseUrl + 'HelpRequest/addServiceProvider',
            headers: generateHeaders(), body: bodyRequest)
        .then((response) {
      callback(response);
    }).catchError((e) {
      callback(null);
    });
  }

  static void initiateHelpRequest(
      String deviceId,
      String longitude,
      String latitude,
      List<ServiceProvider> providers,
      String eventType, 
      callback,
      WitnessDetails witnessDetails) async {

    // string to uri
    var uri = Uri.parse(serviceBaseUrl + 'HelpRequest/initiate');
    
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    //build request body
    Map<String, String> bodyRequest = new Map<String, String>();
    bodyRequest["customer_name"] = customerName;
    bodyRequest["age"] = age;
    bodyRequest["blood_group"] = bloodGroup;
    bodyRequest["special_conditions"] = specialConditions;
    bodyRequest["device_id"] = deviceId;
    bodyRequest["longitude"] = longitude;
    bodyRequest["latitude"] = latitude;
    bodyRequest["event_type"] = eventType;
    bodyRequest["nic"] = nic;
    bodyRequest["is_witness"] = (witnessDetails == null) ? "0" : "1";

    //witness details
    if(witnessDetails != null)
    {
      bodyRequest["impact_type"] = witnessDetails.impactType;
      bodyRequest["building_type"] = witnessDetails.buildingType;
      bodyRequest["no_floors"] = witnessDetails.noOfFloors;
      bodyRequest["samu_needed"] = witnessDetails.isSAMUNeeded ? "1" : "0";
      bodyRequest["person_trapped"] = witnessDetails.isAPersonTrapped ? "1" : "0";  

      //video processing
      var videoFile = new File(witnessDetails.videoPath);
      var stream = new http.ByteStream(DelegatingStream.typed(videoFile.openRead()));
      var length = await videoFile.length();
      // multipart that takes file
      var multipartFile = new http.MultipartFile('video', stream, length,
          filename: basename(witnessDetails.videoPath));

      // add file to multipart
      request.files.add(multipartFile);
    }



    String providerStrList = "";
    for (int i = 0; i < providers.length; i++) {
      if (providers.elementAt(i).isOptional == false) {
        providerStrList += providers.elementAt(i).name.toUpperCase() + "|";
      }
    }

    //remove last delimiter
    if (providerStrList != "") {
      providerStrList =
          providerStrList.substring(0, providerStrList.length - 1);
    }

    bodyRequest["provider_list"] = providerStrList;

    /*return http.post(serviceBaseUrl + 'HelpRequest/initiate',
        headers: generateHeaders(), body: bodyRequest);*/

    //add headers
    request.headers.addAll(generateHeaders());

    //add body
    request.fields.addAll(bodyRequest);

     // send
    request.send().then((response){
          //response
          // listen for response
          response.stream.transform(utf8.decoder).listen((value) {
            callback(value, providers);
          });
    }).catchError((e)
    {
        callback(null, providers);
    });

      

    /*http
        .post(serviceBaseUrl + 'HelpRequest/initiate',
            headers: generateHeaders(), body: bodyRequest)
        .then((response) {
      callback(response, providers);
    }).catchError((e) {
      callback(null, providers);
    });*/
  }

  static Future<http.Response> getCircles(String deviceId) async {
    return http.get(serviceBaseUrl + 'Circle?device_id=' + deviceId,
        headers: generateHeaders());
  }

  static Future<http.Response> insertCircle(
      String deviceId, String name, String number) async {
    Map<String, String> bodyRequest = new Map<String, String>();

    bodyRequest["device_id"] = deviceId;
    bodyRequest["name"] = name;
    bodyRequest["number"] = number;

    return http.post(serviceBaseUrl + 'Circle/insert',
        headers: generateHeaders(), body: bodyRequest);
  }

  static Future<http.Response> updateCircle(
      String id, String name, String number) async {
    Map<String, String> bodyRequest = new Map<String, String>();

    bodyRequest["id"] = id;
    bodyRequest["name"] = name;
    bodyRequest["number"] = number;

    return http.post(serviceBaseUrl + 'Circle/update',
        headers: generateHeaders(), body: bodyRequest);
  }

  static Future<http.Response> deleteCircle(String id) async {
    Map<String, String> bodyRequest = new Map<String, String>();

    bodyRequest["id"] = id;

    return http.post(serviceBaseUrl + 'Circle/delete',
        headers: generateHeaders(), body: bodyRequest);
  }
}
