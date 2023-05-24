import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttachmentCard extends StatelessWidget {
  final String title;
  final Color? color;
  final double height;
  const AttachmentCard({
    super.key,
    required this.title,
    required this.color,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height > 70 ? height + 50 : height + 30,
      width: height > 70 ? 200 : 150,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        child: Column(
          children: [
            Padding(
              padding: height == 70 ? const EdgeInsets.all(0) : const EdgeInsets.all(6),
              child: SizedBox(
                height: height,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/doc.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              title,
              style: GoogleFonts.raleway(),
            )
          ],
        ),
      ),
    );
  }
}
