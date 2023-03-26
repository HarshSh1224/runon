import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KnockKneeScreen extends StatelessWidget {
  static const routeName = '/knock-knee-screen';
  const KnockKneeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knock Knee'),
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
                'Knock knees (genu valgum) is a condition in which the knees tilt inward while the ankles remain spaced apart. The condition is slightly more common in girls, though boys can develop it too. Knock knees are usually part of a child’s normal growth and development. Most young children have knock knees to some degree for a period of time, though in some children it is more visible.',
                style: GoogleFonts.raleway(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.network(
                'https://www.childrenshospital.org/sites/default/files/media_migration/086479a4-e839-4e9b-95c8-be8230eccfd8.png',
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'In rare cases, knock knees could be a sign of an underlying bone disease, particularly when the condition appears for the first time when a child is 6 or older.',
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
                'The symptoms of knock knees are visible when a child stands with their legs straight and toes pointed forward. Symptoms include: \n symmetric inward angulation of the knees, ankles, remain apart while the knees are touching, unusual walking pattern, outward rotated feet',
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
