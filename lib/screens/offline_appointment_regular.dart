import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:runon/widgets/add_reports_box.dart';
import 'package:runon/widgets/slot_picker.dart';

class NewOfflineAppointment extends StatefulWidget {
  const NewOfflineAppointment({super.key});

  @override
  State<NewOfflineAppointment> createState() => _NewOfflineAppointmentState();
}

class _NewOfflineAppointmentState extends State<NewOfflineAppointment> {
  final TextEditingController _dateController = TextEditingController();
  DateTime _pickedDate = DateTime(1001);
  bool _hasPickedDate = false;

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Offline Appointment'),
        ),
        body: Column(
          children: [
            Image.asset(
              'assets/images/consulting.jpg',
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      TextFormField(
                        controller: _dateController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        readOnly: true,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          label: FittedBox(child: Text('Select Date')),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Positioned.fill(
                          child: GestureDetector(
                        onTap: () async {
                          final todayDate = DateTime(
                              DateTime.now().year, DateTime.now().month, DateTime.now().day);
                          final temp = await showDatePicker(
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            context: context,
                            initialDate: _firstDate(),
                            firstDate: _firstDate(),
                            lastDate: DateTime(2050),
                            selectableDayPredicate: (DateTime date) {
                              if (date == todayDate) {
                                return true;
                              }
                              if (date.weekday == DateTime.sunday ||
                                  date.weekday == DateTime.saturday) {
                                return false;
                              }
                              return true;
                            },
                          );

                          if (temp == null) return;
                          if (temp == todayDate &&
                              (todayDate.weekday == DateTime.saturday ||
                                  todayDate.weekday == DateTime.sunday)) return;
                          _pickedDate = temp;
                          _hasPickedDate = true;
                          setState(() {
                            _dateController.text = DateFormat('dd/MM/yyyy').format(temp);
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SlotPickerOnline(
                    onUpdate: (_) {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddReportsBox((p0) {}),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: FilledButton(
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Book Now',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

  DateTime _firstDate() => DateTime.now().add(const Duration(days: 1));
}
