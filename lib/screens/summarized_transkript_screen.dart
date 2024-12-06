import 'package:flutter/material.dart';
import 'package:quick_vid/businessLayer/Video/video_service.dart';

class SummarizedTranskript extends StatefulWidget {
  final String videoId;
  const SummarizedTranskript({super.key, required this.videoId});

  @override
  State<SummarizedTranskript> createState() => _SummarizedTranskriptState();
}

class _SummarizedTranskriptState extends State<SummarizedTranskript> {
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
        future: videoService.SummarizeVideoText(widget.videoId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            String Transkript = snapshot.data! as String;
            return SingleChildScrollView(
              child: SafeArea(
                child: Column(children: [
                  Text(
                    Transkript,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ]),
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
