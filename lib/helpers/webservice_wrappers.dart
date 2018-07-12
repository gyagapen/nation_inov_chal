import 'package:http/http.dart' as http;
import 'dart:convert';
import 'common.dart';
import '../services/service_help_request.dart';
import '../models/trigger_event.dart';
import '../models/service_provider.dart';
import '../models/help_request.dart';
import '../models/assignment_details.dart';

class WebserServiceWrapper {
  static void getPendingHelpRequest(callback) {
    try {
      //call webservice to check if any live request
      getDeviceUID().then((uiD) {
        ServiceHelpRequest.retrieveLiveRequest(uiD.toString()).then((response) {
          if (response.statusCode == 200) {
            Map<String, dynamic> decodedResponse = json.decode(response.body);
            if (decodedResponse["status"] == true) {
              if (decodedResponse["help_details"] == null) {
                //no pending help request
                callback(null, null);
              } else {
                //build service providers as

                HelpRequest helpRequest =
                    HelpRequest.fromJson(decodedResponse["help_details"]);

                List<AssignmentDetails> assignmentDetails =
                    new List<AssignmentDetails>();
                if (decodedResponse["assignment_details"] != null) {
                  for (var assignment
                      in decodedResponse["assignment_details"]) {
                    assignmentDetails
                        .add(AssignmentDetails.fromJson(assignment));
                  }
                }

                //merge service providers
                TriggerEvent helpRequestEvent =
                    new TriggerEvent(helpRequest.eventType);
                List<ServiceProvider> serviceProviders =
                    helpRequestEvent.serviceProviders;
                for (int i = 0; i < serviceProviders.length; i++) {
                  //determine wheter it's optional
                  if (helpRequest.requestedServiceProviders
                      .contains(serviceProviders.elementAt(i).name)) {
                    serviceProviders.elementAt(i).isOptional = false;
                  }

                  //update assignment details
                  for (var assignmentItem in assignmentDetails) {
                    //match service provider
                    if (assignmentItem.serviceProviderType.toUpperCase() ==
                        serviceProviders.elementAt(i).name.toUpperCase()) {
                      //update details
                      serviceProviders
                          .elementAt(i)
                          .status
                          .setStatusFromWs(assignmentItem.status);

                      serviceProviders.elementAt(i).status.estTimeArrival =
                          assignmentItem.etaMin;

                      serviceProviders.elementAt(i).status.distanceKm =
                          assignmentItem.distanceKm;

                      serviceProviders.elementAt(i).location.latitude =
                          double.parse(assignmentItem.latitude);

                      serviceProviders.elementAt(i).location.longitude =
                          double.parse(assignmentItem.longitude);
                    }
                  }
                }

                helpRequest.serviceProviderObjects = serviceProviders;
                callback(helpRequest, null);
              }
            } else {
              var ex =
                  new Exception(wsUserError + "|" + decodedResponse["error"]);
              throw ex;
            }
          } else {
            var ex = new Exception();
            throw ex;
          }
        }).catchError((e) {
          callback(null, e);
        });
      }).catchError((e) {
        callback(null, e);
      });
    } catch (e) {
      callback(null, e);
    }
  }
}
