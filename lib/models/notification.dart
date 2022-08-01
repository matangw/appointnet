class Notification{

  String topic;
  String title;
  String body;

  Notification({required this.topic, required this.title, required this.body});

  Map<String, dynamic> toJson(){
    return {
      'topic': topic,
      'title': title,
      'body': body
    };
  }
}