class Video {
  final String id;
  final String title;
  final String imgUrl;
  final String channel;
  final String duration;
  // late String script;

  Video(
      {required this.id,
      required this.title,
      required this.imgUrl,
      required this.channel,
      required this.duration});

  Video.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        imgUrl = json['img_url'],
        channel = json['channel'],
        duration = json['duration'];
}
