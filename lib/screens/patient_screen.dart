import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientScreen extends StatelessWidget {
  static const routeName = '/patient-screen';
  const PatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person,
              size: 30,
            ),
            onPressed: () {},
          )
        ],
        leading: const Icon(Icons.menu, size: 30),
        centerTitle: true,
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Column(
          children: [
            PageView(children: [
              Container(
                height: 50,
                width: 50,
                color: Colors.amber,
                constraints:
                    const BoxConstraints(maxHeight: 100, maxWidth: 100),
                // child: Card(
                //   elevation: 6,
                //   child: Text('Hello'),
                // ),
              )
            ]),
            Text(
              'Hi Username!',
              style: GoogleFonts.bebasNeue(),
            ),
          ],
        ),
      ),
    );
  }
}
