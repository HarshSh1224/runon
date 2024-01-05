// import 'dart:convert';

// import 'package:flutter/widgets.dart';
// import 'package:runon/video_call/video_call_methods.dart';
// import 'package:runon/miscellaneous/AppMethods.dart';
// import 'package:runon/miscellaneous/constants/app_constants.dart';
// import 'package:runon/models/call_model.dart';
// import 'package:runon/models/user_model.dart';
// import 'package:runon/objects/chat_member.dart';
// import 'package:runon/controllers/navigation.dart';
// import 'package:http/http.dart' as http;

// class CallUtilities{
//   static final CallMethods callMethods = CallMethods();

//   static dial({
//     required UserModel userModel,
//     required ChatMember member,
//     required BuildContext context,
//     required CallType callType,
//     required String programId,
//     required String programTitle,
//   }) async {
//     Call call = Call(
//       callerId: userModel.userId,
//       callerName: userModel.fullName,
//       callerTitle: AppMethods.titleStringFromConstant(userModel.title),
//       callerPic: userModel.avatar,
//       receiverId: member.userId,
//       receiverName: member.generateFullName(),
//       receiverPic: member.avatar,
//       programId: programId,
//       programTitle: programTitle,
//       channelId: userModel.userId + member.userId,
//       callCreateTime: DateTime.now(),
//       callType: callType,
//       hasDialed: true,
//     );

//     bool callMade = await callMethods.makeCall(call: call);
//     call.hasDialed = true;

//     if(callMade){
//       if(callType == CallType.videoCall) {
//         Navigation.goToVideoCallScreen(context, call: call);
//       } else {
//         Navigation.goToAudioCallScreen(context, call: call);
//       }
//     }
//   }

//   static Future<String?> getToken({required String channelId,required String userId,}) async {
//     String url = 'https://agoratokenserverwithgo--mura-developers.repl.co/rtc/$channelId/publisher/userAccount/$userId/';
//     try {
//       final response = await http.get(Uri.parse(url));
//       final json = jsonDecode(response.body);
//       return json[AppConstants.rtcToken];
//     } catch (error) {
//       debugPrint(error.toString());
//       rethrow;
//     }
//   }
// }