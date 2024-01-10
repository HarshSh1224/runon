import 'package:flutter/material.dart';
import 'package:runon/screens/patient/new_appointment.dart';
import 'package:runon/screens/patient/offline_appointment.dart';
import 'package:runon/widgets/clip_paths.dart';
import 'package:runon/widgets/previous_appointments.dart';
import 'package:google_fonts/google_fonts.dart';

class AddAppointment extends StatelessWidget {
  static const routeName = '/add-appointment';
  const AddAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book an Appointment'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.supervised_user_circle_outlined,
              size: 32,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/consulting.jpg',
            fit: BoxFit.cover,
          ),
          ClipPath(
            clipper: OneThirdScreenCoverEllipse(0.2),
            child: Container(color: Theme.of(context).colorScheme.surfaceVariant),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.2,

            // bottom: MediaQuery.of(context).size.height * 0.5,
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(NewAppointment.routeName);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Online Appointment',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(OfflineAppointmentScreen.routeName);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Offline Appointment',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(child: PreviousAppointments()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
