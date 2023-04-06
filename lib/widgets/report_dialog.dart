import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportDialog extends StatefulWidget {
  String appointmentId, currId;
  ReportDialog(this.appointmentId, this.currId, {super.key});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseFirestore.instance.collection('reports').add({
        'message': _controller.text.trim(),
        'creatorId': widget.currId,
        'reportedId': widget.appointmentId,
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Reported Successfully.'),
      )));
    } catch (error) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Padding(
        padding: EdgeInsets.all(4.0),
        child: Text('An Error Occurred.'),
      )));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      title: Text(
        'Report Doctor?',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Why do you want to report this Doctor? ',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
          TextField(
            onChanged: ((value) {
              setState(() {});
            }),
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Type here'),
            // style: ,
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: _controller.text.trim().isEmpty ? null : _submit,
            child: _isLoading
                ? const SizedBox(
                    height: 25, width: 25, child: CircularProgressIndicator())
                : const Text('Report')),
      ],
    );
  }
}
