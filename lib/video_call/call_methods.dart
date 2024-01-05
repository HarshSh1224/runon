import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runon/video_call/call_model.dart';

class CallMethods {
  final _videoCallCollection = 'video_call';
  final _callLogs = 'call_logs';

  late CollectionReference callCollection;
  late CollectionReference callLogsCollection;

  CallMethods() {
    callCollection = FirebaseFirestore.instance.collection(_videoCallCollection);
    callLogsCollection = FirebaseFirestore.instance.collection(_callLogs);
  }

  Stream<DocumentSnapshot> callStream({required String uid}) => callCollection.doc(uid).snapshots();

  Future<bool> makeCall({required Call call}) async {
    try {
      await callCollection.doc(call.appointment.appointmentId).set(call.toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({required Call call}) async {
    try {
      await callCollection.doc(call.appointment.appointmentId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> missedCall({required Call call}) async {
    // try {
    //   await callCollection.doc(call.callerId).delete();
    //   await callCollection.doc(call.receiverId).delete();
    //   await callLogsCollection.add({
    //     AppConstants.callCreateTime: call.callCreateTime.toIso8601String(),
    //     AppConstants.callerId: call.callerId,
    //     AppConstants.receiverId: call.receiverId,
    //     AppConstants.programId: call.programId,
    //     AppConstants.status: "missed"
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }
}
