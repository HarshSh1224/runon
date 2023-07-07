import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/appointments.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/providers/issue_data.dart';
import 'package:runon/widgets/method_slot_formatter.dart';
import 'package:runon/screens/appointment_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppointmentsScreen extends StatelessWidget {
  static const routeName = '/my-appointments-screen';
  MyAppointmentsScreen({super.key});
  List<Appointment> _myAppointments = [];

  Future<void> _fetchAppointments(
      Appointments appointmentsProvider, Auth auth, IssueData issue) async {
    await appointmentsProvider.fetchAndSetAppointments();
    print(_myAppointments);
    await issue.fetchAndSetIssues();
    _myAppointments = appointmentsProvider.getAppointmentsByPatientId(id: auth.userId!);
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsProvider = Provider.of<Appointments>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final issue = Provider.of<IssueData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
      ),
      body: FutureBuilder(
          future: _fetchAppointments(appointmentsProvider, auth, issue),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'All Appointments',
                            style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                              )
                            : Expanded(
                                child: ListView.builder(
                                    itemCount: _myAppointments.length,
                                    itemBuilder: ((context, index) {
                                      return Card(
                                        margin: const EdgeInsets.only(bottom: 20),
                                        elevation: 0,
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(horizontal: 20),
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                AppointmentDetailScreen.routeName,
                                                arguments: _myAppointments[index]);
                                          },
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                Theme.of(context).colorScheme.tertiaryContainer,
                                            child: Text(issue
                                                .issueFromId(_myAppointments[index].issueId)[0]),
                                          ),
                                          subtitle: Text(
                                            expandSlot(_myAppointments[index].slotId),
                                          ),
                                          title: Text(
                                              issue.issueFromId(_myAppointments[index].issueId)),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Transform.scale(
                                                scale: 0.8,
                                                child: UpcomingDeleteButton(_myAppointments[index]),
                                              ),
                                              const Icon(Icons.chevron_right_rounded),
                                            ],
                                          ),
                                        ),
                                      );
                                    })),
                              ),
                      ],
                    ),
                  );
          }),
    );
  }
}

class UpcomingDeleteButton extends StatelessWidget {
  const UpcomingDeleteButton(
    this._appointment, {
    super.key,
  });
  final Appointment _appointment;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.7,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: !_appointment.hasPassed
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.tertiary,
            side: BorderSide(
              color: !_appointment.hasPassed
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.tertiary,
            ),
          ),
          child: Text(_appointment.hasPassed ? 'Passed' : 'Upcoming'),
        ),
      ),
    );
  }
}
