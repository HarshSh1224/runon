import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'youtube_player_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName="/home-screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16/9,
              autoPlay: true, 
              autoPlayInterval: const Duration(seconds: 5), 
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              enableInfiniteScroll: true,
              viewportFraction: 1.0, 
            ),
            items: [
              Image.network('https://thesportsrehab.com/img/slider_1.jpg'),
              Image.network('https://thesportsrehab.com/img/slider_2.jpg'),
              Image.network('https://thesportsrehab.com/img/slider_3.jpg'),
              Image.network('https://thesportsrehab.com/img/slider_4.jpg'),
            ],
          ),
          Expanded(
            child: ListView(
              children:const [
                YoutubePlayerItem(videoUrl: "https://youtu.be/81ICkO5f5DE?si=N-4BVn3FJ9fXSW7o"),
              ])
            ),
        ],
      ),
    );
  }
}

class YoutubePlayerItem extends StatelessWidget {
  final videoUrl;
  const YoutubePlayerItem({
    this.videoUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: (){
      Navigator.of(context).pushNamed(
        YoutubePlayerScreen.routeName,
        arguments: videoUrl,
        );
    },
    child: Card(
        margin: const EdgeInsets.all(15),
      child:Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 350, maxHeight: 250),
      width: double.infinity,
      height: 180,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        image: DecorationImage(
          image: NetworkImage(
            "https://img.youtube.com/vi/81ICkO5f5DE/hqdefault.jpg",
            // "https://img.youtube.com/vi/<$videoId>/0.jpg",
            ),
          fit: BoxFit.fitWidth,
          ),),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text(
              "Flat Feet and Knock Knees",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                ),),              
          ],
        ),
          )
      ),
              );
  }
}