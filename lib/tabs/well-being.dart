import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '/services/llm_services.dart';

class WellBeing extends StatefulWidget {
  const WellBeing({super.key});

  @override
  State<WellBeing> createState() => _WellBeingState();
}

class _WellBeingState extends State<WellBeing> {
  Future<String>? _videoIdFuture;

  @override
  void initState() {
    super.initState();
    _videoIdFuture = searchMeditationVideo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _videoIdFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          var _controller = YoutubePlayerController(
            initialVideoId: snapshot.data!,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
              isLive: false,
            ),
          );

          return YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
              progressColors: const ProgressBarColors(
                playedColor: Colors.amber,
                handleColor: Colors.amberAccent,
              ),
            ),
            builder: (context, player) {
              return Scaffold(
                appBar: wellnessAppBar(),
                body: player,
              );
            },
          );
        }
      },
    );
  }

  AppBar wellnessAppBar() {
    return AppBar(
      backgroundColor: Colors.white24,
      title: const Text(
        "Well-being",
        style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins'),
      ),
    );
  }
}