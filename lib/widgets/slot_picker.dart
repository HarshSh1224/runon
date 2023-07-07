import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/slots.dart';
import '../widgets/slots_dialog.dart';
import '../providers/slot_timings.dart';

class SlotPicker extends StatefulWidget {
  final Function(String) _update;
  SlotPicker(
    this._update, {
    super.key,
  });

  @override
  State<SlotPicker> createState() => _SlotPickerState();
}

class _SlotPickerState extends State<SlotPicker> {
  final TextEditingController _pickedDate = TextEditingController();
  String? _chosenSlot;

  void _chooseSlot(String slotValue) {
    _chosenSlot = slotValue;
  }

  void datePickerFunction(Slots slots) async {
    if (slots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text('No slots available'),
      )));
      return;
    }
    final availDates = slots.onlyDates;
    final firstAvailDate = slots.firstAvailableDate;
    final temp = await showDatePicker(
        context: context,
        initialDate: firstAvailDate!,
        firstDate: firstAvailDate,
        lastDate: DateTime(2030),
        selectableDayPredicate: (DateTime val) {
          return availDates.contains(DateFormat('ddMMyyyy').format(val)) || val == firstAvailDate;
        });

    if (temp == null) return;
    // print();

    await showDialog(
      context: context,
      builder: (ctx) {
        return SlotDialog(
            update: _chooseSlot,
            temp: temp,
            context: context,
            slotsList: slots.slotTimes(DateFormat('ddMMyyyy').format(temp)));
      },
    );

    if (_chosenSlot == null) return;

    setState(
      () {
        // print(
        //     '${DateFormat('ddMMyyyy').format(temp)}${_chosenSlot!.length == 1 ? '0' : ''}$_chosenSlot');
        widget._update(
            '${DateFormat('ddMMyyyy').format(temp)}${_chosenSlot!.length == 1 ? '0' : ''}$_chosenSlot');
        _pickedDate.text =
            '${DateFormat('dd MMM').format(temp)} ${slotTimings[_chosenSlot]} - ${slotTimings[(int.parse(_chosenSlot!) + 1).toString()]}';
      },
    );
  }

  @override
  initState() {
    _pickedDate.text = 'No Slot Chosen';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Slots>(builder: (context, slots, ch) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              TextFormField(
                validator: (value) {
                  if (_pickedDate.text == 'No Slot Chosen') {
                    return 'Please choose a slot';
                  }
                  return null;
                },
                enabled: slots.isEmpty ? false : true,
                readOnly: true,
                controller: _pickedDate,
                style: TextStyle(
                    color: slots.isEmpty
                        ? Theme.of(context).colorScheme.outline.withOpacity(0.7)
                        : null),
                decoration: InputDecoration(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 130),
                  label: const Text('Pick a slot*'),
                  border: const OutlineInputBorder(),
                ),
              ),
              Positioned.fill(
                  child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: slots.isEmpty
                      ? null
                      : () {
                          datePickerFunction(slots);
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
              onPressed: slots.isEmpty
                  ? null
                  : () {
                      datePickerFunction(slots);
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
    });
  }
}
