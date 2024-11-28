import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_vid/keys.dart';
import 'package:quick_vid/models/video.dart';

class VideoService {
  Future<Video> fetchVideoInfo(String url) async {
    String videoId = getIdFromUrl(url);
    final response = await http.get(Uri.parse(
        '${yotubeApiBaseUrl}videos?part=snippet,contentDetails&id=$videoId&key=$youtubeApiKey'));
    if (response.statusCode == 200) {
      Map jsonResponse = json.decode(response.body);
      Map<String, dynamic> videoInfoMap = {
        'id': jsonResponse['items'][0]['id'],
        'title': jsonResponse['items'][0]['snippet']['title'],
        'img_url': jsonResponse['items'][0]['snippet']['thumbnails']['standard']
            ['url'],
        'channel': jsonResponse['items'][0]['snippet']['channelTitle'],
        'duration': formatDuration(
            jsonResponse['items'][0]['contentDetails']['duration']),
      };
      Video vid = Video.fromJson(videoInfoMap);
      return vid;
    } else {
      throw Exception('Failed to load info');
    }
  }

  Future<String> getVideoTranskript(String videoId) async {
    final response = await http.post(
      Uri.parse('${flaskAppBaseUrl}get_transcript'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'videoId': videoId,
      }),
    );

    if (response.statusCode == 200) {
      Map jsonResponse = json.decode(response.body);
      String transcript = jsonResponse['transcript'];
      return transcript;
    } else {
      throw Exception('Failed to load info');
    }
  }

  String getIdFromUrl(String url) {
    String? videoId;
    final RegExp regex = RegExp(
      r'^(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
      multiLine: false,
    );
    final Match? match = regex.firstMatch(url);
    if (match != null && match.groupCount >= 1) {
      videoId = match.group(1);
    }
    return videoId!;
  }

  String formatDuration(String isoDuration) {
    final regex = RegExp(r"PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?");
    final match = regex.firstMatch(isoDuration);
    int hours = match!.group(1) != null ? int.parse(match.group(1)!) : 0;
    int minutes = match.group(2) != null ? int.parse(match.group(2)!) : 0;
    if (hours > 0) {
      return '$hours Hour $minutes Min';
    } else {
      return '$minutes Min';
    }
  }
}
