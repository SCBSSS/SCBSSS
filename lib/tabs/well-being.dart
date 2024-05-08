import 'package:flutter/cupertino.dart';
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
    _videoIdFuture = MeditationVideoSearcher().searchMeditationVideo();
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
        style: TextStyle(
            fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 25),
      ),
      elevation: 0,
      centerTitle: true,
      actions: [
        GestureDetector(
            onTap: () {
              showDialog(context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('What is the "Well-being" Tab?'),
                      content: const SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                                'This page is where SCBSSS recommends you a Youtube meditation video based on your past five entries.'
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
              );
            },
            child: Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                width: 37,
                decoration: BoxDecoration(
                    color: const Color(0xffF7F8F8),
                    borderRadius: BorderRadius.circular(16)),
                child: const Icon(
                  CupertinoIcons.info_circle,
                  size: 30,
                )))
      ],
    );
  }
}
