// import 'package:runon/misc/constants/app_constants.dart';
// import 'package:runon/providers/appointments.dart';

// enum CallType { voiceCall, videoCall }

// class Call {
//   String channelId;
//   DateTime callCreateTime;
//   Appointment appointment;
//   bool hasDialed;

//   Call({
//     required this.channelId,
//     required this.callCreateTime,
//     required this.appointment,
//     required this.hasDialed,
//   });

//   Map<String, dynamic> toMap(Call call) {
//     return {
//       AppConstants.channelId: channelId,
//       AppConstants.callCreateTime: callCreateTime.toIso8601String(),
//       AppConstants.appointment: appointment.toMap(appointment),
//     };
//   }

//   factory Call.fromMap(Map<String, dynamic> json) {
//     return Call(
//       callerId: json[AppConstants.callerId],
//       callerTitle: json[AppConstants.callerTitle],
//       callerName: json[AppConstants.callerName],
//       callerPic: json[AppConstants.callerPic],
//       receiverId: json[AppConstants.receiverId],
//       receiverName: json[AppConstants.receiverName],
//       receiverPic: json[AppConstants.receiverPic],
//       channelId: json[AppConstants.channelId],
//       hasDialed: json[AppConstants.hasDialed],
//       callCreateTime: DateTime.parse(json[AppConstants.callCreateTime]),
//       callType: json[AppConstants.callType] == 0 ? CallType.videoCall : CallType.voiceCall,
//       programId: json[AppConstants.programId],
//       programTitle: json[AppConstants.programTitle],
//     );
//   }
// }
