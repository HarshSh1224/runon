import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:runon/providers/appointments.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runon/screens/messages_screen.dart';
import 'package:runon/video_call/call.dart';
import 'package:runon/widgets/method_slot_formatter.dart';

class AppointmentDetailScreen extends StatelessWidget {
  static const routeName = '/appointment-detail-screen';
  AppointmentDetailScreen({super.key});

  final _appointmentData = {
    'patient': 'Loading...',
    'patientImage': '',
    'doctor': 'Loading...',
    'doctorImage':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6ILFjfb_VfmQr0Zd1ozwtBh_myghTAdRH2g&usqp=CAU',
    'issue': 'Loading...',
  };

  var _timeLine = [];

  Future<void> _fetchAndSetData(Appointment appointment) async {
    final patient = await FirebaseFirestore.instance
        .collection('users')
        .doc(appointment.patientId)
        .get();

    _appointmentData['patient'] =
        patient.data()!['fName'] + ' ' + patient.data()!['lName'];

    _appointmentData['patientImage'] = patient.data()!['imageUrl'];

    final doctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(appointment.doctorId)
        .get();

    _appointmentData['doctor'] = doctor.data()!['name'];

    final issue = await FirebaseFirestore.instance
        .collection('issues')
        .doc(appointment.issueId)
        .get();

    _appointmentData['issue'] = issue.data()!['title'];

    final timelineFetch = await FirebaseFirestore.instance
        .collection('appointments/${appointment.appointmentId}/timeline')
        .get();

    _timeLine = timelineFetch.docs;

    // debugPrint('HELLLLLLLL${timelineFetch.docs[0]['paymentId']}');
  }

  Widget _customWidgetBuilder(String type, String name, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 18.0,
          ),
          child: Text(
            type,
            style: GoogleFonts.raleway(),
          ),
        ),
        Row(
          children: [
            CircleAvatar(
              backgroundImage: Image.network(imageUrl).image,
            ),
            const SizedBox(
              width: 15,
            ),
            Flexible(
              child: Text(name,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600, fontSize: 18)),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Appointment appointment =
        ModalRoute.of(context)!.settings.arguments as Appointment;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MessagesScreen.routeName,
                    arguments: appointment.appointmentId);
              },
              icon: const Icon(Icons.chat))
        ],
      ),
      body: FutureBuilder(
        future: _fetchAndSetData(appointment),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _customWidgetBuilder(
                            'PATIENT',
                            _appointmentData['patient']!,
                            _appointmentData['patientImage']!),
                        _customWidgetBuilder(
                            'DOCTOR',
                            _appointmentData['doctor']!,
                            _appointmentData['doctorImage']!),
                        SizedBox(
                          width: double.infinity,
                          child: _customWidgetBuilder(
                              'ISSUE',
                              _appointmentData['issue']!,
                              'https://static.vecteezy.com/system/resources/previews/000/553/397/original/foot-cartoon-vector-icon.jpg'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'TIMELINE',
                          style: GoogleFonts.raleway(),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ..._timeLine.map((e) {
                          // e['createdOn'];
                          return Transform.translate(
                            offset: const Offset(10, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Transform.translate(
                                  offset: const Offset(0, 8),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 6,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                      Container(
                                        height: 175,
                                        width: 3,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  // child: Text('Date'),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('dd MMM yyyy').format(
                                            DateTime.parse(e['createdOn'])),
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text(
                                        'Payment Scuccessful Rs 700',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 100,
                                        width: 150,
                                        child: Card(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          elevation: 10,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 70,
                                                width: double.infinity,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.asset(
                                                      'assets/images/doc.png',
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment.topCenter,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'View Attachments',
                                                style: GoogleFonts.raleway(),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Upcoming Appointment on: ${expandSlot(appointment.slotId)}',
                          style: GoogleFonts.roboto(
                              color: Theme.of(context).colorScheme.outline,
                              fontStyle: FontStyle.italic,
                              fontSize: 18),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  CallPage.routeName,
                                  arguments: appointment.appointmentId);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Join Video Call',
                                style: TextStyle(fontSize: 18),
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
