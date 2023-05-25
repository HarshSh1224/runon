import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/doctors.dart';

class ManageMedicalTeams extends StatelessWidget {
  static const routeName = '/manage-medical-teams';
  ManageMedicalTeams({super.key});

  List<Doctor> doctorsList = [];

  Future<void> _fetchDoctors(Doctors doctors) async {
    await doctors.fetchAndSetDoctors();
    doctorsList = doctors.doctors;
  }

  @override
  Widget build(BuildContext context) {
    final doctors = Provider.of<Doctors>(context, listen: false);
    // print(doctors);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Teams'),
      ),
      body: FutureBuilder(
          future: _fetchDoctors(doctors),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '   Available Teams',
                          style: GoogleFonts.raleway(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (ctx, index) {
                              return Card(
                                elevation: 8,
                                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  height: 170,
                                  // color: Colors.black,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Card(
                                          margin: EdgeInsets.zero,
                                          elevation: 6,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              'https://i2-prod.mirror.co.uk/interactives/article12645227.ece/ALTERNATES/s1200c/doctor.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            doctorsList[index].name,
                                            style: GoogleFonts.notoSans(
                                                fontWeight: FontWeight.bold, fontSize: 17),
                                          ),
                                          Text(
                                            doctorsList[index].qualifications,
                                            style: GoogleFonts.raleway(fontSize: 15),
                                          ),
                                          Text(
                                            'Fees : ${doctorsList[index].fees.toString()} per hr',
                                            style: GoogleFonts.notoSans(
                                                fontSize: 12, fontStyle: FontStyle.italic),
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              const SizedBox(
                                                width: 50,
                                              ),
                                              OutlinedButton(
                                                  onPressed: () {},
                                                  child: const Text('View Details')),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: doctorsList.length,
                          ),
                        )
                      ],
                    ),
                  );
          }),
    );
  }
}
