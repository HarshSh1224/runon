import 'package:flutter/material.dart';
import 'package:runon/utils/app_methods.dart';

class DocumentsScreen extends StatelessWidget {
  DocumentsScreen({required this.docsUrl, super.key});
  final List<String> docsUrl;
  final List<String> _fileNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: docsUrl.isEmpty ? _noDocsFound : _docsView,
      ),
    );
  }

  Widget get _docsView {
    return FutureBuilder(
        future: _getFileNames(),
        builder: (context, snapshot) {
          // print(docsUrl);
          return GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
            ),
            children: snapshot.connectionState == ConnectionState.waiting
                ? [
                    for (int i = 0; i < docsUrl.length; i++)
                      Card(
                        elevation: 0,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                  ]
                : [
                    for (int i = 0; i < docsUrl.length; i++)
                      GestureDetector(
                        onTap: () async => AppMethods.openFile(docsUrl[i], _fileNames[i]),
                        child: _docCard(_fileNames[i], context),
                      )
                  ],
          );
        });
  }

  Card _docCard(String title, context) {
    final fileExtension = title.contains('.') ? title.split('.')[1] : '';
    return Card(
      elevation: 0,
      color: Colors.red.withOpacity(0.1),
      child: Stack(
        children: [
          Positioned.fill(
            child: Icon(
              fileExtension == 'pdf'
                  ? Icons.picture_as_pdf_rounded
                  : ((fileExtension == 'jpeg' || fileExtension == 'jpg' || fileExtension == 'png')
                      ? Icons.image
                      : Icons.file_copy),
              size: 50,
              color: ColorScheme.fromSeed(seedColor: Colors.red).primary,
            ),
          ),
          Positioned.fill(
              child: Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.bottomCenter,
            child: Text(
              title,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ))
        ],
      ),
    );
  }

  Widget get _noDocsFound {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.file_copy_outlined,
            size: 40,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'No Documents Found',
          ),
        ],
      ),
    );
  }

  _getFileNames() async {
    for (int i = 0; i < docsUrl.length; i++) {
      final url = docsUrl[i];
      String? extensionn = await AppMethods.fileExtensionFromDownloadUrl(downloadUrl: url);
      if (extensionn == null) {
        extensionn = '';
      } else {
        extensionn = '.$extensionn';
      }
      _fileNames.add('attachment${i + 1}$extensionn');
    }
  }
}
