import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:runon/models/flat_feet_options.dart';
import 'package:runon/utils/prescription_pdf_methods.dart';
import 'package:runon/payment_gateway/razorpay_options.dart' as rp;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AppMethods {
  static showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(message),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static Future<File> gneratePrescriptionPdf({
    required String appointmentId,
    required String patientName,
    required String patientId,
    required String doctorName,
    required String doctorId,
    required String issue,
    required String date,
    required String prescription,
    FeetObservations? feetObservations,
  }) async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );

    pdf.addPage(pw.MultiPage(
      build: ((context) {
        return [
          GeneratePdfMethods.buildTitle(image, appointmentId),
          GeneratePdfMethods.buildTable(
            appointmentId: appointmentId,
            patientName: patientName,
            patientId: patientId,
            doctorName: doctorName,
            doctorId: doctorId,
            issue: issue,
            date: date,
            prescription: prescription,
          ),
          GeneratePdfMethods.buildContent(prescription, feetObservations),
        ];
      }),
      footer: (context) => GeneratePdfMethods.buildFooter(),
    ));

    return _savePdfDocument(name: 'prescription.pdf', pdf: pdf);
  }

  static Future<File> _savePdfDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$name').writeAsBytes(bytes);
  }

  static Future openFile(String url, String name) async {
    final appStorage = await getTemporaryDirectory();
    final file = File('${appStorage.path}/$name');
    try {
      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            // receiveTimeout: const Duration(seconds: 0),
          ));
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (er) {
      print(er.toString());
    }
    OpenFile.open(file.path);
  }

  static Future<String?> fileExtensionFromDownloadUrl(
      {required String downloadUrl, bool isPrescription = false}) async {
    try {
      final List<String> splitted1 = downloadUrl.split("%2F");
      final List<String> splitted2 = splitted1[1].split("?");
      final childId = splitted2[0];
      final List<String> splitted3 = splitted1[0].split("/o/");
      final path = splitted3[1];
      final ref = FirebaseStorage.instance.ref(path).child(childId);
      final metaData = await ref.getMetadata();
      final contentType = metaData.contentType;
      return contentType?.split('/')[1];
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> requestRazorpayRefund({required String paymentId}) async {
    // request razorpay to refund the amount

    // Returns a map with 'status' : bool and 'remarks' : String. Remarks will be paymentId if status is true else error description

    try {
      print('https://api.razorpay.com/v1/payments/$paymentId/refund');
      print('Requesting refund for $paymentId');
      String username = rp.key;
      String password = dotenv.env['razorpay_key_secret']!;
      String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
      final response = await http.post(
        Uri.parse('https://api.razorpay.com/v1/payments/$paymentId/refund'),
        headers: {HttpHeaders.authorizationHeader: basicAuth},
      );
      // print(response.body.length);
      final responseJson = jsonDecode(response.body);
      if (responseJson.containsKey('errorr')) {
        print('Refund error: ');
        print(responseJson['error']['description'].toString());
        print('Requesting refund Failedddd');
        return {'status': false, 'remarks': responseJson['error']['description']};
      } else {
        print('Requesting refund Success');
        return {'status': true, 'remarks': responseJson['id']};
      }
    } catch (e) {
      print(e);
      return {'status': false, 'remarks': 'Something went wrong'};
    }
    // print(responseJson);
  }
}
