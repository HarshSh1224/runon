import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:runon/utils/prescription_pdf_methods.dart';

class AppMethods {
  static Future<File> gneratePrescriptionPdf({
    required String appointmentId,
    required String patientName,
    required String patientId,
    required String doctorName,
    required String doctorId,
    required String issue,
    required String date,
    required String prescription,
  }) async {
    final pdf = Document();
    final image = MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );

    pdf.addPage(MultiPage(
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
          GeneratePdfMethods.buildContent(prescription),
        ];
      }),
      footer: (context) => GeneratePdfMethods.buildFooter(),
    ));

    return _savePdfDocument(name: 'prescription.pdf', pdf: pdf);
  }

  static Future<File> _savePdfDocument({
    required String name,
    required Document pdf,
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
    final List<String> splitted1 = downloadUrl.split("%2F");
    final List<String> splitted2 = splitted1[1].split("?");
    final childId = splitted2[0];
    final List<String> splitted3 = splitted1[0].split("/o/");
    final path = splitted3[1];
    final ref = FirebaseStorage.instance.ref(path).child(childId);
    final metaData = await ref.getMetadata();
    final contentType = metaData.contentType;
    return contentType?.split('/')[1];
  }
}
