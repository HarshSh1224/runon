import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';

class FlatFeetImageUploadBox extends StatefulWidget {
  final Function(List<PlatformFile>) _update;
  const FlatFeetImageUploadBox(this._update, {super.key});

  @override
  State<FlatFeetImageUploadBox> createState() => _FlatFeetImageUploadBoxState();
}

class _FlatFeetImageUploadBoxState extends State<FlatFeetImageUploadBox> {
  final List<PlatformFile> _files = [];

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
      // print(file.path);
      setState(() {
        _files.add(file);
        widget._update(_files);
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
            color:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
            child: _files.isNotEmpty
                ? Image.file(
                    File(_files[0].path!),
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
