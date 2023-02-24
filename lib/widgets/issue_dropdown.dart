import 'package:flutter/material.dart';
import 'package:runon/providers/issue_data.dart';

class IssueDropdown extends StatefulWidget {
  const IssueDropdown({super.key});

  @override
  State<IssueDropdown> createState() => _IssueDropdownState();
}

class _IssueDropdownState extends State<IssueDropdown> {
  String? _selectedValue = null;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      hint: const Text('Choose an issue'),
      decoration: const InputDecoration(
        label: Text('Select an Issue'),
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
      value: _selectedValue,
      items: [
        ...issueData.map((e) {
          return DropdownMenuItem(
            value: e['id'],
            child: Text(e['title']!),
          );
        }),
        // DropdownMenuItem(child: Text)
      ],
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
      },
    );
  }
}
