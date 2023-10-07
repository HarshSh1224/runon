import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:runon/misc/constants/app_constants.dart';
import 'package:runon/models/flat_feet_options.dart';

class GeneratePdfMethods {
  static Widget buildTitle(image, appointmentId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image, height: 40),
        SizedBox(height: 20),
        Row(children: [
          Text(
            'Appointment Id: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            appointmentId,
          ),
        ]),
        SizedBox(height: 10),
      ],
    );
  }

  static Widget buildTable({
    required String appointmentId,
    required String patientName,
    required String patientId,
    required String doctorName,
    required String doctorId,
    required String issue,
    required String date,
    required String prescription,
  }) {
    const tablePadding = EdgeInsets.symmetric(horizontal: 5, vertical: 2);
    return Table(
        border: TableBorder.all(
          width: 0.5,
        ),
        children: [
          TableRow(children: [
            Padding(
                padding: tablePadding,
                child: Text('Patient Name: ', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: tablePadding, child: Text(patientName)),
            Padding(
                padding: tablePadding,
                child: Text('Doctor Name: ', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: tablePadding, child: Text(doctorName)),
          ]),
          TableRow(children: [
            Padding(
                padding: tablePadding,
                child: Text('Patient Id: ', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: tablePadding, child: Text(patientId)),
            Padding(
                padding: tablePadding,
                child: Text('Doctor Id: ', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: tablePadding, child: Text(doctorId)),
          ]),
          TableRow(children: [
            Padding(
                padding: tablePadding,
                child: Text('Issue: ', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: tablePadding, child: Text(issue)),
            Padding(
                padding: tablePadding,
                child: Text('Date: ', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: tablePadding, child: Text(date)),
          ]),
        ]);
  }

  static Widget buildContent(prescription, FeetObservations? feetObservations) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 40),
      Text('Prescription', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      if (feetObservations != null) buildFeetObservations(feetObservations),
      SizedBox(height: 10),
      Text(prescription),
    ]);
  }

  static Widget buildFooter() {
    return Column(children: [
      Divider(),
      Text(AppConstants.appWebsite),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Contact us: '),
          Text(AppConstants.appHelpEmail, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      Text('Phone: ${AppConstants.appPhoneNumber}'),
    ]);
  }

  static buildFeetObservations(FeetObservations feetObservations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text('Feet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(children: [
          Row(children: [
            Checkbox(activeColor: PdfColors.green, value: feetObservations.flatFeet, name: 'Hello'),
            SizedBox(width: 10),
            Text('FlatFeet'),
          ]),
          Row(children: [
            SizedBox(width: 15),
            Checkbox(
                activeColor: PdfColors.green, value: feetObservations.highArched, name: 'Hello'),
            SizedBox(width: 10),
            Text('High Arched'),
          ]),
          Row(children: [
            SizedBox(width: 15),
            Checkbox(
                activeColor: PdfColors.green, value: feetObservations.normalArched, name: 'Hello'),
            SizedBox(width: 10),
            Text('Normal Arched'),
          ]),
          Row(children: [
            SizedBox(width: 15),
            Checkbox(
                activeColor: PdfColors.green, value: feetObservations.lowArched, name: 'Hello'),
            SizedBox(width: 10),
            Text('Low Arched'),
          ]),
        ]),
        SizedBox(height: 20),
        Text('Knock Knees', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(children: [
          Text('Left -   '),
          Row(children: [
            SizedBox(width: 15),
            Checkbox(
                activeColor: PdfColors.green, value: feetObservations.leftKnockKnee, name: 'Hello'),
            SizedBox(width: 10),
            Text('Knock Knees'),
          ]),
          Row(children: [
            SizedBox(width: 15),
            Checkbox(
                activeColor: PdfColors.green, value: feetObservations.leftBowLeg, name: 'Hello'),
            SizedBox(width: 10),
            Text('Bow Leg'),
          ]),
          Row(children: [
            SizedBox(width: 15),
            Checkbox(
                activeColor: PdfColors.green, value: feetObservations.leftNormal, name: 'Hello'),
            SizedBox(width: 10),
            Text('Normal'),
          ]),
          Row(children: [
            SizedBox(width: 15),
            Checkbox(
                activeColor: PdfColors.green,
                value: feetObservations.leftRecurvatum,
                name: 'Hello'),
            SizedBox(width: 10),
            Text('Recurvatum'),
          ]),
        ]),
        SizedBox(height: 6),
        Row(children: [
          Text('Right - '),
          SizedBox(width: 15),
          Checkbox(
              activeColor: PdfColors.green, value: feetObservations.rightKnockKnee, name: 'Hello'),
          SizedBox(width: 10),
          Text('Knock Knees'),
          Row(children: [
            SizedBox(width: 15),
            Checkbox(
                activeColor: PdfColors.green, value: feetObservations.rightBowLeg, name: 'Hello'),
            SizedBox(width: 10),
            Text('Bow Leg'),
          ]),
          Row(children: [
            SizedBox(width: 15),
            Checkbox(
                activeColor: PdfColors.green, value: feetObservations.rightNormal, name: 'Hello'),
            SizedBox(width: 10),
            Text('Normal'),
          ]),
          Row(children: [
            SizedBox(width: 15),
            Checkbox(
                activeColor: PdfColors.green,
                value: feetObservations.rightRecurvatum,
                name: 'Hello'),
            SizedBox(width: 10),
            Text('Recurvatum'),
          ]),
        ]),
        SizedBox(height: 30),
        Text('Remarks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
