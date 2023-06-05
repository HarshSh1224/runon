import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UserFeedbackScreen extends StatelessWidget {
  static const routeName = '/user-feedback-screen-admin';
  UserFeedbackScreen({super.key});

  List<Map<String, dynamic>> feedbacksList = [];

  Future<void> _fetchData() async {
    final fetchedData = await FirebaseFirestore.instance.collection('user_messages').get();
    print(fetchedData.docs[0].data()['body']);

    final List<Map<String, dynamic>> temp = [];

    for (int i = 0; i < fetchedData.docs.length; i++) {
      temp.add({
        'body': fetchedData.docs[i].data()['body'],
        'date': DateTime.parse(fetchedData.docs[i].data()['date']),
        'subject': fetchedData.docs[i].data()['subject'],
        'uid': fetchedData.docs[i].data()['uid'],
      });
    }

    feedbacksList = temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
      ),
      body: FutureBuilder(
          future: _fetchData(),
          builder: (builder, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Feedbacks',
                          style: GoogleFonts.raleway(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: feedbacksList.length,
                                itemBuilder: (ctx, index) {
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 7,
                                                child: Text(
                                                  feedbacksList[index]['subject'],
                                                  style: GoogleFonts.raleway(
                                                      fontWeight: FontWeight.bold, fontSize: 20),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    DateFormat('dd MMM yyy')
                                                        .format(feedbacksList[index]['date']),
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        color:
                                                            Theme.of(context).colorScheme.outline),
                                                  ))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '${'"' + feedbacksList[index]['body']}"',
                                            style: GoogleFonts.raleway(fontSize: 18),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'created by user : ${feedbacksList[index]['uid']}',
                                            style: GoogleFonts.inconsolata(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }))
                      ],
                    ),
                  );
          }),
    );
  }
}
