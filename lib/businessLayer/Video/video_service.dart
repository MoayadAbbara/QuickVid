import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:quick_vid/keys.dart';
import 'package:quick_vid/models/video.dart';

class VideoService {
  Future<Video> fetchVideoInfo(String url) async {
    String videoId = getIdFromUrl(url);
    final response = await http.get(Uri.parse('${yotubeApiBaseUrl}videos?part=snippet,contentDetails&id=$videoId&key=$youtubeApiKey'));
    if (response.statusCode == 200) {
      Map jsonResponse = json.decode(response.body);
      Map<String, dynamic> videoInfoMap = {
        'id': jsonResponse['items'][0]['id'],
        'title': jsonResponse['items'][0]['snippet']['title'],
        'img_url': jsonResponse['items'][0]['snippet']['thumbnails']['standard']['url'],
        'channel': jsonResponse['items'][0]['snippet']['channelTitle'],
        'duration': formatDuration(jsonResponse['items'][0]['contentDetails']['duration']),
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

  Future<String> summarizeVideoText(String videoId) async {
    String transkript = await getVideoTranskript(videoId);
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0.75,
        topK: 15,
        topP: 0.90,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
      systemInstruction: Content.system(
          "You are tasked with summarizing a transcript extracted from a YouTube video. Your goal is to condense the content while ensuring that all the key information is retained. The summary should be about 40% of the original text's word count. For example, if the original text is 1000 words, your summary should be approximately 400 words.\nEnsure that you highlight all major points and key ideas from the video. Remove any repetitive, irrelevant, or minor details. The summary should maintain the core message and tone of the original content, presenting the important facts and insights concisely.\nThe summary should use the same language as the original transcript. If the transcript is in English, the summary should be in English. If the transcript is in Arabic, the summary should be in Arabic, and so on."),
    );
    final chat = model.startChat(history: []);
    final content = Content.text(transkript);
    final response = await chat.sendMessage(content);
    return response.text!;
  }

  Future<String> summarizeWithGpt(String videoId) async {
    String transcript = await getVideoTranskript(videoId);

    String apiKey = openAiKey;

    String apiUrl = openAiBaseUrl;

    final Map<String, dynamic> requestPayload = {
      "model": "gpt-4o",
      "messages": [
        {
          "role": "system",
          "content":
              "You are tasked with summarizing a transcript extracted from a YouTube video. Your goal is to condense the content while ensuring that all the key information is retained. The summary should be about 40% of the original text's word count. For example, if the original text is 1000 words, your summary should be approximately 400 words.\nEnsure that you highlight all major points and key ideas from the video. Remove any repetitive, irrelevant, or minor details. The summary should maintain the core message and tone of the original content, presenting the important facts and insights concisely.\nThe summary should use the same language as the original transcript. If the transcript is in English, the summary should be in English. If the transcript is in Arabic, the summary should be in Arabic, and so on."
        },
        {"role": "user", "content": transcript}
      ],
      "temperature": 1,
      "max_tokens": 2048,
      "top_p": 1,
      "frequency_penalty": 0,
      "presence_penalty": 0
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: json.encode(requestPayload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        String summary = responseBody['choices'][0]['message']['content'];
        return summary;
      } else {
        throw Exception('Failed to get summary: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error during API call: $error');
    }
  }

  Future<Map<String, dynamic>> evaluateSummariesWithGpt({
    required String videoId,
    required String summaryGpt,
    required String summaryGemini,
  }) async {
    // OpenAI API key
    String apiKey = openAiKey;

    // API endpoint
    const String apiUrl = "https://api.openai.com/v1/chat/completions";
    String transcript = await getVideoTranskript(videoId);
    // Request payload
    final Map<String, dynamic> requestPayload = {
      "model": "gpt-4o",
      "messages": [
        {
          "role": "system",
          "content": "I will provide you with:\n"
              "1. The full transcript of a video.\n"
              "2. Two summaries generated by different algorithms (GEMINI and GPT).\n\n"
              "Your task is to evaluate these summaries based on the following metrics:\n"
              "- Relevance: How well each summary reflects the main points of the transcript.\n"
              "- Conciseness: Whether the summaries are succinct while retaining important details.\n"
              "- Clarity: How easy each summary is to understand.\n"
              "- Accuracy: Whether the summaries avoid false or misleading information.\n"
              "- Coverage: The extent to which each summary includes key aspects of the transcript.\n"
              "- Fluency: The grammatical and stylistic quality of each summary.\n\n"
              "For each metric, assign a score from 1 to 100 for both summaries.(the first score is for Gemini, and the second score is for GPT) Your output must be in JSON format like this:\n"
              "{\n"
              "  \"Relevance\": [85, 82],\n"
              "  \"Conciseness\": [90, 88],\n"
              "  \"Clarity\": [87, 85],\n"
              "  ...\n"
              "\"Total\": [80, 85]\n"
              "}"
        },
        {"role": "user", "content": "Transcript:\n$transcript\n\nSummary GPT:\n$summaryGpt\n\nSummary GEMINI:\n$summaryGemini"}
      ],
      "temperature": 1,
      "max_tokens": 2048,
      "top_p": 1,
      "frequency_penalty": 0,
      "presence_penalty": 0
    };

    try {
      // Making the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: json.encode(requestPayload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        String evaluationJson = responseBody['choices'][0]['message']['content'];
        evaluationJson = evaluationJson.trim().replaceAll('```json', '').replaceAll('```', '');
        print(evaluationJson);
        return jsonDecode(evaluationJson);
      } else {
        throw Exception('Failed to get evaluation: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error during API call: $error');
    }
  }
}
