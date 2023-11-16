import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:runon/extensions/string_extensions.dart';
import 'package:runon/providers/youtube_feed.dart';
import 'package:runon/screens/youtube_player_screen.dart';

class ExploreSection extends StatefulWidget {
  const ExploreSection({super.key});

  @override
  State<ExploreSection> createState() => _ExploreSectionState();
}

class _ExploreSectionState extends State<ExploreSection> {
  Future<void> _fetchAndSetData(YoutubeFeed youtubeFeed) async {
    await Future.delayed(const Duration(seconds: 1));
    await youtubeFeed.fetchVideos();
    _tags.addAll(youtubeFeed.tags);
    _didFetch = true;
  }

  final List<String> _tags = ['All'];
  final List<YoutubeVideo> _videos = [];
  int selectedTag = 0;
  bool _didFetch = false;
  @override
  Widget build(BuildContext context) {
    final YoutubeFeed youtubeFeed = Provider.of<YoutubeFeed>(context);
    return Container(
      color: Theme.of(context).colorScheme.background,
      width: double.infinity,
      child: FutureBuilder(
          future: _didFetch ? null : _fetchAndSetData(youtubeFeed),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting && !_didFetch
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      _subHeading('Explore'),
                      _tagsRow(youtubeFeed),
                      _youtubeRow(youtubeFeed),
                    ],
                  );
          }),
    );
  }

  Row _subHeading(title) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            title,
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  SingleChildScrollView _tagsRow(YoutubeFeed youtubeFeed) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 10),
          for (int i = 0; i < _tags.length; i++)
            tag(youtubeFeed, _tags[i], border: i == selectedTag)
        ],
      ),
    );
  }

  Widget tag(YoutubeFeed youtubeFeed, String text, {border = false}) {
    return GestureDetector(
      onTap: () => setState(() {
        youtubeFeed.sortByTags(text);
        selectedTag = _tags.indexOf(text);
      }),
      child: _card(
        border: border,
        minWidth: 50,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text.capitalize(), style: GoogleFonts.raleway(fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  SingleChildScrollView _youtubeRow(YoutubeFeed youtubeFeed) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          ...youtubeFeed.youtubeVideos.map(
            (e) => _youtubeCard(e),
          ),
        ],
      ),
    );
  }

  Widget _youtubeCard(YoutubeVideo video) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, YoutubePlayerScreen.routeName, arguments: video);
      },
      child: Column(
        children: [
          _card(
            height: 180,
            width: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(video.thumbnail, fit: BoxFit.cover),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -10),
            child: SizedBox(
              width: 250,
              child: Text(
                video.title,
                style: GoogleFonts.sen(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _card(
      {double? height,
      double? width,
      double? minWidth,
      Alignment? alignment,
      required Widget child,
      bool border = false}) {
    return Container(
        height: height,
        width: width,
        constraints: minWidth == null
            ? null
            : BoxConstraints(
                minWidth: minWidth,
              ),
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
        decoration: BoxDecoration(
          border: Border.all(
            color: border
                ? Theme.of(context).colorScheme.outline
                : Theme.of(context).colorScheme.surface,
            width: 2,
          ),
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.brightness == Brightness.dark
                  ? Colors.black
                  : Colors.grey,
              spreadRadius: 1,
              blurRadius: 20,
              offset: const Offset(0, 10), // changes position of shadow
            ),
          ],
        ),
        alignment: alignment,
        child: child);
  }
}
