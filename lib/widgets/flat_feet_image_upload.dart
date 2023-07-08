import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';

class FlatFeetImageUploadBox extends StatefulWidget {
  final Function(PlatformFile) _update;
  const FlatFeetImageUploadBox(this._update, {super.key});

  @override
  State<FlatFeetImageUploadBox> createState() => _FlatFeetImageUploadBoxState();
}

class _FlatFeetImageUploadBoxState extends State<FlatFeetImageUploadBox> {
  PlatformFile? _file;

  void _filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'pdf',
        'doc',
        'docx',
        'png',
      ],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _file = file;
        widget._update(_file!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _filePicker,
      child: DottedBorder(
        color: Theme.of(context).colorScheme.outline,
        strokeCap: StrokeCap.round,
        radius: const Radius.circular(15),
        strokeWidth: 2,
        borderType: BorderType.RRect,
        dashPattern: const [7, 5, 7, 5],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: 100,
            width: 100,
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
            child: _file != null
                ? Image.file(
                    File(_file!.path!),
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.add,
                    size: 40,
                  ),
          ),
        ),
      ),
    );
  }
}
