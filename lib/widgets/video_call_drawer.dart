import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:runon/models/flat_feet_options.dart';
import 'package:runon/providers/exercise_docs.dart';

class CallDrawer extends StatefulWidget {
  final Function(FeetObservations)? onChangedFeetObservations;
  final String appointmentId;
  final FeetObservations?
      feetObservations; // must be provided if onChangedFeetObservations is provided
  final TextEditingController prescriptionController;
  const CallDrawer(
      {super.key,
      this.onChangedFeetObservations,
      this.feetObservations,
      required this.prescriptionController,
      required this.appointmentId});

  @override
  State<CallDrawer> createState() => _CallDrawerState();
}

class _CallDrawerState extends State<CallDrawer> {
  @override
  Widget build(BuildContext context) {
    final exerciseDocsProvider = Provider.of<ExerciseDocuments>(context);
    List<ExerciseDocument> exerciseDocs = exerciseDocsProvider.exerciseDocuments;
    return Drawer(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Actions',
                style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: widget.prescriptionController,
                minLines: 5,
                maxLines: 7,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Enter prescription here',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (widget.feetObservations != null) ...[
                Text(
                  'Feet',
                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                _checkbox(
                  label: 'Flat Feet',
                  value: widget.feetObservations!.flatFeet,
                  onChanged: (value) {
                    setState(() {
                      widget.feetObservations!.flatFeet = value!;
                      widget.onChangedFeetObservations!(widget.feetObservations!);
                    });
                  },
                ),
                _checkbox(
                  label: 'Normal Arched',
                  value: widget.feetObservations!.normalArched,
                  onChanged: (value) {
                    setState(() {
                      widget.feetObservations!.normalArched = value!;
                      widget.onChangedFeetObservations!(widget.feetObservations!);
                    });
                  },
                ),
                _checkbox(
                  label: 'Low Arched',
                  value: widget.feetObservations!.lowArched,
                  onChanged: (value) {
                    setState(() {
                      widget.feetObservations!.lowArched = value!;
                      widget.onChangedFeetObservations!(widget.feetObservations!);
                    });
                  },
                ),
                _checkbox(
                  label: 'High Arched',
                  value: widget.feetObservations!.highArched,
                  onChanged: (value) {
                    setState(() {
                      widget.feetObservations!.highArched = value!;
                      widget.onChangedFeetObservations!(widget.feetObservations!);
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Knock Knees (Left)',
                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                _checkbox(
                  label: 'Normal',
                  value: widget.feetObservations!.leftNormal,
                  onChanged: (value) {
                    setState(() {
                      widget.feetObservations!.leftNormal = value!;
                      widget.onChangedFeetObservations!(widget.feetObservations!);
                    });
                  },
                ),
                _checkbox(
                  label: 'Knock Knee',
                  value: widget.feetObservations!.leftKnockKnee,
                  onChanged: (value) {
                    setState(() {
                      widget.feetObservations!.leftKnockKnee = value!;
                      widget.onChangedFeetObservations!(widget.feetObservations!);
                    });
                  },
                ),
                _checkbox(
                  label: 'Bow Leg',
                  value: widget.feetObservations!.leftBowLeg,
                  onChanged: (value) {
                    setState(() {
                      widget.feetObservations!.leftBowLeg = value!;
                      widget.onChangedFeetObservations!(widget.feetObservations!);
                    });
                  },
                ),
                _checkbox(
                  label: 'Recurvatum',
                  value: widget.feetObservations!.leftRecurvatum,
                  onChanged: (value) {
                    setState(() {
                      widget.feetObservations!.leftRecurvatum = value!;
                      widget.onChangedFeetObservations!(widget.feetObservations!);
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Knock Knees (Right)',
                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                _checkbox(
                  label: 'Normal',
                  value: widget.feetObservations!.rightNormal,
                  onChanged: (value) {
                    setState(() {
                      widget.feetObservations!.rightNormal = value!;
                      widget.onChangedFeetObservations!(widget.feetObservations!);
                    });
                  },
                ),
                _checkbox(
                  label: 'Knock Knee',
                  value: widget.feetObservations!.rightKnockKnee,
                  onChanged: (value) {
                    setState(() {
                      widget.feetObservations!.rightKnockKnee = value!;
                      widget.onChangedFeetObservations!(widget.feetObservations!);
                    });
                  },
                ),
                _checkbox(
                  label: 'Bow Leg',
                  value: widget.feetObservations!.rightBowLeg,
                  onChanged: (value) {
                    setState(() {
                      widget.feetObservations!.rightBowLeg = value!;
                      widget.onChangedFeetObservations!(widget.feetObservations!);
                    });
                  },
                ),
                _checkbox(
                  label: 'Recurvatum',
                  value: widget.feetObservations!.rightRecurvatum,
                  onChanged: (value) {
                    setState(() {
                      widget.feetObservations!.rightRecurvatum = value!;
                      widget.onChangedFeetObservations!(widget.feetObservations!);
                    });
                  },
                ),
              ],
              const SizedBox(
                height: 20,
              ),
              Text(
                'Send Sample Docs',
                style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 20,
              ),
              ...exerciseDocs.map((e) {
                return FilledButton.tonal(
                  onPressed: () =>
                      exerciseDocsProvider.sendExerciseDocument(e.id, widget.appointmentId),
                  child: Row(
                    children: [
                      Text(e.title),
                      const Spacer(),
                      Icon(e.isSent ?? false ? Icons.done : Icons.send)
                    ],
                  ),
                );
              }).toList()
            ]),
          ),
        ),
      ),
    );
  }

  Widget _checkbox(
      {required bool value, required String label, required Function(bool?) onChanged}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          value = !value;
          onChanged(value);
        });
      },
      child: Row(
        children: [
          SizedBox(
              height: 25,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
              )),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
