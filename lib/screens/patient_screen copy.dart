import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/category_item.dart';

class PatientScreen extends StatelessWidget {
  static const routeName = '/patient-screen';
  const PatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var pageController = PageController(initialPage: 0, viewportFraction: 0.8);
    return Scaffold(
      drawer: Drawer(
        child: Container(),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.chat,
              size: 27,
            ),
            onPressed: () {},
          )
        ],
        leading: const Icon(Icons.menu, size: 30),
        centerTitle: true,
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        child: MediaQuery.of(context).size.width >
                MediaQuery.of(context).size.height
            ? Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      ' Hi Username!',
                      style: GoogleFonts.raleway(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    // child: CategoryItem(),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: PageView(
                        pageSnapping: false,
                        controller: pageController,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Card(
                              elevation: 6,
                              child: Text('Hello'),
                            ),
                          ),
                          Card(
                            elevation: 6,
                            child: Text('Hello'),
                          ),
                        ]),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      ' Hi Username!',
                      style: GoogleFonts.raleway(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      // height: 210,
                      constraints: const BoxConstraints(maxWidth: 350),
                      width: double.infinity,
                      child: Card(
                        color:
                            ColorScheme.fromSeed(seedColor: Color(0xFF028E81))
                                .secondaryContainer,
                        elevation: 6,
                        child: Column(children: [
                          Container(
                            height: 150,
                            width: double.infinity,
                            child: Card(
                              elevation: 3,
                              margin: EdgeInsets.zero,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/book_appoint.png',
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Book An Appointment',
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: ColorScheme.fromSeed(
                                          seedColor: Color(0xFF028E81))
                                      .secondary),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    constraints: const BoxConstraints(maxWidth: 500),
                    child:
                        PageView(controller: pageController, children: const [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Card(
                          elevation: 6,
                          child: Text('Hello'),
                        ),
                      ),
                      Card(
                        elevation: 6,
                        child: Text('Hello'),
                      ),
                    ]),
                  ),
                ],
              ),
      ),
    );
  }
}
