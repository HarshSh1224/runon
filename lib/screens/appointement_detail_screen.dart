import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runon/providers/appointments.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runon/screens/messages_screen.dart';

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
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
