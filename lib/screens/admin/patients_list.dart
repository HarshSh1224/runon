import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runon/providers/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import './add_patients.dart';
class PatientsList extends StatelessWidget {
  static const routName = "/patients-list";
  const PatientsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Manage Patients"),
        ),
        body:
        FutureBuilder(
                  future: _getAllPatients(),
                  builder: (context, snapshot) {
                    List<Auth>? allpatients = snapshot.data;
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                   : Padding(
                    padding:
                        const EdgeInsets.only(top: 18.0, left: 18, right: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '   Enrolled Patients',
                          style: GoogleFonts.raleway(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          flex: 8,
                          child: ListView.builder(
                            itemBuilder: (ctx, index) {
                              return index == allpatients.length
                                  ? Card(
                                      elevation: 2,
                                      margin: const EdgeInsets.only(
                                          left: 18,
                                          right: 18,
                                          top: 10,
                                          bottom: 40),
                                      child: Container(
                                        // padding: const EdgeInsets.symmetric(
                                        //     horizontal: 20, vertical: 20),
                                        height: 170,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.76,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              scale: 1.4,
                                              opacity: 0.2,
                                              image: Image.network(
                                                'https://img.freepik.com/premium-vector/abstract-background-colorful-wavy-lines-blue-colors_444390-5163.jpg',
                                                // fit: BoxFit.fitWidth,
                                              ).image),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiaryContainer
                                              .withOpacity(0.85),
                                          borderRadius:
                                              BorderRadius.circular(13),
                                        ),
                                        child: Stack(
                                          children: [
                                            Center(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                    style: IconButton.styleFrom(
                                                        backgroundColor: Theme
                                                                .of(context)
                                                            .colorScheme
                                                            .tertiaryContainer),
                                                    onPressed: () {},
                                                    icon: const Icon(Icons.add,
                                                        size: 60),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .tertiary),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Add Patient',
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 18),
                                                ),
                                              ],
                                            )),
                                            Positioned.fill(
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pushNamed(AddPatients.routName);
                                                  },
                                                  splashColor: Colors.black12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Card(
                                      elevation: 8,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 4),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        height: 180,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              scale: 1.4,
                                              opacity: 0.15,                                            
                                              image: Image.asset(
                                                'assets/images/green_waves.png',
                                                fit: BoxFit.fitHeight,
                                                alignment: Alignment.topCenter,                                                
                                              ).image),
                                        ),
                                        // color: Colors.black,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Card(
                                                margin: EdgeInsets.zero,
                                                elevation: 6,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                    allpatients[index].imageUrl==null?"https://firebasestorage.googleapis.com/v0/b/runon-c2c2e.appspot.com/o/profilePics%2Fdefault.jpg?alt=media&token=dbbd8628-1910-40dd-a2cc-fdf9ba86278e":allpatients[index].imageUrl!,
                                                    // 'https://i2-prod.mirror.co.uk/interactives/article12645227.ece/ALTERNATES/s1200c/doctor.jpg',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${allpatients[index].fName!} ${allpatients[index].lName}",
                                                  style: GoogleFonts.notoSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17),
                                                ),
                                                Text(
                                                  "DOB: ${DateFormat('dd MMM yyyy').format(allpatients[index].dateOfBirth!)}",
                                                  style: GoogleFonts.robotoFlex(
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  "${allpatients[index].address}",
                                                  style: GoogleFonts.robotoFlex(
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  allpatients[index].gender=='M'?'Male':'Female',
                                                  style: GoogleFonts.robotoFlex(
                                                      fontSize: 15),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    allpatients[index].email as String,
                                                    style: GoogleFonts.robotoFlex(
                                                        fontSize: 15),
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                            },
                            itemCount: allpatients!.length + 1,
                          ),
                        ),
                      ],
                    ),
                  );
  }),
        );

  }
  Future<List<Auth>> _getAllPatients() async {
    final users = await FirebaseFirestore.instance.collection('users').get();
    List<Auth> allUsers = [];
    for (var doc in users.docs) {
      if (doc.data()['type'] == 0) {
        allUsers.add(Auth.fromMap(doc.data(), doc.id));
      }
    }
    return allUsers;
  }
}
