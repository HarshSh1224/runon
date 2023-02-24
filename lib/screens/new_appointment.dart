import 'package:flutter/material.dart';
import 'package:runon/widgets/clip_paths.dart';
import 'package:runon/widgets/issue_dropdown.dart';
import 'package:intl/intl.dart';
import '../widgets/add_reports_box.dart';

class NewAppointment extends StatelessWidget {
  static const routeName = '/new-appointment';
  NewAppointment({super.key});
  TextEditingController _pickedDate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _pickedDate.text = 'No Slot Chosen';
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Appointment'),
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              'assets/images/newApntmnt.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          ClipPath(
            clipper: OneThirdScreenCoverEllipse(0.27),
            child: Container(color: Theme.of(context).colorScheme.background),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    const IssueDropdown(),
                    const SizedBox(
                      height: 20,
                    ),
                    StatefulBuilder(builder: (context, setState) {
                      void datePickerFunction() async {
                        final temp = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030));
                        setState(() {
                          _pickedDate.text = DateFormat('dd MMM').format(temp!);
                        });
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFormField(
                            readOnly: true,
                            controller: _pickedDate,
                            decoration: InputDecoration(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 130),
                              label: Text('Pick a slot'),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(-6, 0),
                            child: IconButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer)),
                                onPressed: datePickerFunction,
                                padding: EdgeInsets.all(20),
                                icon: const Icon(
                                  Icons.calendar_month_rounded,
                                  size: 30,
                                )),
                          )
                        ],
                      );
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    AddReportsBox(),
                    SizedBox(
                      height: 30,
                    ),
                    FilledButton(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 80,
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
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
            ),
          ),
        ],
      ),
    );
  }
}
