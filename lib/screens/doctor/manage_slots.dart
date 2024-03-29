import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runon/providers/slots.dart';
import 'package:runon/providers/slot_timings.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:runon/widgets/method_slotId_to_DateTime.dart';
import 'package:runon/widgets/method_DateTime_to_slotId.dart';
import 'package:intl/intl.dart';

class ManageSlotsScreen extends StatefulWidget {
  static const routeName = '/manage-slots-screen';
  const ManageSlotsScreen({super.key});

  @override
  State<ManageSlotsScreen> createState() => _ManageSlotsScreenState();
}

class _ManageSlotsScreenState extends State<ManageSlotsScreen> {
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

  var slots = [];
  bool ensureOnce = false;

  Future<void> generateEventsList({String? doctorId}) async {
    events = {};
    if (ensureOnce) return;
    await Provider.of<Slots>(context, listen: false)
        .fetchSlots(doctorId ?? FirebaseAuth.instance.currentUser!.uid);
    List<String> dates = Provider.of<Slots>(context, listen: false).onlyDates;

    slots = Provider.of<Slots>(context, listen: false).onlyDates;

    // print(Provider.of<Slots>(context, listen: false).slotTimes(slots[0]));

    for (int i = 0; i < dates.length; i++) {
      final date = slotIdTodDateTime(dates[i]);
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
    String? doctorId;
    if (ModalRoute.of(context) != null) {
      doctorId = ModalRoute.of(context)!.settings.arguments as String?;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Slots'),
      ),
      body: FutureBuilder(
        future: ensureOnce ? null : generateEventsList(doctorId: doctorId),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    TableCalendar(
                      focusedDay: _today,
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 30)),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...slots.map((el) {
                              return isSameDay(slotIdTodDateTime(el), _today)
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                      child:
                                          // AppointmentListTile(el.appointmentId),
                                          Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Available Slots : ',
                                            style: TextStyle(fontFamily: 'MoonBold'),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Wrap(
                                            spacing: 0,
                                            children: [
                                              ...Provider.of<Slots>(context, listen: false)
                                                  .slotTimes(el)
                                                  .map((e) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(6.0),
                                                  child: Chip(
                                                    backgroundColor: Theme.of(context)
                                                        .colorScheme
                                                        .errorContainer,
                                                    label: Text(slotTimings[e]!),
                                                    deleteIcon: const Icon(
                                                      Icons.close,
                                                      size: 20,
                                                    ),
                                                    onDeleted: () {
                                                      Provider.of<Slots>(context, listen: false)
                                                          .removeSlot(
                                                              dateTimeToSlotId(_today),
                                                              e,
                                                              doctorId ??
                                                                  FirebaseAuth
                                                                      .instance.currentUser!.uid);
                                                      setState(() {
                                                        ensureOnce = false;
                                                      });
                                                    },
                                                  ),
                                                );
                                              }).toList(),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              // Padding(
                                              //   padding:
                                              //       const EdgeInsets.symmetric(
                                              //           vertical: 6.0),
                                              //   child: Chip(
                                              //     backgroundColor:
                                              //         Theme.of(context)
                                              //             .colorScheme
                                              //             .errorContainer,
                                              //     elevation: 4,
                                              //     label: const Text(''),
                                              //     deleteIcon:
                                              //         Transform.translate(
                                              //             offset: const Offset(
                                              //                 -9, -1),
                                              //             child: const Icon(
                                              //                 Icons.add)),
                                              //     onDeleted: () {},
                                              //   ),
                                              // )
                                            ],
                                          )
                                        ],
                                      ))
                                  : Container();
                            }).toList(),
                            // if (slots[.isEmpty])
                            //   Card(
                            //     elevation: 4,
                            //     child: IconButton(
                            //         onPressed: () {},
                            //         icon: const Icon(Icons.add)),
                            //   ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(13.0),
        child: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
          padding: const EdgeInsets.all(15),
          icon: const Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            var tempList = [];
            showDialog(
                context: context,
                builder: (ctx) {
                  return SlotsDialog(
                    doctorId: doctorId,
                    today: _today,
                    setstate: () => setState(() {
                      ensureOnce = false;
                    }),
                  );
                });
          },
        ),
      ),
    );
  }
}

class SlotsDialog extends StatefulWidget {
  const SlotsDialog({
    required this.today,
    this.doctorId,
    super.key,
    required this.setstate,
  });

  final DateTime today;
  final String? doctorId;
  final VoidCallback setstate;

  @override
  State<SlotsDialog> createState() => _SlotsDialogState();
}

class _SlotsDialogState extends State<SlotsDialog> {
  @override
  Widget build(BuildContext context) {
    final slots = Provider.of<Slots>(context);
    return AlertDialog(
      title: Text(DateFormat('dd MMM yyy').format(widget.today)),
      content: SingleChildScrollView(
        child: Wrap(children: [
          ...slotTimings.values.map((e) {
            return InkWell(
              onTap: () {
                if (!slots.isScheduled(dateTimeToSlotId(widget.today),
                    slotTimings.keys.firstWhere((element) => slotTimings[element] == e))) {
                  Provider.of<Slots>(context, listen: false).addSlot(
                      dateTimeToSlotId(widget.today),
                      slotTimings.keys.firstWhere((element) => slotTimings[element] == e),
                      widget.doctorId ?? FirebaseAuth.instance.currentUser!.uid);
                } else {
                  Provider.of<Slots>(context, listen: false).removeSlot(
                      dateTimeToSlotId(widget.today),
                      slotTimings.keys.firstWhere((element) => slotTimings[element] == e),
                      widget.doctorId ?? FirebaseAuth.instance.currentUser!.uid);
                }
                widget.setstate();
                // Navigator.of(context).pop();
              },
              child: Card(
                  color: slots.isScheduled(dateTimeToSlotId(widget.today),
                          slotTimings.keys.firstWhere((element) => slotTimings[element] == e))
                      ? Theme.of(context).colorScheme.inversePrimary
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(e),
                  )),
            );
          }).toList()
        ]),
      ),
    );
  }
}
