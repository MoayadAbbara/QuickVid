class Message {
  final String id;
  final String sender;
  final String content;
  late String videoId;

  Message(
    this.sender,
    this.content, {
    required this.id,
  });

  Message.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        sender = json['sender'],
        content = json['content'],
        videoId = json['video_id'];
}
