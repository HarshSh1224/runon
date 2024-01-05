// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:provider/provider.dart';
// import 'package:runon/models/flat_feet_options.dart';
// import 'package:runon/providers/appointments.dart';
// import 'package:runon/providers/auth.dart';
// import 'package:runon/providers/exercise_docs.dart';
// import 'package:runon/video_call/settings.dart';
// import 'package:http/http.dart' as http;
// import 'package:runon/widgets/video_call_drawer.dart';

// class CallPage extends StatefulWidget {
//   static const routeName = '/call-page';

//   const CallPage({super.key});
//   @override
//   State<CallPage> createState() => _CallPageState();
// }

// class _CallPageState extends State<CallPage> {
//   bool isInit = false;
//   String tempToken = "Error Please restart the video call";
//   AgoraClient _client = AgoraClient(
//     agoraConnectionData: AgoraConnectionData(
//       appId: appId,
//       channelName: "test",
//     ),
//   );

//   late Appointment appointment;
//   late Function(String, Appointment, FeetObservations?) uploadPrescription;

//   @override
//   void didChangeDependencies() {
//     if (!isInit) {
//       isInit = true;

//       // Send Map<String, dynamic> as arguments
//       // Map['appointment'] is in instance of Appointment
//       // Map['callback'] is a Function(String, Appointment, FeetObservations?) uploadPrescription

//       appointment =
//           (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['appointment'];
//       uploadPrescription =
//           (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['callback'];
//       initAgora();
//     }
//     super.didChangeDependencies();
//   }

//   void initAgora() async {
//     _client = AgoraClient(
//         agoraConnectionData: AgoraConnectionData(
//             // username: ,
//             appId: appId,
//             channelName: appointment.appointmentId,
//             tempToken: tempToken
//             // tokenUrl:
//             //     "https://agora-node-tokenserver.run-onon1.repl.co/access_token?channelName=6pPJq7Tx2MJYX25pDjpN",
//             ),
//         enabledPermission: [Permission.camera, Permission.microphone]);
//     await _client.initialize();
//   }

//   @override
//   void dispose() async {
//     Future.delayed(Duration.zero, () async {
//       await _client.release();
//     });
//     _prescriptionDialogController.dispose();
//     _prescriptionDialogFocusNode.dispose();
//     super.dispose();
//   }

//   Future<void> getToken() async {
//     String link =
//         'https://agora-node-tokenserver.run-onon1.repl.co/access_token?channelName=${appointment.appointmentId}';
//     try {
//       final response = await http.get(Uri.parse(link));
//       Map data = jsonDecode(response.body);
//       tempToken = data["token"];
//     } catch (error) {
//       debugPrint(error.toString());
//     }
//     if (tempToken.contains('Error')) _client.release();
//   }

//   var feetObservations = FeetObservations();

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: getToken(),
//       builder: (context, snapshot) {
//         return snapshot.connectionState == ConnectionState.waiting
//             ? const Scaffold(
//                 body: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               )
//             : Scaffold(
//                 endDrawer: !Provider.of<Auth>(context, listen: false).isDoctor
//                     ? null
//                     : FutureBuilder(
//                         future: Provider.of<ExerciseDocuments>(context, listen: false)
//                             .fetchAndSetExerciseDocuments(),
//                         builder: (context, snapshot) {
//                           return snapshot.connectionState == ConnectionState.waiting
//                               ? const Center(
//                                   child: CircularProgressIndicator(),
//                                 )
//                               : CallDrawer(
//                                   prescriptionController: _prescriptionDialogController,
//                                   feetObservations:
//                                       appointment.isFlatfeetOrKnocknee ? feetObservations : null,
//                                   onChangedFeetObservations: (changed) {
//                                     feetObservations = changed;
//                                   },
//                                   appointmentId: appointment.appointmentId);
//                         }),
//                 appBar: AppBar(
//                   title: const Text('Video Call'),
//                   centerTitle: true,
//                   // actions: [
//                   //   if (Provider.of<Auth>(context, listen: false).isDoctor)
//                   //     IconButton(
//                   //       icon: const Icon(Icons.edit),
//                   //       onPressed: _onTapEdit,
//                   //     )
//                   // ],
//                 ),
//                 backgroundColor: Colors.black,
//                 body: Stack(
//                   children: [
//                     AgoraVideoViewer(
//                       client: _client,
//                       showNumberOfUsers: false,
//                       layoutType: Layout.oneToOne,
//                     ),
//                     AgoraVideoButtons(
//                       client: _client,
//                       onDisconnect: () async {
//                         await uploadPrescription(_prescriptionDialogController.text, appointment,
//                             appointment.isFlatfeetOrKnocknee ? feetObservations : null);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text('Call Ended'),
//                             ),
//                           ),
//                         );
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     Text(
//                       // '',
//                       tempToken.contains('Error') ? tempToken : '',
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 ),
//               );
//       },
//     );
//   }

//   final FocusNode _prescriptionDialogFocusNode = FocusNode();
//   final TextEditingController _prescriptionDialogController = TextEditingController();

//   _onTapEdit() {
//     _prescriptionDialogFocusNode.requestFocus();
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         content: TextFormField(
//           controller: _prescriptionDialogController,
//           focusNode: _prescriptionDialogFocusNode,
//           minLines: 3,
//           maxLines: 10,
//           keyboardType: TextInputType.multiline,
//           decoration: const InputDecoration(hintText: 'Write your prescriptions here'),
//         ),
//         actions: [
//           TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 prescription = _prescriptionDialogController.text;
//                 _prescriptionDialogController.clear();
//               },
//               child: const Text('Submit')),
//           TextButton(onPressed: Navigator.of(context).pop, child: const Text('Save & close')),
//         ],
//       ),
//     );
//   }

//   String? prescription;
// }
