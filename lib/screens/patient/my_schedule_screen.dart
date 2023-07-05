import 'package:flutter/material.dart';
import 'package:runon/providers/appointments.dart';
import 'package:runon/providers/issue_data.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:runon/widgets/appointment_listtile.dart';
import 'package:runon/widgets/method_slotId_to_DateTime.dart';

class MyScheduleScreen extends StatefulWidget {
  static const routeName = '/my-schedule-screen';
  const MyScheduleScreen({super.key});

  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen> {
  DateTime _today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focussedDay) {
    setState(() {
      _today = day;
    });
  }

  Map<DateTime, List<String>> events = {
    // DateTime.utc(2023, 3, 2): ['Event 1'],
    // DateTime.utc(2023, 3, 2): ['Event 2'],
  };

  List<String> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  var appointments = [];
  bool ensureOnce = false;

  Future<void> generateEventsList() async {
    if (ensureOnce) return;
    await Provider.of<IssueData>(context, listen: false).fetchAndSetIssues();
    await Provider.of<Appointments>(context, listen: false).fetchAndSetAppointments();
    appointments = Provider.of<Appointments>(context, listen: false)
        .getAppointmentsByPatientId(id: FirebaseAuth.instance.currentUser!.uid);
    // print(events);

    for (int i = 0; i < appointments.length; i++) {
      final date = slotIdTodDateTime(appointments[i].slotId);
      if (events[date] != null) {
        events[date]!.add('value');
      } else {
        events[date] = ['value'];
      }
    }

    // print(events);
    ensureOnce = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Schedule'),
      ),
      body: FutureBuilder(
        future: ensureOnce ? null : generateEventsList(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    TableCalendar(
                      focusedDay: _today,
                      firstDay: DateTime.utc(2000),
                      lastDay: DateTime.utc(2050),
                      availableGestures: AvailableGestures.all,
                      selectedDayPredicate: (day) => isSameDay(day, _today),
                      onDaySelected: _onDaySelected,
                      eventLoader: _getEventsForDay,
                      headerStyle:
                          const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                      // eventLoader: ,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // if (events[_today] != null)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...appointments.map((el) {
                              // debugPrint('${slotIdTodDateTime(el.slotId)}  $_today');
                              return isSameDay(slotIdTodDateTime(el.slotId), _today)
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                      child: AppointmentListTile(el.appointmentId),
                                    )
                                  : Container();
                            }).toList()
                          ],
                        ),
                      ),
                    )
                  ],
                );
        },
      ),
    );
  }
}
