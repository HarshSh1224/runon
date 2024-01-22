import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/appointments.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/providers/issue_data.dart';
import 'package:runon/screens/patient/new_appointment.dart';
import 'package:runon/widgets/search.dart';
import 'package:runon/widgets/method_slot_formatter.dart';
import 'package:runon/screens/appointment_detail_screen.dart';

class AdminAppointments extends StatelessWidget {
  static const routeName = '/admin-appointments';
  AdminAppointments({super.key});
  List<Appointment> appointments = [];

  Future<void> _fetchAppointments(Appointments appointmentsProvider, IssueData issue) async {
    await appointmentsProvider.fetchAndSetAppointments();
    appointments = appointmentsProvider.appointments;
    await issue.fetchAndSetIssues();
    // print(appointments);
  }

  String? initValue;

  @override
  Widget build(BuildContext context) {
    Appointments appointmentsProvider = Provider.of<Appointments>(context, listen: false);
    final issue = Provider.of<IssueData>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: FutureBuilder(
          future: _fetchAppointments(appointmentsProvider, issue),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : StatefulBuilder(builder: (context, setState) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      // child: SingleChildScrollView(
                      child: appointments.isEmpty
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'All Appointments',
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                SearchDialog(
                                    initValue: initValue,
                                    onSearch: (text) {
                                      if (text.isEmpty) {
                                        initValue = null;
                                        setState(() {
                                          appointments = appointmentsProvider.appointments;
                                        });
                                        return;
                                      }
                                      initValue = text;
                                      setState(() {
                                        appointments = appointmentsProvider.appointments
                                            .where((element) =>
                                                element.patientId == text ||
                                                element.doctorId == text ||
                                                element.appointmentId == text)
                                            .toList();
                                      });
                                    },
                                    hintText: 'Search by id'),
                                const SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.sailing_outlined,
                                          size: 50,
                                          color: Theme.of(context).colorScheme.outline,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'No Appointments Found!',
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: appointments.length + 1,
                              itemBuilder: ((context, index) {
                                index--;
                                return index == -1
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'All Appointments',
                                            style: GoogleFonts.raleway(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          SearchDialog(
                                            initValue: initValue,
                                            onSearch: (text) {
                                              if (text.isEmpty) {
                                                initValue = null;
                                                setState(() {
                                                  appointments = appointmentsProvider.appointments;
                                                });
                                                return;
                                              }
                                              initValue = text;
                                              setState(() {
                                                appointments = appointmentsProvider.appointments
                                                    .where((element) =>
                                                        element.patientId == text ||
                                                        element.doctorId == text ||
                                                        element.appointmentId == text)
                                                    .toList();
                                              });
                                            },
                                            hintText: 'Search by id',
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      )
                                    : Card(
                                        margin: const EdgeInsets.only(bottom: 20),
                                        elevation: 4,
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                AppointmentDetailScreen.routeName,
                                                arguments: appointments[index]);
                                          },
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                Theme.of(context).colorScheme.tertiaryContainer,
                                            child: Text(
                                                issue.issueFromId(appointments[index].issueId)[0]),
                                          ),
                                          title: Text(
                                            expandSlot(appointments[index].slotId,
                                                appointments[index].isOffline),
                                          ),
                                          subtitle:
                                              Text(issue.issueFromId(appointments[index].issueId)),
                                          trailing: const Icon(Icons.chevron_right_rounded),
                                        ),
                                      );
                              }),
                            ),
                    );
                  });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onFloatingActionButtonPressed(context),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onFloatingActionButtonPressed(context) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text('Select Patient'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: FutureBuilder(
                  future: _getAllPatients(),
                  builder: (context, snapshot) {
                    List<Auth>? allUsers = snapshot.data;
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...allUsers!.map((e) {
                                  return ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => NewAppointment(
                                          patient: e,
                                          isOffline: false,
                                        ),
                                      ));
                                    },
                                    leading: CircleAvatar(
                                      backgroundImage: e.imageUrl == null
                                          ? null
                                          : Image.network(e.imageUrl!).image,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.tertiaryContainer,
                                      child: e.imageUrl == null
                                          ? Text(e.fName![0].toUpperCase())
                                          : null,
                                    ),
                                    title: Text('${e.fName!} ${e.lName!}'),
                                    subtitle: Text(e.email!),
                                  );
                                }).toList()
                              ],
                            ),
                          );
                  }),
            ),
          );
        }));
  }

  Future<List<Auth>> _getAllPatients() async {
    final users = await FirebaseFirestore.instance.collection('users').get();
    List<Auth> allUsers = [];
    for (var doc in users.docs) {
      if (doc.data()['type'] == 0) {
        allUsers.add(Auth.fromMap(doc.data(), doc.id));
      }
    }
    return allUsers;
  }
}
