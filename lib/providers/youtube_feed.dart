import 'package:flutter/foundation.dart';
import 'package:runon/controllers/database.dart';

class YoutubeVideo {
  String thumbnail;
  String title;
  String url;
  List<String> tags;

  YoutubeVideo({
    required this.thumbnail,
    required this.title,
    required this.url,
    required this.tags,
  });

  factory YoutubeVideo.fromMap(Map<String, dynamic> map) {
    final tags = map['tags'].split(',') as List<String>;
    for (int i = 0; i < tags.length; i++) {
      tags[i] = tags[i].trim();
    }
    return YoutubeVideo(
      thumbnail: map['thumbnail'],
      title: map['title'],
      url: map['url'],
      tags: tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'thumb': thumbnail,
      'title': title,
      'url': url,
      'tags': List<String>.generate(tags.length, (index) => '${tags[index]},'),
    };
  }
}

class YoutubeFeed with ChangeNotifier {
  final List<YoutubeVideo> _youtubeVideos = [];
  final Set<String> _tags = {};

  List<YoutubeVideo> get youtubeVideos {
    return [..._youtubeVideos];
  }

  List<String> get tags {
    return [..._tags];
  }

  Future<void> fetchVideos() async {
    _youtubeVideos.clear();
    final videos = await Database.downloadYoutubeFeed();
    for (final video in videos) {
      _youtubeVideos.add(YoutubeVideo.fromMap(video));
      _tags.addAll(YoutubeVideo.fromMap(video).tags);
    }
  }

  void sortByTags(String tag) {
    _youtubeVideos.sort((YoutubeVideo a, YoutubeVideo b) {
      if (a.tags.contains(tag) && !b.tags.contains(tag)) {
        return -1;
      } else if (!a.tags.contains(tag) && b.tags.contains(tag)) {
        return 1;
      } else {
        return 0;
      }
    });
    notifyListeners();
  }
}
