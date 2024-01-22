import 'package:flutter/material.dart';
import 'package:runon/providers/issue_data.dart';
import 'package:runon/screens/appointment_detail_screen.dart';
import 'package:runon/providers/appointments.dart';
import 'package:runon/widgets/method_slot_formatter.dart';
import 'package:provider/provider.dart';

class AppointmentListTile extends StatelessWidget {
  String appointmentId;
  AppointmentListTile(this.appointmentId, {super.key});

  @override
  Widget build(BuildContext context) {
    final issue = Provider.of<IssueData>(context, listen: false);
    final appointment =
        Provider.of<Appointments>(context, listen: false).getByAppointmentId(appointmentId);
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 4,
      child: ListTile(
        onTap: () {
          Navigator.of(context)
              .pushNamed(AppointmentDetailScreen.routeName, arguments: appointment);
        },
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          child: Text(issue.issueFromId(appointment.issueId)[0]),
        ),
        title: Text(
          expandSlot(appointment.slotId, appointment.isOffline),
        ),
        subtitle: Text(issue.issueFromId(appointment.issueId)),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
