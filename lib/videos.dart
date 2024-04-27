import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;
import 'app_ui.dart';


class Videos extends StatefulWidget {
  const Videos({Key? key}) : super(key: key);

  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  late final YoutubePlayerController _controller;
  bool isFullScreen = false;
  String videoTitle = '';

  // List of video URLs
  final List<String> videoUrls = [
    'https://www.youtube.com/watch?v=HG68Ymazo18',
    'https://www.youtube.com/watch?v=OVAMb6Kui6A', // Add more URLs as needed
    'https://www.youtube.com/watch?v=KukmClH1KoA',
    'https://www.youtube.com/watch?v=wIjK-6Do6lg',
    'https://www.youtube.com/watch?v=vsXVnheCeaw',
    'https://www.youtube.com/watch?v=rw4s4M3hFfs',
    'https://www.youtube.com/watch?v=a5Z7pZgVfcQ',
    'https://www.youtube.com/watch?v=XC7eRmnfZ_A', // songs from Top 10 Songs to Listen to Before an Interview
    'https://www.youtube.com/watch?v=n3VjKtROscQ',
    'https://www.youtube.com/watch?v=p4KYRuo1C-o',
  ];


  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrls.first)!,
      flags: const YoutubePlayerFlags(
        mute: false,
        loop: false,
        autoPlay: true,
      ),
    );

    _controller.addListener(() {
      if (_controller.value.isFullScreen != isFullScreen) {
        setState(() {
          isFullScreen = _controller.value.isFullScreen;
          if (isFullScreen) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
          } else {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
          }
        });
      }
    });
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !isFullScreen ? AppBar(
        title: const Text('YouTube Player'),
      ) : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
            builder: (context, player) {
              return Column(
                children: [
                  player,
                  if (!isFullScreen && videoTitle.isNotEmpty) // Display video title if available and not in full screen
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        videoTitle,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              );
            },
          ),
          if (!isFullScreen)
            Expanded(
              child: SizedBox(
                height: 400, // Adjust height according to your needs
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: videoUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        _controller.load(YoutubePlayer.convertUrlToId(videoUrls[index])!);
                        setState(() {
                          videoTitle = _controller.metadata.title;
                        });
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 200, // Adjust thumbnail height
                                  color: Colors.grey, // Placeholder color
                                  child: Image.network(
                                    YoutubePlayer.getThumbnail(videoId: YoutubePlayer.convertUrlToId(videoUrls[index])!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(child: Icon(Icons.error)); // Show error icon if thumbnail fails to load
                                    },
                                  ),
                                ),
                                const Positioned.fill(
                                  child: Icon(
                                    Icons.play_circle_filled,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FutureBuilder(
                                future: _fetchVideoMetadata(videoUrls[index]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const LinearProgressIndicator(
                                      color: Color.fromRGBO(255, 32, 78, 1),
                                      backgroundColor: Color.fromRGBO(0, 34, 77, 1),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    var metadata = snapshot.data as VideoMetaData?;
                                    return Text(
                                      metadata?.title ?? 'Loading...', // Display video title or 'Loading...' if not available
                                      style: TextStyle(fontSize: 16),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          if (!isFullScreen)
            const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<VideoMetaData> _fetchVideoMetadata(String url) async {
    final yt.Video video = await yt.YoutubeExplode().videos.get(url);
    return VideoMetaData(title: video.title, thumbnailUrl: video.thumbnails.highResUrl);
  }
}

class VideoMetaData {
  final String title;
  final String thumbnailUrl;

  VideoMetaData({required this.title, required this.thumbnailUrl});
}