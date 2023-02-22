import 'package:flutter/material.dart';
import 'package:runon/widgets/clip_paths.dart';

class AddAppointment extends StatelessWidget {
  static const routeName = '/add-appointment';
  const AddAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book an Appointment'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/consulting.jpg',
            fit: BoxFit.cover,
          ),
          ClipPath(
            clipper: OneThirdScreenCoverEllipse(),
            child: Container(color: Theme.of(context).colorScheme.background),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.2,

            // bottom: MediaQuery.of(context).size.height * 0.5,
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  FilledButton(
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text('New Appointment'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FilledButton(
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text('Follow up Appointment'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Prev Appointments'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
