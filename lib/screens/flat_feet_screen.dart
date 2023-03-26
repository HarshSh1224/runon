import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlatFeetScreen extends StatelessWidget {
  static const routeName = '/flat-feet-screen';
  const FlatFeetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flat Feet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'OVERVIEW',
                style: GoogleFonts.raleway(
                    fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Flatfeet is a common condition, also known as flatfoot, in which the arches on the inside of the feet flatten when pressure is put on them. When people with flatfeet stand up, the feet point outward, and the entire soles of the feet fall and touch the floor.',
                style: GoogleFonts.raleway(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.network(
                  'https://www.mayoclinic.org/-/media/kcms/gbs/patient-consumer/images/2013/08/26/10/33/ds00449_im02182_mcdc7_flatfeetthu_jpg.jpg'),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Flatfeet can occur when the arches don\'t develop during childhood. It can also develop later in life after an injury or from the simple wear-and-tear stresses of age.\n\nFlatfeet is usually painless. If you aren\'t having pain, no treatment is necessary. However, if flatfeet is causing you pain and limiting what you want to do, then an evaluation from a specialist may be warranted.',
                style: GoogleFonts.raleway(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'SYMPTOMS',
                style: GoogleFonts.raleway(
                    fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Most people have no symptoms associated with flatfeet. But some people with flatfeet experience foot pain, particularly in the heel or arch area. Pain may worsen with activity. Swelling may occur along the inside of the ankle.',
                style: GoogleFonts.raleway(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'CAUSES',
                style: GoogleFonts.raleway(
                    fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Flatfeet is not unusual in infants and toddlers, because the foot\'s arch hasn\'t yet developed. Most people\'s arches develop throughout childhood, but some people never develop arches. People without arches may or may not have problems.',
                style: GoogleFonts.raleway(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
