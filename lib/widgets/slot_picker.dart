import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/slots.dart';
import '../widgets/slots_dialog.dart';

class SlotPicker extends StatefulWidget {
  const SlotPicker({
    super.key,
  });

  @override
  State<SlotPicker> createState() => _SlotPickerState();
}

class _SlotPickerState extends State<SlotPicker> {
  final TextEditingController _pickedDate = TextEditingController();

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
          return availDates.contains(DateFormat('ddMMyyyy').format(val)) ||
              val == firstAvailDate;
        });

    // print();

    await showDialog(
        context: context,
        builder: (ctx) {
          return SlotDialog(
              temp: temp,
              context: context,
              slotsList:
                  slots.slotTimes('${DateFormat('ddMMyyyy').format(temp!)}'));
        });

    setState(
      () {
        _pickedDate.text = DateFormat('dd MMM').format(temp!);
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
                enabled: slots.isEmpty ? false : true,
                readOnly: true,
                controller: _pickedDate,
                style: TextStyle(
                    color: slots.isEmpty
                        ? Theme.of(context).colorScheme.outline.withOpacity(0.7)
                        : null),
                decoration: InputDecoration(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 130),
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
