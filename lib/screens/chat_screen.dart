import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:quick_vid/businessLayer/Video/video_service.dart';

class ChatScreen extends StatefulWidget {
  final String videoId;
  const ChatScreen({super.key, required this.videoId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  VideoService v = VideoService();
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(id: "1", firstName: "Gemini");
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  List<Content> chats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Chat'),
        centerTitle: true,
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      currentUser: currentUser,
      onSend: sendMessage,
      messages: messages,
    );
  }

  void sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String transkript = await v.getVideoTranskript(widget.videoId);
      String question = chatMessage.text;
      Content chatContent = Content(parts: [Part.text(question)], role: 'user');
      chats = [...chats, chatContent];
      gemini
          .chat(chats,
              systemPrompt:
                  "You are a chatbot within the QuickVid app. Your role is to assist users by answering questions based on the transcript of the video they provide. If a user asks a question related to the video, respond with the relevant information from the transcript. If the question is unrelated to the video content, answer with: 'The video you provided doesn't talk about this concept. I can't access it.'Never mention that you are provided by Google, Bard, or Gemini. Instead, always say: 'I am a QuickVid app chatbot here to help you understand the videos better.The Transkript is : $transkript")
          .then((response) {
        if (response != null) {
          String geminiResponse = response.output ?? 'No response received.';
          ChatMessage replyMessage = ChatMessage(
            user: geminiUser,
            text: geminiResponse,
            createdAt: DateTime.now(),
          );
          chats = [
            ...chats,
            Content(parts: [Part.text(question)], role: 'model'),
          ];
          setState(() {
            messages = [replyMessage, ...messages];
          });
          // for (int i = 0; i < chats.length; i++) {
          //   print(chats[i].parts![0]);
          // }
        }
      }).catchError((e) {
        print('Error occurred while sending message to Gemini: $e');
      });
    } catch (e) {
      print('Error: $e');
    }
  }
}
