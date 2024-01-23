import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runon/screens/patient/new_appointment.dart';

class OfflineAppointmentScreen extends StatelessWidget {
  static const routeName = '/offline-appointment-screen';
  const OfflineAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _space20(),
            _selectOne(),
            _space20(),
            _space20(),
            Expanded(
              child: _card(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NewAppointment(isOffline: true),
                      ),
                    );
                  },
                  context: context,
                  title: 'Regular',
                  color: Colors.pink,
                  body:
                      'Book a regular offline appointment with the doctor. Reserve a slot in advance to avoid queues.',
                  image: 'assets/images/consulting.jpg',
                  align: TextAlign.start,
                  isFeatured: true),
            ),
            _space20(),
            // const Divider(
            //   thickness: 2,
            // ),
            _space20(),
            Expanded(
              child: _card(
                  onPressed: () {},
                  context: context,
                  title: 'Package',
                  color: Colors.blue,
                  body:
                      'Book a 10 Day curated package with the doctor. Pay in cash, Reserve in advance to avoid queues.',
                  image: 'assets/images/stetho.jpg',
                  align: TextAlign.start),
            ),
            _space20(),
            _space20(),
            _space20(),
          ],
        ),
      ),
    ));
  }

  Widget _card(
      {required BuildContext context,
      required String title,
      required String body,
      required String image,
      required TextAlign align,
      required Color color,
      bool isFeatured = false,
      required void Function()? onPressed}) {
    return Card(
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.asset(image).image,
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
            gradient: LinearGradient(
              transform: const GradientRotation(-0.5),
              colors: [
                Colors.black,
                color,
              ],
            ),
            color: Colors.black,
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isFeatured) _featured(align),
                          Text(
                            title,
                            textAlign: align,
                            style: GoogleFonts.raleway(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _space10(),
                      Text(
                        body,
                        textAlign: align,
                        style: GoogleFonts.raleway(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      _space10(),
                      _space10(),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(width: 1.0, color: Colors.white),
                              ),
                              onPressed: () {},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 11),
                                child: Text(
                                  'Details',
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.background,
                                backgroundColor: Theme.of(context).colorScheme.onBackground,
                              ),
                              onPressed: onPressed,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: FittedBox(
                                  child: Text(
                                    'Book Now',
                                    style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      // _infoText('BOOKINGS', '10K+'),
                      // const SizedBox(width: 10),
                      // _infoText('SLOTS', '30+'),
                    ],
                  )),
            ],
          )),
    );
  }

  Column _infoText(key, value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.sen(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          key,
          style: GoogleFonts.poppins(
            fontSize: 8,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Card _featured(TextAlign align) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
          // color: Colors.purpleAccent,
          gradient: LinearGradient(
            colors: [
              Colors.purple,
              Colors.pink,
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Text(
          'Bestseller',
          textAlign: align,
          style: GoogleFonts.raleway(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Container _packageAppointment() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  SizedBox _space20() {
    return const SizedBox(
      height: 20,
    );
  }

  SizedBox _space10() {
    return const SizedBox(
      height: 10,
    );
  }

  Widget _selectOne() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Text(
        'Choose One...',
        style: GoogleFonts.raleway(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
