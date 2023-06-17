import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:runon/video_call/settings.dart';
import 'package:http/http.dart' as http;

class CallPage extends StatefulWidget {
  static const routeName = '/call-page';

  const CallPage({super.key});
  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  bool isInit = false;
  String tempToken = "Error Please restart the video call";
  AgoraClient _client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: appId,
      channelName: "test",
    ),
  );

  @override
  void didChangeDependencies() {
    if (!isInit) {
      isInit = true;
      // initAgora();
    }
    super.didChangeDependencies();
  }

  void initAgora() async {
    _client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
            // username: ,
            appId: appId,
            channelName: ModalRoute.of(context)!.settings.arguments as String,
            tempToken: tempToken
            // tokenUrl:
            //     "https://agora-node-tokenserver.run-onon1.repl.co/access_token?channelName=6pPJq7Tx2MJYX25pDjpN",
            ),
        enabledPermission: [Permission.camera, Permission.microphone]);
    await _client.initialize();
  }

  @override
  void dispose() async {
    super.dispose();
    Future.delayed(Duration.zero, () async {
      await _client.release();
    });
  }

  Future<void> getToken() async {
    String link =
        'https://agora-node-tokenserver.run-onon1.repl.co/access_token?channelName=${ModalRoute.of(context)!.settings.arguments}';
    try {
      final response = await http.get(Uri.parse(link));
      Map data = jsonDecode(response.body);
      tempToken = data["token"];
      initAgora();
    } catch (error) {
      debugPrint(error.toString());
    }
    if (tempToken.contains('Error')) _client.release();
  }

  @override
  Widget build(BuildContext context) {
    // channel = ModalRoute.of(context)!.settings.arguments as String;
    return FutureBuilder(
      future: getToken(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: const Text('Video Call'),
                  centerTitle: true,
                ),
                backgroundColor: Colors.black,
                body: Stack(
                  children: [
                    AgoraVideoViewer(
                      client: _client,
                      showNumberOfUsers: false,
                      layoutType: Layout.oneToOne,
                    ),
                    AgoraVideoButtons(
                      client: _client,
                      onDisconnect: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Call Ended'),
                            ),
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                    Text(
                      tempToken.contains('Error') ? tempToken : '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
