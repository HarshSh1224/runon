import 'package:flutter/material.dart';
import 'package:runon/providers/youtube_feed.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerScreen extends StatefulWidget {
  static const routeName = "/youtube-player-screen";

  const YoutubePlayerScreen({super.key});

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _ytController;
  late YoutubeVideo video;

  @override
  void didChangeDependencies() {
    video = ModalRoute.of(context)!.settings.arguments as YoutubeVideo;
    final videoUrl = video.url;
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    _ytController = YoutubePlayerController(
        initialVideoId: videoId as String,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(video.title),
      ),
      body: Column(
        children: [
          YoutubePlayer(
              controller: _ytController,
              showVideoProgressIndicator: true,
              aspectRatio: 16 / 9,
              progressColors: const ProgressBarColors(
                handleColor: Colors.red,
                playedColor: Colors.redAccent,
              )),
        ],
      ),
    );
  }
}
