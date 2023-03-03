import 'package:flutter/material.dart';
import 'package:runon/providers/issue_data.dart';

class IssueDropdown extends StatefulWidget {
  final IssueData _issueData;
  Function(String) _update;
  IssueDropdown(this._issueData, this._update, {super.key});

  @override
  State<IssueDropdown> createState() => _IssueDropdownState();
}

class _IssueDropdownState extends State<IssueDropdown> {
  String? _selectedValue;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      validator: (value) {
        if (value == null) return 'Please select a problem';
        return null;
      },
      hint: const Text('Choose an issue'),
      decoration: const InputDecoration(
        label: Text('Select an Issue*'),
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
      value: _selectedValue,
      items: [
        ...widget._issueData.issueData.map((e) {
          return DropdownMenuItem(
            value: e.id,
            child: Text(e.title),
          );
        }),
        // DropdownMenuItem(child: Text)
      ],
      onSaved: (value) {
        // print('Saving issue');
        widget._update(value!);
      },
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
      },
    );
  }
}
