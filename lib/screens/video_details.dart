import 'package:flutter/material.dart';
import 'package:quick_vid/businessLayer/Video/video_service.dart';
import 'package:quick_vid/consts/strings.dart';
import 'package:quick_vid/models/video.dart';
import 'package:quick_vid/widgets/video_sub_info.dart';

class VideoDetails extends StatefulWidget {
  final String videoUrl;
  const VideoDetails({super.key, required this.videoUrl});

  @override
  State<VideoDetails> createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {
  VideoService videoService = VideoService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'QuickVid',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 73, 14, 10),
      ),
      body: FutureBuilder(
        future: videoService.fetchVideoInfo(widget.videoUrl),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            Video video = snapshot.data! as Video;
            return SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 2.15,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(30),
                        ),
                        color: Color.fromARGB(255, 73, 14, 10),
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  video.imgUrl,
                                  width: 380,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          // const SizedBox(height: 10),
                          Flexible(
                            child: Text(
                              video.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              VideoSubInfo(
                                  title: video.channel, icon: Icons.person),
                              VideoSubInfo(
                                  title: video.duration, icon: Icons.alarm),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: true,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: <Widget>[
                        optionsCard(
                          'Get Video Transcript',
                          Icons.my_library_books,
                          video.id,
                          videoFullTranskript,
                          context,
                        ),
                        optionsCard(
                          'Get Summarized Transcript',
                          Icons.summarize,
                          video.id,
                          videoSummarizedTranskript,
                          context,
                        ),
                        optionsCard(
                          'Chat With Video',
                          Icons.video_chat,
                          video.id,
                          chat,
                          context,
                        ),
                        optionsCard(
                          'Take a Test About Video',
                          Icons.menu_book,
                          video.id,
                          videoFullTranskript,
                          context,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Check The URL And Try Again',
                style: TextStyle(fontSize: 24),
              ),
            );
          }
        },
      ),
    );
  }
}

Widget optionsCard(String text, IconData icon, String videoId, String route,
    BuildContext context) {
  return InkWell(
    onTap: () async {
      Navigator.pushNamed(context, route, arguments: {
        'VideoId': videoId,
      });
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 73, 14, 10),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 80,
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}
