import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runon/providers/appointments.dart';
import 'package:runon/utils/app_methods.dart';
import 'package:runon/widgets/send_message_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:runon/widgets/report_dialog.dart';
import 'package:runon/widgets/attachment_card.dart';

class MessagesScreen extends StatelessWidget {
  static const routeName = '/messages-screen';
  MessagesScreen({super.key});

  bool _isLoadingFile = false;

  @override
  Widget build(BuildContext context) {
    final Appointment appointment = ModalRoute.of(context)!.settings.arguments as Appointment;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Doctor'),
        actions: [
          PopupMenuButton(
              color: Theme.of(context).colorScheme.surfaceVariant,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onSelected: (value) {
                if (value == 'Report') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ReportDialog(
                          appointment.appointmentId, FirebaseAuth.instance.currentUser!.uid);
                    },
                  );
                }
              },
              itemBuilder: (_) {
                return [
                  PopupMenuItem(
                      value: 'Report',
                      child: Row(
                        children: const [
                          Icon(Icons.flag),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Report   '),
                        ],
                      ))
                ];
              })
        ],
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appointments/${appointment.appointmentId}/messages')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SingleChildScrollView(),
            );
          }
          return Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length + 1,
                  reverse: true,
                  itemBuilder: (ctx, index) {
                    index--;
                    if (index == -1) {
                      return const SizedBox(
                        height: 10,
                      );
                    }
                    return Row(
                      mainAxisAlignment: snapshot.data!.docs[index]['createdBy'] ==
                              FirebaseAuth.instance.currentUser!.uid
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (snapshot.data!.docs[index]['type'] == 'file')
                          StatefulBuilder(builder: (context, setState) {
                            return Stack(
                              children: [
                                Card(
                                  // color: ,
                                  elevation: 0,
                                  margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 3),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: (MediaQuery.of(context).size.width * (2 / 3)),
                                    ),
                                    // padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            _isLoadingFile = true;
                                          });
                                          await AppMethods.openFile(
                                              snapshot.data!.docs[index]['text'],
                                              snapshot.data!.docs[index]['title']);
                                          setState(() {
                                            _isLoadingFile = false;
                                          });
                                        },
                                        child: AttachmentCard(
                                            title: snapshot.data!.docs[index]['title'],
                                            color: (snapshot.data!.docs[index]['createdBy'] !=
                                                    FirebaseAuth.instance.currentUser!.uid
                                                ? Theme.of(context).colorScheme.primaryContainer
                                                : null),
                                            height: 100),
                                      ),
                                    ),
                                  ),
                                ),
                                if (_isLoadingFile)
                                  const Positioned.fill(
                                    child: Opacity(
                                      opacity: 0.4,
                                      child: Card(
                                        color: Colors.black,
                                        margin: EdgeInsets.symmetric(horizontal: 21, vertical: 6),
                                        elevation: 3,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            );
                          }),
                        if (snapshot.data!.docs[index]['type'] == 'text')
                          Card(
                              color: snapshot.data!.docs[index]['createdBy'] !=
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : null,
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 3),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: (MediaQuery.of(context).size.width * (2 / 3))),
                                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                                child: Text(snapshot.data!.docs[index]['text']),
                              )),
                      ],
                    );
                  },
                ),
              ),
              SendMessageField(appointment.appointmentId, hasPassed: appointment.hasPassed48Hours),
            ],
          );
        },
      ),
    );
  }
}
