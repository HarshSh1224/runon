import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/slot_timings.dart';

class SlotDialog extends StatelessWidget {
  const SlotDialog({
    super.key,
    required this.temp,
    required this.context,
    required this.slotsList,
    required this.update,
  });

  final Function(String) update;
  final DateTime? temp;
  final BuildContext context;
  final List<String> slotsList;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Slots available on ${DateFormat('dd MMM').format(temp!)}',
        style: const TextStyle(fontSize: 20),
      ),
      content: Wrap(spacing: 5, children: [
        ...slotsList.map((element) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                update(element);
                Navigator.of(context).pop();
              },
              child: Chip(
                elevation: 2,
                padding: EdgeInsets.zero,
                label: Text(slotTimings[element]!),
                backgroundColor:
                    Theme.of(context).colorScheme.tertiaryContainer,
              ),
            ),
          );
        })
      ]),
      actions: [
        TextButton(
            onPressed: Navigator.of(context).pop, child: const Text('Cancel'))
      ],
    );
  }
}
