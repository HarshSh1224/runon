import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/slot_timings.dart';
import 'package:runon/widgets/slots_dialog.dart';
import '../providers/slots.dart';

class SlotPickerOffline extends StatefulWidget {
  final Function(String) onUpdate;
  const SlotPickerOffline({
    required this.onUpdate,
    super.key,
  });

  @override
  State<SlotPickerOffline> createState() => _SlotPickerOfflineState();
}

class _SlotPickerOfflineState extends State<SlotPickerOffline> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _slotController = TextEditingController();
  DateTime _pickedDate = DateTime(1001);
  String? _chosenSlot;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _slotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.slotsReceived!.slots);

    return Column(
      children: [
        _slotCalenderRow(context),
        Consumer<Slots>(builder: (context, slots, ch) {
          return _selectSlot(context, slots);
        }),
      ],
    );
  }

  Row _slotCalenderRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            TextFormField(
              validator: (value) {
                if (_dateController.text.isEmpty) {
                  return 'Please choose a Date';
                }
                return null;
              },
              readOnly: true,
              controller: _dateController,
              decoration: InputDecoration(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 130),
                  label: const Text('Choose a date'),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today_rounded)),
            ),
            Positioned.fill(
                child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  datePickerFunction();
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            )),
          ],
        ),
        Transform.translate(
          offset: const Offset(-6, 0),
          child: IconButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.secondaryContainer)),
            onPressed: () {
              datePickerFunction();
            },
            padding: const EdgeInsets.all(20),
            icon: const Icon(
              Icons.calendar_month_rounded,
              size: 30,
            ),
          ),
        )
      ],
    );
  }

  Widget _selectSlot(BuildContext context, Slots slots) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              TextFormField(
                validator: (value) {
                  if (_slotController.text.isEmpty) {
                    return 'Choose a slot';
                  }
                  return null;
                },
                readOnly: true,
                controller: _slotController,
                enabled: !slots.isEmpty,
                decoration: InputDecoration(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 130),
                    label: const Text('Choose a slot'),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.access_time_rounded)),
              ),
              Positioned.fill(
                  child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _chooseSlotDialog(slots);
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              )),
            ],
          ),
          Transform.translate(
            offset: const Offset(-6, 0),
            child: IconButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.secondaryContainer)),
              onPressed: () {
                _chooseSlotDialog(slots);
              },
              padding: const EdgeInsets.all(20),
              icon: const Icon(
                Icons.more_time_sharp,
                size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }

  void datePickerFunction() async {
    // if (slots.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Padding(
    //     padding: EdgeInsets.symmetric(vertical: 8.0),
    //     child: Text('No slots available'),
    //   )));
    //   return;
    // }
    final todayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
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
        if (date.weekday == DateTime.sunday || date.weekday == DateTime.saturday) {
          return false;
        }
        return true;
      },
    );

    if (temp == null) return;
    if (temp == todayDate &&
        (todayDate.weekday == DateTime.saturday || todayDate.weekday == DateTime.sunday)) return;
    _pickedDate = temp;
    setState(() {
      _chosenSlot = null;
      _dateController.text = DateFormat('dd MMMM').format(temp);
      _slotController.text = '';
    });
    _loadSlots(DateFormat('ddMMyyyy').format(temp));
  }

  _showMessage(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  _chooseSlotDialog(Slots slots) async {
    if (_pickedDate.isBefore(DateTime.now())) {
      _showMessage(context, 'Choose a date');
      return;
    } else if (slots.isEmpty) {
      _showMessage(context, 'All slots are booked for selected date');
      return;
    }

    await showDialog(
      context: context,
      builder: (ctx) {
        return SlotDialog(
            update: (slot) {
              _chosenSlot = slot;
            },
            date: _pickedDate,
            offline: true,
            context: context,
            slotsList: slots.slotTimes(DateFormat('ddMMyyyy').format(_pickedDate)));
      },
    );
    if (_chosenSlot == null) return;
    setState(
      () {
        widget.onUpdate(
            '${DateFormat('ddMMyyyy').format(_pickedDate)}${_chosenSlot!.length == 1 ? '0' : ''}$_chosenSlot');
        _slotController.text =
            '${slotTimings(key: _chosenSlot!, offline: true)} - ${slotTimings(key: (int.parse(_chosenSlot!) + 1).toString(), offline: true)}';
      },
    );
  }

  Future<void> _loadSlots(String date) async {
    await Provider.of<Slots>(context, listen: false).fetchOfflineSlots(date);
  }

  DateTime _firstDate() => DateTime.now().add(const Duration(days: 1));
}
