

import 'package:flutter/material.dart';
import 'package:mausafe_v0/models/trigger_event.dart';
import '../../models/witness_details.dart';
import 'sinister_type.dart';
import 'building_type.dart';
import 'video_capture.dart';
import 'floor_number.dart';
import 'person_trapped.dart';
import 'samu_need.dart';
import '../../services/service_help_request.dart';

class WitnessFlowManager{

  static showWitnessNextStep(String currentStep, WitnessDetails witnessDetails,
  BuildContext context, TriggerEvent id, callback)
  {
      switch(currentStep)
      {
          case "": {
            showSinisterTypeDialog(witnessDetails, context, id, callback);
            break;
            }
          case SINISTER_TYPE_DIALOG_ID: {
            if(witnessDetails.impactType == "Building") {
              showBuildingTypeDialog(witnessDetails, context, id, callback);
            }
            else if(witnessDetails.impactType == "Vehicle"){
              showSamuDialog(witnessDetails, context, id, callback);
            }
            else {
              showVideoCaptureDialog(witnessDetails, context, id, callback);
            }
          }
          break;
          case BUILDING_TYPE_DIALOG_ID:{
              showFloorNumberDialog(witnessDetails, context, id, callback);
            }
          break;
          case FLOOR_NUMBER_DIALOG_ID:{
              showSamuDialog(witnessDetails, context, id, callback);
            }
          break;
          case SAMU_DIALOG_ID:{
              showPersonTrappedDialog(witnessDetails, context, id, callback);
            }
          break;
          case PERSON_TRAPPED_DIALOG_ID:{
              showVideoCaptureDialog(witnessDetails, context, id, callback);
          }
          break;
           case VIDEO_CAPTURE_DIALOG_ID:{
              print("Flow is over");
              callback(id, witnessDetails);
          }
          break;


      }
  }
}