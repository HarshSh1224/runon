import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/appointments.dart';
import 'package:runon/providers/issue_data.dart';
import 'package:runon/widgets/search.dart';
import 'package:runon/widgets/method_slot_formatter.dart';
import 'package:runon/screens/appointement_detail_screen.dart';

class AdminAppointments extends StatelessWidget {
  static const routeName = '/admin-appointments';
  AdminAppointments({super.key});
  List<Appointment> appointments = [];

  Future<void> _fetchAppointments(Appointments appointmentsProvider, IssueData issue) async {
    await appointmentsProvider.fetchAndSetAppointments();
    appointments = appointmentsProvider.appointments;
    await issue.fetchAndSetIssues();
    print(appointments);
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
                                            expandSlot(appointments[index].slotId),
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
    );
  }
}
