import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:runon/providers/appointments.dart';
import 'package:runon/video_call/call_methods.dart';
import 'package:runon/misc/constants/app_constants.dart';
import 'package:runon/video_call/call_model.dart';
import 'package:http/http.dart' as http;
import 'package:runon/video_call/video_call_screen.dart';

class CallUtilities {
  static final CallMethods callMethods = CallMethods();

  static dial({
    required BuildContext context,
    required Appointment appointment,
    required String doctorName,
    required String patientName,
    required String doctorProfilePic,
    required String patientProfilePic,
  }) async {
    Call call = Call(
      callCreateTime: DateTime.now(),
      channelId: appointment.appointmentId,
      appointment: appointment,
      doctorId: appointment.doctorId,
      patientId: appointment.patientId,
      doctorName: doctorName,
      patientName: patientName,
      doctorProfilePic: doctorProfilePic,
      patientProfilePic: patientProfilePic,
    );

    bool callMade = await callMethods.makeCall(call: call);

    if (callMade) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoCallScreen(call: call),
        ),
      );
      // if (callType == CallType.videoCall) {
      //   Navigation.goToVideoCallScreen(context, call: call);
      // } else {
      //   Navigation.goToAudioCallScreen(context, call: call);
      // }
    }
  }

  static Future<String?> getToken({
    required String channelId,
  }) async {
    String url = 'https://smiling-hosiery-mite.cyclic.app/access_token?channelName=$channelId';
    try {
      final response = await http.get(Uri.parse(url));
      final json = jsonDecode(response.body);
      return json[AppConstants.token];
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }
}
