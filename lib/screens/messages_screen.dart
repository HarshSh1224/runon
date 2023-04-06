import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runon/widgets/send_message_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:runon/widgets/report_dialog.dart';

class MessagesScreen extends StatelessWidget {
  static const routeName = '/messages-screen';
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentId = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Doctor'),
        actions: [
          PopupMenuButton(
              color: Theme.of(context).colorScheme.surfaceVariant,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onSelected: (value) {
                if (value == 'Report') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ReportDialog(appointmentId as String,
                          FirebaseAuth.instance.currentUser!.uid);
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
            .collection('appointments/$appointmentId/messages')
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
                  itemCount: snapshot.data!.docs.length,
                  reverse: true,
                  itemBuilder: (ctx, index) {
                    return Row(
                      mainAxisAlignment: snapshot.data!.docs[index]
                                  ['createdBy'] ==
                              FirebaseAuth.instance.currentUser!.uid
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Card(
                            color: snapshot.data!.docs[index]['createdBy'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 17, vertical: 3),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: (MediaQuery.of(context).size.width *
                                      (2 / 3))),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 12),
                              child: Text(snapshot.data!.docs[index]['text']),
                            )),
                      ],
                    );
                  },
                ),
              ),
              SendMessageField(appointmentId as String),
            ],
          );
        },
      ),
    );
  }
}
