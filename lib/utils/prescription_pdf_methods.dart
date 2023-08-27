import 'package:pdf/widgets.dart';
import 'package:runon/misc/constants/app_constants.dart';

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

  static Widget buildContent(prescription) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 40),
      Text('Prescription', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      SizedBox(height: 20),
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
}
