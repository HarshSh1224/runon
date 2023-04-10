import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/appointments.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/providers/issue_data.dart';
import 'package:runon/screens/appointement_detail_screen.dart';
import 'package:runon/widgets/method_slot_formatter.dart';

class PreviousAppointments extends StatelessWidget {
  PreviousAppointments({super.key});
  List<Appointment> _myAppointments = [];

  Future<void> _fetchAppointments(
      Appointments appointmentsProvider, Auth auth, IssueData issue) async {
    await appointmentsProvider.fetchAndSetAppointments();
    await issue.fetchAndSetIssues();
    _myAppointments =
        appointmentsProvider.getAppointmentsByPatientId(auth.userId!);
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsProvider =
        Provider.of<Appointments>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final issue = Provider.of<IssueData>(context, listen: false);
    return FutureBuilder(
        future: _fetchAppointments(appointmentsProvider, auth, issue),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Previous Appointments',
                        style: TextStyle(
                            fontFamily: 'MoonBold',
                            color: Theme.of(context).colorScheme.outline,
                            letterSpacing: 2),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Text('Heoo')
                      // Expanded(
                      //   child: ListView(
                      //     children: [
                      //       Text('Hello'),
                      //       Text('Hello'),
                      //       Text('Hello'),
                      //       Card(
                      //         margin: EdgeInsets.only(bottom: 20),
                      //         elevation: 4,
                      //         child: ListTile(
                      //           onTap: () {
                      //             Navigator.of(context).pushNamed(
                      //                 AppointmentDetailScreen.routeName);
                      //           },
                      //           leading: CircleAvatar(
                      //             backgroundColor: Theme.of(context)
                      //                 .colorScheme
                      //                 .tertiaryContainer,
                      //             child: Text(issue.issueFromId(
                      //                 _myAppointments[0].issueId)[0]),
                      //           ),
                      //           title: Text(
                      //             expandSlot(_myAppointments[0].slotId),
                      //           ),
                      //           subtitle: Text(issue
                      //               .issueFromId(_myAppointments[0].issueId)),
                      //           trailing: Icon(Icons.chevron_right_rounded),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // )
                      _myAppointments.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.sailing_outlined,
                                      size: 50,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'No Appointments Found!',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: _myAppointments.length,
                                itemBuilder: ((context, index) {
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    elevation: 4,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            AppointmentDetailScreen.routeName);
                                      },
                                      leading: CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer,
                                        child: Text(issue.issueFromId(
                                            _myAppointments[index].issueId)[0]),
                                      ),
                                      title: Text(
                                        expandSlot(
                                            _myAppointments[index].slotId),
                                      ),
                                      subtitle: Text(issue.issueFromId(
                                          _myAppointments[index].issueId)),
                                      trailing: const Icon(
                                          Icons.chevron_right_rounded),
                                    ),
                                  );
                                }),
                              ),
                            ),
                    ],
                  ),
                );
        });
  }
}
