import 'package:flutter/material.dart';
import 'package:quick_vid/businessLayer/Video/video_service.dart';

class FullTranskript extends StatefulWidget {
  final String videoId;
  const FullTranskript({super.key, required this.videoId});

  @override
  State<FullTranskript> createState() => _FullTranskriptState();
}

class _FullTranskriptState extends State<FullTranskript> {
  VideoService videoService = VideoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'QuickVid',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 73, 14, 10),
      ),
      body: FutureBuilder(
        future: videoService.getVideoTranskript(widget.videoId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 73, 14, 10),
              ),
            );
          } else if (snapshot.hasData) {
            String transkript = snapshot.data! as String;
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SingleChildScrollView(
                        child: SelectableText(
                          transkript,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Check The URL And Try Again',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }
        },
      ),
    );
  }
}
