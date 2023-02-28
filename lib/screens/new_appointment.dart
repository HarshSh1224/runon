import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/doctors.dart';
import 'package:runon/providers/issue_data.dart';
import 'package:runon/providers/slots.dart';
import 'package:runon/widgets/clip_paths.dart';
import '../widgets/slot_picker.dart';
import 'package:runon/widgets/issue_dropdown.dart';
import 'package:runon/widgets/doctors_dropdown.dart';
import '../widgets/add_reports_box.dart';

class NewAppointment extends StatelessWidget {
  static const routeName = '/new-appointment';
  const NewAppointment({super.key});

  Future<void> _fetchIssueData(
      IssueData issueProvider, Doctors doctorsProvider) async {
    await issueProvider.fetchAndSetIssues();
    await doctorsProvider.fetchAndSetDoctors();
  }

  @override
  Widget build(BuildContext context) {
    final issueProvider = Provider.of<IssueData>(context, listen: false);
    final doctorsProvider = Provider.of<Doctors>(context, listen: false);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Slots(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Appointment'),
        ),
        body: FutureBuilder(
          future: _fetchIssueData(issueProvider, doctorsProvider),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: double.infinity,
                              child: Image.asset(
                                'assets/images/newApntmnt.jpg',
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            Positioned.fill(
                              child: ClipPath(
                                clipper: OnlyBottomEllipse(0.87),
                                child: Container(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  // child: Expanded(child: Text('Hello World')),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              IssueDropdown(issueProvider),
                              const SizedBox(
                                height: 20,
                              ),
                              DoctorsDropdown(doctorsProvider),
                              const SizedBox(
                                height: 20,
                              ),
                              SlotPicker(),
                              const SizedBox(
                                height: 20,
                              ),
                              const AddReportsBox(),
                              const SizedBox(
                                height: 40,
                              ),
                              FilledButton(
                                onPressed: () {},
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 15.0,
                                    horizontal: 80,
                                  ),
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              // Container(
                              //   height: 160,
                              //   width: double.infinity,
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(30),
                              //       border: Border.all(
                              //           color:
                              //               Theme.of(context).colorScheme.onBackground)),
                              // )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
