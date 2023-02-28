import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SlotDialog extends StatelessWidget {
  const SlotDialog({
    super.key,
    required this.temp,
    required this.context,
    required this.slotsList,
  });

  final DateTime? temp;
  final BuildContext context;
  final List<String> slotsList;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Slots available on ${DateFormat('dd MMM').format(temp!)}',
        style: TextStyle(fontSize: 20),
      ),
      content: Wrap(spacing: 5, children: [
        ...slotsList.map((element) {
          return Chip(
            elevation: 2,
            padding: EdgeInsets.zero,
            label: Text(element),
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          );
        })
      ]),
      actions: [
        TextButton(
            onPressed: Navigator.of(context).pop, child: const Text('Close'))
      ],
    );
  }
}
