import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerScreen extends StatefulWidget {
  static const routeName="/youtube-player-screen";

  const YoutubePlayerScreen({super.key});

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _ytController;

  @override
  void didChangeDependencies() {
    final videoUrl =ModalRoute.of(context)!.settings.arguments as String;
    final videoId=YoutubePlayer.convertUrlToId(videoUrl);
    _ytController=YoutubePlayerController(
      initialVideoId: videoId as String,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      )
      );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Youtube Title"),
      ),
      body:Column(
            children: [
              YoutubePlayer(
                controller: _ytController,
                showVideoProgressIndicator: true,
                aspectRatio: 16/9,
                progressColors: const ProgressBarColors(
                  handleColor: Colors.red,
                  playedColor: Colors.redAccent,
                  )
                ),
          ],
          ),
    );
  }
}