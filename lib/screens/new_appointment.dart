import 'package:flutter/material.dart';
import 'package:runon/widgets/clip_paths.dart';
import 'package:runon/widgets/issue_dropdown.dart';

class NewAppointment extends StatelessWidget {
  static const routeName = '/new-appointment';
  const NewAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book an Appointment'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/newApntmnt.jpg',
            fit: BoxFit.cover,
          ),
          ClipPath(
            clipper: OneThirdScreenCoverEllipse(0.27),
            child: Container(color: Theme.of(context).colorScheme.background),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const IssueDropdown(),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: 'No Slot selected',
                      decoration: const InputDecoration(
                        label: Text('Pick a slot'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
