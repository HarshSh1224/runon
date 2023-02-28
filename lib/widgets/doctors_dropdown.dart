import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/doctors.dart';
import 'package:runon/providers/slots.dart';

class DoctorsDropdown extends StatefulWidget {
  final Doctors _doctors;
  const DoctorsDropdown(this._doctors, {super.key});

  @override
  State<DoctorsDropdown> createState() => _DoctorsDropdownState();
}

class _DoctorsDropdownState extends State<DoctorsDropdown> {
  Future<void> _fetchSlots(Slots slotsProvider, String doctorId) async {
    slotsProvider.fetchSlots(doctorId).then((_) {
      Navigator.of(context).pop();
    });
  }

  String? _selectedValue;
  @override
  Widget build(BuildContext context) {
    final slotsProvider = Provider.of<Slots>(context, listen: false);

    return DropdownButtonFormField(
      hint: const Text('Choose a doctor'),
      decoration: const InputDecoration(
        label: Text('Select a Doctor*'),
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
      value: _selectedValue,
      items: [
        ...widget._doctors.doctors.map((e) {
          return DropdownMenuItem(
            value: e.id,
            child: Row(
              children: [
                Text(e.name),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  '(${e.qualifications})',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          );
        }),
        // DropdownMenuItem(child: Text)
      ],
      onChanged: (value) async {
        await showDialog(
          context: context,
          builder: (_) {
            _fetchSlots(slotsProvider, value!);
            return const AlertDialog(
                content: SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator())));
          },
        );
        setState(() {
          _selectedValue = value;
        });
      },
    );
  }
}
