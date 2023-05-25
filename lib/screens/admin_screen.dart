import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/auth.dart';
import '../widgets/clip_paths.dart';
import '../screens/profile_screen.dart';
import 'package:runon/widgets/side_drawer.dart';
import 'package:runon/widgets/category_item.dart';
import 'package:runon/screens/admin/manage_medical_teams.dart';

class AdminScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const routeName = '/admin-screen';
  AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    return Scaffold(
      drawer: const Drawer(
        backgroundColor: Colors.transparent,
        child: SideDrawer(),
      ),
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: Image.network(user.imageUrl ??
                      'https://firebasestorage.googleapis.com/v0/b/runon-c2c2e.appspot.com/o/profilePics%2Fdefault.jpg?alt=media&token=dbbd8628-1910-40dd-a2cc-fdf9ba86278e')
                  .image,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(ProfileScreen.routeName);
            },
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 30),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        centerTitle: true,
        title: const Text('Administrator'),
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: UpperEllipse(),
            child: Container(color: Theme.of(context).colorScheme.primary),
          ),
          ClipPath(
            clipper: LowerEllipse(),
            child: Container(color: Theme.of(context).colorScheme.secondaryContainer),
          ),
          FutureBuilder(
              future: user.tryLogin(),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                constraints: const BoxConstraints(maxHeight: 170),
                                padding: const EdgeInsets.only(left: 20),
                                child: PageView(
                                    padEnds: false,
                                    pageSnapping: true,
                                    controller: PageController(viewportFraction: 0.7),
                                    children: [
                                      _pageViewItemBuilder(
                                          'No of Patients',
                                          'assets/images/linechart.gif',
                                          Colors.white,
                                          0.8,
                                          'users'),
                                      _pageViewItemBuilder(
                                          'Active Appointments',
                                          'assets/images/graph2.png',
                                          Colors.black,
                                          0.5,
                                          'appointments'),
                                      _pageViewItemBuilder('Medical Teams:',
                                          'assets/images/graph.jpg', Colors.white, 0.7, 'doctors'),
                                      const SizedBox(
                                        width: 1,
                                      ),
                                    ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(ManageMedicalTeams.routeName);
                                  },
                                  child: const CategoryItem('assets/images/medicalteams.gif',
                                      'Manage Medical Teams', Colors.purpleAccent),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18.0),
                                child: CategoryItem('assets/images/generate.gif',
                                    'Generate User Accounts', Colors.blueAccent),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18.0),
                                child: CategoryItem('assets/images/appointments.jpg',
                                    'Active Appointments', Colors.pinkAccent),
                              ),
                            ],
                          ),
                        ),
                      );
              }),
        ],
      ),
    );
  }

  Widget _pageViewItemBuilder(
      String title, String imageUrl, Color color, double opacity, String collection) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: Card(
        color: color == Colors.white ? Colors.black : Colors.white,
        margin: const EdgeInsets.only(bottom: 15),
        elevation: 7,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Opacity(
                  opacity: opacity,
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                title,
                style: GoogleFonts.raleway(fontSize: 20, color: color),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                  child: FutureBuilder(
                      future: _fetchStats(collection),
                      builder: (context, snapshot) {
                        return snapshot.connectionState == ConnectionState.waiting
                            ? Center(
                                child: CircularProgressIndicator(
                                color: color,
                              ))
                            : Text(
                                snapshot.data!.toString(),
                                style: GoogleFonts.notoSans(
                                    fontSize: 60, fontWeight: FontWeight.bold, color: color),
                              );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<int> _fetchStats(String collection) async {
    var query = await FirebaseFirestore.instance.collection(collection).count().get();
    return query.count;
  }
}
